// backend/src/service-requests/service-requests.service.ts
import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ServiceRequest, ServiceRequestStatus } from '../entities/service-request.entity';
import { CreateServiceRequestDto } from './dto/create-service-request';
import { CompleteServiceRequestDto } from './dto/complete-service-request.dto';
import { ServiceRequestResponseDto } from './dto/service-request-response.dto';
// import { CreateServiceRequestDto } from './dto/create-service-request.dto';

@Injectable()
export class ServiceRequestsService {
  constructor(
    @InjectRepository(ServiceRequest)
    private serviceRequestRepository: Repository<ServiceRequest>,
  ) {}

  async create(
    createServiceRequestDto: CreateServiceRequestDto,
    clientId: string,
  ): Promise<ServiceRequest> {
    const serviceRequest = this.serviceRequestRepository.create({
      ...createServiceRequestDto,
      clientId,
    });
    return this.serviceRequestRepository.save(serviceRequest);
  }

  async findAll(): Promise<ServiceRequestResponseDto[]> {
    const serviceRequests = await this.serviceRequestRepository.find({
      relations: ['assignedPrestataire'],
      order: { createdAt: 'DESC' },
    });

    return serviceRequests.map(request => {
      const requestWithNames = {
        ...request,
        assignedPrestataireName: request.assignedPrestataire ? 
          `${request.assignedPrestataire.firstName} ${request.assignedPrestataire.lastName}` : 
          request.prestataireName || 'Prestataire inconnu',
      };
      return new ServiceRequestResponseDto(requestWithNames);
    });
  }

  async findByClient(clientId: string): Promise<ServiceRequestResponseDto[]> {
    const serviceRequests = await this.serviceRequestRepository.find({
      where: { clientId },
      relations: ['assignedPrestataire'],
      order: { createdAt: 'DESC' },
    });

    return serviceRequests.map(request => {
      const requestWithNames = {
        ...request,
        assignedPrestataireName: request.assignedPrestataire ? 
          `${request.assignedPrestataire.firstName} ${request.assignedPrestataire.lastName}` : 
          request.prestataireName || 'Prestataire inconnu',
      };
      return new ServiceRequestResponseDto(requestWithNames);
    });
  }

  async findByPrestataire(prestataireId: string): Promise<ServiceRequestResponseDto[]> {
    const serviceRequests = await this.serviceRequestRepository.find({
      where: { assignedPrestataireId: prestataireId },
      relations: ['assignedPrestataire'],
      order: { createdAt: 'DESC' },
    });

    return serviceRequests.map(request => {
      const requestWithNames = {
        ...request,
        assignedPrestataireName: request.assignedPrestataire ? 
          `${request.assignedPrestataire.firstName} ${request.assignedPrestataire.lastName}` : 
          request.prestataireName || 'Prestataire inconnu',
      };
      return new ServiceRequestResponseDto(requestWithNames);
    });
  }

  async findOne(id: string): Promise<ServiceRequestResponseDto> {
    const serviceRequest = await this.serviceRequestRepository.findOne({
      where: { id },
      relations: ['assignedPrestataire'],
    });

    if (!serviceRequest) {
      throw new NotFoundException('Demande de service non trouvée');
    }

    const requestWithNames = {
      ...serviceRequest,
      assignedPrestataireName: serviceRequest.assignedPrestataire ? 
        `${serviceRequest.assignedPrestataire.firstName} ${serviceRequest.assignedPrestataire.lastName}` : 
        serviceRequest.prestataireName || 'Prestataire inconnu',
    };

    return new ServiceRequestResponseDto(requestWithNames);
  }

  async update(
    id: string,
    updateData: Partial<CreateServiceRequestDto>,
  ): Promise<ServiceRequestResponseDto> {
    await this.serviceRequestRepository.update(id, updateData);
    return this.findOne(id);
  }

  async assignPrestataire(
    id: string,
    prestataireId: string,
    prestataireName: string,
  ): Promise<ServiceRequestResponseDto> {
    await this.serviceRequestRepository.update(id, {
      assignedPrestataireId: prestataireId,
      prestataireName,
      status: 'assigned' as any,
    });
    return this.findOne(id);
  }

  async remove(id: string): Promise<void> {
    const result = await this.serviceRequestRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException('Demande de service non trouvée');
    }
  }

  async completeServiceRequest(
    id: string,
    completeServiceRequestDto: CompleteServiceRequestDto,
    clientId: string,
  ): Promise<ServiceRequestResponseDto> {
    const serviceRequest = await this.findOne(id);

    // Vérifier que c'est bien le client qui clôture
    if (serviceRequest.clientId !== clientId) {
      throw new ForbiddenException('Vous ne pouvez pas clôturer cette demande');
    }

    // Vérifier que la demande est assignée
    if (serviceRequest.status !== ServiceRequestStatus.ASSIGNED && 
        serviceRequest.status !== ServiceRequestStatus.IN_PROGRESS) {
      throw new ForbiddenException('Seules les demandes assignées peuvent être clôturées');
    }

    // Mettre à jour la demande
    await this.serviceRequestRepository.update(id, {
      status: ServiceRequestStatus.COMPLETED,
      completionDate: new Date(completeServiceRequestDto.completionDate),
      completionNotes: completeServiceRequestDto.completionNotes,
    });

    return this.findOne(id);
  }
}
