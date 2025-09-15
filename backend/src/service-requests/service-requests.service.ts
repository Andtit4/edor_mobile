// backend/src/service-requests/service-requests.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ServiceRequest } from '../entities/service-request.entity';
import { CreateServiceRequestDto } from './dto/create-service-request';
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

  async findAll(): Promise<ServiceRequest[]> {
    return this.serviceRequestRepository.find({
      order: { createdAt: 'DESC' },
    });
  }

  async findByClient(clientId: string): Promise<ServiceRequest[]> {
    return this.serviceRequestRepository.find({
      where: { clientId },
      order: { createdAt: 'DESC' },
    });
  }

  async findByPrestataire(prestataireId: string): Promise<ServiceRequest[]> {
    return this.serviceRequestRepository.find({
      where: { assignedPrestataireId: prestataireId },
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(id: string): Promise<ServiceRequest> {
    const serviceRequest = await this.serviceRequestRepository.findOne({
      where: { id },
    });

    if (!serviceRequest) {
      throw new NotFoundException('Demande de service non trouvée');
    }

    return serviceRequest;
  }

  async update(
    id: string,
    updateData: Partial<CreateServiceRequestDto>,
  ): Promise<ServiceRequest> {
    await this.serviceRequestRepository.update(id, updateData);
    return this.findOne(id);
  }

  async assignPrestataire(
    id: string,
    prestataireId: string,
    prestataireName: string,
  ): Promise<ServiceRequest> {
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
}
