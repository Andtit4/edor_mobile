// backend/src/price-negotiations/price-negotiations.service.ts
import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PriceNegotiation, NegotiationStatus } from '../entities/price-negotiation.entity';
import { ServiceRequest } from '../entities/service-request.entity';
import { CreatePriceNegotiationDto } from './dto/create-price-negotiation.dto';
import { UpdatePriceNegotiationDto } from './dto/update-price-negotiation.dto';

@Injectable()
export class PriceNegotiationsService {
  constructor(
    @InjectRepository(PriceNegotiation)
    private priceNegotiationRepository: Repository<PriceNegotiation>,
    @InjectRepository(ServiceRequest)
    private serviceRequestRepository: Repository<ServiceRequest>,
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

    if (userRole === 'prestataire' && serviceRequest.assignedPrestataireId !== userId) {
      throw new ForbiddenException('Vous ne pouvez pas négocier cette demande');
    }

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
      prestataireId: serviceRequest.assignedPrestataireId,
      clientId: serviceRequest.clientId,
      proposedPrice,
      message,
      isFromPrestataire: userRole === 'prestataire',
      parentNegotiationId,
      status: NegotiationStatus.PENDING,
    });

    return this.priceNegotiationRepository.save(negotiation);
  }

  async findByServiceRequest(serviceRequestId: string, userId: string): Promise<PriceNegotiation[]> {
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

    return this.priceNegotiationRepository.find({
      where: { serviceRequestId },
      relations: ['prestataire', 'client'],
      order: { createdAt: 'ASC' },
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
}
