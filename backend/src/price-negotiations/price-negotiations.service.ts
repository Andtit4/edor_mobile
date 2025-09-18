// backend/src/price-negotiations/price-negotiations.service.ts
import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PriceNegotiation, NegotiationStatus } from '../entities/price-negotiation.entity';
import { ServiceRequest, ServiceRequestStatus } from '../entities/service-request.entity';
import { CreatePriceNegotiationDto } from './dto/create-price-negotiation.dto';
import { UpdatePriceNegotiationDto } from './dto/update-price-negotiation.dto';
import { PriceNegotiationResponseDto } from './dto/price-negotiation-response.dto';
import { EmailService } from '../email/email.service';

@Injectable()
export class PriceNegotiationsService {
  constructor(
    @InjectRepository(PriceNegotiation)
    private priceNegotiationRepository: Repository<PriceNegotiation>,
    @InjectRepository(ServiceRequest)
    private serviceRequestRepository: Repository<ServiceRequest>,
    private emailService: EmailService,
  ) {}

  async create(
    createPriceNegotiationDto: CreatePriceNegotiationDto,
    userId: string,
    userRole: 'client' | 'prestataire',
  ): Promise<PriceNegotiation> {
    const { serviceRequestId, proposedPrice, message, parentNegotiationId } = createPriceNegotiationDto;

    // Vérifier que la demande de service existe
    const serviceRequest = await this.serviceRequestRepository.findOne({
      where: { id: serviceRequestId },
    });

    if (!serviceRequest) {
      throw new NotFoundException('Demande de service non trouvée');
    }

    // Vérifier les permissions
    if (userRole === 'client' && serviceRequest.clientId !== userId) {
      throw new ForbiddenException('Vous ne pouvez pas négocier cette demande');
    }

    // Pour les prestataires, ils peuvent faire des propositions même s'ils ne sont pas encore assignés
    // La vérification se fera au moment de l'acceptation par le client

    // Si c'est une contre-proposition, vérifier que la négociation parent existe
    let parentNegotiation: PriceNegotiation | null = null;
    if (parentNegotiationId) {
      parentNegotiation = await this.priceNegotiationRepository.findOne({
        where: { id: parentNegotiationId },
      });

      if (!parentNegotiation) {
        throw new NotFoundException('Négociation parent non trouvée');
      }

      // Mettre à jour le statut de la négociation parent
      await this.priceNegotiationRepository.update(parentNegotiationId, {
        status: NegotiationStatus.COUNTERED,
      });
    }

    // Créer la nouvelle négociation
    const negotiation = this.priceNegotiationRepository.create({
      serviceRequestId,
      prestataireId: userRole === 'prestataire' ? userId : serviceRequest.assignedPrestataireId,
      clientId: serviceRequest.clientId,
      proposedPrice,
      message,
      isFromPrestataire: userRole === 'prestataire',
      parentNegotiationId,
      status: NegotiationStatus.PENDING,
    });

    const savedNegotiation = await this.priceNegotiationRepository.save(negotiation);

    // Envoyer un email de notification au client si c'est un prestataire qui fait une proposition
    if (userRole === 'prestataire') {
      // Récupérer les informations du prestataire et du client
      const negotiationWithDetails = await this.priceNegotiationRepository
        .createQueryBuilder('negotiation')
        .leftJoinAndSelect('negotiation.serviceRequest', 'serviceRequest')
        .leftJoinAndSelect('negotiation.prestataire', 'prestataire')
        .leftJoinAndSelect('negotiation.client', 'client')
        .where('negotiation.id = :id', { id: savedNegotiation.id })
        .getOne();

      if (negotiationWithDetails && negotiationWithDetails.client && negotiationWithDetails.prestataire) {
        await this.emailService.sendPriceProposalNotification(
          negotiationWithDetails.client.email,
          `${negotiationWithDetails.client.firstName} ${negotiationWithDetails.client.lastName}`,
          {
            requestId: negotiationWithDetails.serviceRequest.id,
            serviceTitle: negotiationWithDetails.serviceRequest.title,
            proposedPrice: negotiationWithDetails.proposedPrice,
            initialBudget: negotiationWithDetails.serviceRequest.budget,
            location: negotiationWithDetails.serviceRequest.location,
            prestataireName: `${negotiationWithDetails.prestataire.firstName} ${negotiationWithDetails.prestataire.lastName}`,
            prestataireCategory: negotiationWithDetails.prestataire.category || 'Service',
            prestataireRating: negotiationWithDetails.prestataire.rating || 0,
            prestataireReviews: negotiationWithDetails.prestataire.totalReviews || 0,
            message: negotiationWithDetails.message,
          }
        );
      }
    }

    return savedNegotiation;
  }

  async findByServiceRequest(serviceRequestId: string, userId: string): Promise<PriceNegotiationResponseDto[]> {
    // Vérifier que l'utilisateur a accès à cette demande
    const serviceRequest = await this.serviceRequestRepository.findOne({
      where: { id: serviceRequestId },
    });

    if (!serviceRequest) {
      throw new NotFoundException('Demande de service non trouvée');
    }

    if (serviceRequest.clientId !== userId && serviceRequest.assignedPrestataireId !== userId) {
      throw new ForbiddenException('Accès non autorisé à cette demande');
    }

    const negotiations = await this.priceNegotiationRepository
      .createQueryBuilder('negotiation')
      .leftJoinAndSelect('negotiation.serviceRequest', 'serviceRequest')
      .leftJoinAndSelect('negotiation.prestataire', 'prestataire')
      .leftJoinAndSelect('negotiation.client', 'client')
      .where('negotiation.serviceRequestId = :serviceRequestId', { serviceRequestId })
      .orderBy('negotiation.createdAt', 'ASC')
      .getMany();

    return negotiations.map(negotiation => {
      const negotiationWithNames = {
        ...negotiation,
        prestataireName: negotiation.prestataire ? 
          `${negotiation.prestataire.firstName} ${negotiation.prestataire.lastName}` : 
          'Prestataire inconnu',
        serviceRequestTitle: negotiation.serviceRequest ? 
          negotiation.serviceRequest.title : 
          'Demande inconnue',
        clientName: negotiation.client ? 
          `${negotiation.client.firstName} ${negotiation.client.lastName}` : 
          'Client inconnu',
      };
      return new PriceNegotiationResponseDto(negotiationWithNames);
    });
  }

  async updateStatus(
    id: string,
    updatePriceNegotiationDto: UpdatePriceNegotiationDto,
    userId: string,
  ): Promise<PriceNegotiation> {
    const negotiation = await this.priceNegotiationRepository.findOne({
      where: { id },
      relations: ['serviceRequest'],
    });

    if (!negotiation) {
      throw new NotFoundException('Négociation non trouvée');
    }

    // Vérifier que l'utilisateur peut modifier cette négociation
    const serviceRequest = negotiation.serviceRequest;
    if (serviceRequest.clientId !== userId && serviceRequest.assignedPrestataireId !== userId) {
      throw new ForbiddenException('Vous ne pouvez pas modifier cette négociation');
    }

    // Vérifier que l'utilisateur n'est pas celui qui a proposé la négociation
    if (negotiation.isFromPrestataire && serviceRequest.assignedPrestataireId === userId) {
      throw new ForbiddenException('Vous ne pouvez pas accepter votre propre proposition');
    }

    if (!negotiation.isFromPrestataire && serviceRequest.clientId === userId) {
      throw new ForbiddenException('Vous ne pouvez pas accepter votre propre proposition');
    }

    await this.priceNegotiationRepository.update(id, updatePriceNegotiationDto);

    // Si la négociation est acceptée, mettre à jour le budget de la demande
    if (updatePriceNegotiationDto.status === NegotiationStatus.ACCEPTED) {
      await this.serviceRequestRepository.update(serviceRequest.id, {
        budget: negotiation.proposedPrice,
      });
    }

    const updatedNegotiation = await this.priceNegotiationRepository.findOne({ where: { id } });
    if (!updatedNegotiation) {
      throw new NotFoundException('Négociation non trouvée');
    }
    return updatedNegotiation;
  }

  async findOne(id: string, userId: string): Promise<PriceNegotiation> {
    const negotiation = await this.priceNegotiationRepository.findOne({
      where: { id },
      relations: ['serviceRequest', 'prestataire', 'client'],
    });

    if (!negotiation) {
      throw new NotFoundException('Négociation non trouvée');
    }

    // Vérifier les permissions
    const serviceRequest = negotiation.serviceRequest;
    if (serviceRequest.clientId !== userId && serviceRequest.assignedPrestataireId !== userId) {
      throw new ForbiddenException('Accès non autorisé à cette négociation');
    }

    return negotiation;
  }

  async remove(id: string, userId: string): Promise<void> {
    const negotiation = await this.priceNegotiationRepository.findOne({
      where: { id },
      relations: ['serviceRequest'],
    });

    if (!negotiation) {
      throw new NotFoundException('Négociation non trouvée');
    }

    // Vérifier que l'utilisateur peut supprimer cette négociation
    const serviceRequest = negotiation.serviceRequest;
    if (serviceRequest.clientId !== userId && serviceRequest.assignedPrestataireId !== userId) {
      throw new ForbiddenException('Vous ne pouvez pas supprimer cette négociation');
    }

    await this.priceNegotiationRepository.remove(negotiation);
  }

  // Récupérer toutes les négociations d'un client
  async findByClient(clientId: string): Promise<PriceNegotiationResponseDto[]> {
    const negotiations = await this.priceNegotiationRepository
      .createQueryBuilder('negotiation')
      .leftJoinAndSelect('negotiation.serviceRequest', 'serviceRequest')
      .leftJoinAndSelect('negotiation.prestataire', 'prestataire')
      .leftJoinAndSelect('negotiation.client', 'client')
      .where('negotiation.clientId = :clientId', { clientId })
      .orderBy('negotiation.createdAt', 'DESC')
      .getMany();

    return negotiations.map(negotiation => {
      const negotiationWithNames = {
        ...negotiation,
        prestataireName: negotiation.prestataire ? 
          `${negotiation.prestataire.firstName} ${negotiation.prestataire.lastName}` : 
          'Prestataire inconnu',
        serviceRequestTitle: negotiation.serviceRequest ? 
          negotiation.serviceRequest.title : 
          'Demande inconnue',
        clientName: negotiation.client ? 
          `${negotiation.client.firstName} ${negotiation.client.lastName}` : 
          'Client inconnu',
      };
      return new PriceNegotiationResponseDto(negotiationWithNames);
    });
  }

  // Accepter une négociation (assigner le prestataire et rejeter les autres)
  async acceptNegotiation(negotiationId: string, clientId: string): Promise<PriceNegotiationResponseDto> {
    const negotiation = await this.priceNegotiationRepository.findOne({
      where: { id: negotiationId },
      relations: ['serviceRequest', 'prestataire'],
    });

    if (!negotiation) {
      throw new NotFoundException('Négociation non trouvée');
    }

    // Vérifier que c'est bien le client qui accepte
    if (negotiation.clientId !== clientId) {
      throw new ForbiddenException('Vous ne pouvez pas accepter cette négociation');
    }

    const serviceRequest = negotiation.serviceRequest;

    // Assigner le prestataire à la demande
    await this.serviceRequestRepository.update(serviceRequest.id, {
      assignedPrestataireId: negotiation.prestataireId,
      status: ServiceRequestStatus.ASSIGNED,
    });

    // Accepter cette négociation
    await this.priceNegotiationRepository.update(negotiationId, {
      status: NegotiationStatus.ACCEPTED,
    });

    // Rejeter toutes les autres négociations pour cette demande
    await this.priceNegotiationRepository
      .createQueryBuilder()
      .update(PriceNegotiation)
      .set({ status: NegotiationStatus.REJECTED })
      .where('serviceRequestId = :serviceRequestId', { serviceRequestId: serviceRequest.id })
      .andWhere('id != :negotiationId', { negotiationId })
      .execute();

    // Retourner la négociation acceptée avec les noms
    const acceptedNegotiation = await this.priceNegotiationRepository.findOne({
      where: { id: negotiationId },
      relations: ['serviceRequest', 'prestataire', 'client'],
    });

    if (!acceptedNegotiation) {
      throw new NotFoundException('Négociation acceptée non trouvée');
    }

    const negotiationWithNames = {
      ...acceptedNegotiation,
      prestataireName: acceptedNegotiation.prestataire ? 
        `${acceptedNegotiation.prestataire.firstName} ${acceptedNegotiation.prestataire.lastName}` : 
        'Prestataire inconnu',
      serviceRequestTitle: acceptedNegotiation.serviceRequest ? 
        acceptedNegotiation.serviceRequest.title : 
        'Demande inconnue',
      clientName: acceptedNegotiation.client ? 
        `${acceptedNegotiation.client.firstName} ${acceptedNegotiation.client.lastName}` : 
        'Client inconnu',
    };

    // Envoyer un email de notification au prestataire
    if (acceptedNegotiation.prestataire && acceptedNegotiation.client) {
      await this.emailService.sendOfferAcceptedNotification(
        acceptedNegotiation.prestataire.email,
        `${acceptedNegotiation.prestataire.firstName} ${acceptedNegotiation.prestataire.lastName}`,
        {
          requestId: acceptedNegotiation.serviceRequest.id,
          serviceTitle: acceptedNegotiation.serviceRequest.title,
          acceptedPrice: acceptedNegotiation.proposedPrice,
          location: acceptedNegotiation.serviceRequest.location,
          deadline: acceptedNegotiation.serviceRequest.deadline.toLocaleDateString('fr-FR'),
          clientName: `${acceptedNegotiation.client.firstName} ${acceptedNegotiation.client.lastName}`,
          clientPhone: acceptedNegotiation.serviceRequest.clientPhone || 'Non renseigné',
          acceptanceDate: new Date().toLocaleDateString('fr-FR'),
          message: acceptedNegotiation.message,
        }
      );
    }

    return new PriceNegotiationResponseDto(negotiationWithNames);
  }
}
