// backend/src/service-requests/service-requests.service.ts
import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ServiceRequest, ServiceRequestStatus } from '../entities/service-request.entity';
import { CreateServiceRequestDto } from './dto/create-service-request';
import { CompleteServiceRequestDto } from './dto/complete-service-request.dto';
import { ServiceRequestResponseDto } from './dto/service-request-response.dto';
import { EmailService } from '../email/email.service';
import { NotificationsService } from '../notifications/notifications.service';
// import { CreateServiceRequestDto } from './dto/create-service-request.dto';

@Injectable()
export class ServiceRequestsService {
  constructor(
    @InjectRepository(ServiceRequest)
    private serviceRequestRepository: Repository<ServiceRequest>,
    private emailService: EmailService,
    private notificationsService: NotificationsService,
  ) {}

  async create(
    createServiceRequestDto: CreateServiceRequestDto,
    clientId: string,
    clientEmail?: string,
  ): Promise<ServiceRequest> {
    console.log('=== CREATING SERVICE REQUEST ===');
    console.log('Client ID:', clientId);
    console.log('Title:', createServiceRequestDto.title);
    console.log('Location:', createServiceRequestDto.location);
    console.log('Latitude:', createServiceRequestDto.latitude);
    console.log('Longitude:', createServiceRequestDto.longitude);
    console.log('Client Image:', createServiceRequestDto.clientImage);
    console.log('Photos:', createServiceRequestDto.photos);
    console.log('Photos type:', typeof createServiceRequestDto.photos);
    console.log('Photos length:', createServiceRequestDto.photos?.length);
    console.log('===============================');
    
    const serviceRequest = this.serviceRequestRepository.create({
      ...createServiceRequestDto,
      clientId,
      photos: createServiceRequestDto.photos || [],
      clientImage: createServiceRequestDto.clientImage,
    });
    
    const savedServiceRequest = await this.serviceRequestRepository.save(serviceRequest);
    
    // Logs de débogage après sauvegarde
    const finalServiceRequest = Array.isArray(savedServiceRequest) ? savedServiceRequest[0] : savedServiceRequest;
    console.log('=== APRÈS SAUVEGARDE ===');
    console.log('Service Request ID:', finalServiceRequest.id);
    console.log('Photos sauvegardées:', finalServiceRequest.photos);
    console.log('Photos type:', typeof finalServiceRequest.photos);
    console.log('Photos length:', finalServiceRequest.photos?.length);
    console.log('========================');
    
    // Envoyer l'email de confirmation au client si l'email est fourni
    if (clientEmail && Array.isArray(savedServiceRequest) ? savedServiceRequest[0] : savedServiceRequest) {
      const serviceRequest = Array.isArray(savedServiceRequest) ? savedServiceRequest[0] : savedServiceRequest;
      
      // Convertir la deadline en Date si c'est une chaîne
      const deadlineDate = typeof serviceRequest.deadline === 'string' 
        ? new Date(serviceRequest.deadline)
        : serviceRequest.deadline;
      
      await this.emailService.sendServiceRequestConfirmation(
        clientEmail!,
        createServiceRequestDto.clientName,
        {
          id: serviceRequest.id,
          title: serviceRequest.title,
          description: serviceRequest.description,
          category: serviceRequest.category,
          location: serviceRequest.location,
          budget: serviceRequest.budget,
          deadline: deadlineDate.toLocaleDateString('fr-FR'),
        }
      );
    }

    // Envoyer des notifications push aux prestataires de la catégorie
    try {
      const serviceRequest = Array.isArray(savedServiceRequest) ? savedServiceRequest[0] : savedServiceRequest;
      
      await this.notificationsService.sendNotificationToCategory(
        createServiceRequestDto.category,
        {
          title: `Nouvelle demande ${createServiceRequestDto.category}`,
          body: `${createServiceRequestDto.title} - ${createServiceRequestDto.location} - Budget: ${createServiceRequestDto.budget}€`,
          data: {
            requestId: serviceRequest.id,
            category: createServiceRequestDto.category,
            location: createServiceRequestDto.location,
            budget: createServiceRequestDto.budget.toString(),
            deadline: createServiceRequestDto.deadline,
          }
        }
      );
      
      console.log(`🔔 Notifications envoyées aux prestataires de la catégorie ${createServiceRequestDto.category}`);
    } catch (notificationError) {
      console.error('❌ Erreur lors de l\'envoi des notifications:', notificationError);
      // Ne pas faire échouer la création de demande si les notifications échouent
    }
    
    return Array.isArray(savedServiceRequest) ? savedServiceRequest[0] : savedServiceRequest;
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

  async findOne(id: string, requestingUserId?: string, userRole?: string): Promise<ServiceRequestResponseDto> {
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

    // Contrôle d'accès aux coordonnées GPS
    const response = new ServiceRequestResponseDto(requestWithNames);
    
    // Si la demande est terminée, masquer les coordonnées pour tous les prestataires
    if (serviceRequest.status === ServiceRequestStatus.COMPLETED) {
      response.latitude = undefined;
      response.longitude = undefined;
    }
    // Si c'est un prestataire qui demande et que ce n'est pas le prestataire assigné
    else if (userRole === 'prestataire' && serviceRequest.assignedPrestataireId !== requestingUserId) {
      response.latitude = undefined;
      response.longitude = undefined;
    }
    // Si c'est un client qui demande et que ce n'est pas son client
    else if (userRole === 'client' && serviceRequest.clientId !== requestingUserId) {
      response.latitude = undefined;
      response.longitude = undefined;
    }

    return response;
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

