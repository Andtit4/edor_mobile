import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ServiceRequest, ServiceRequestStatus } from '../entities/service-request.entity';
import { Review } from '../entities/review.entity';
import { CompleteServiceRequestDto } from './dto/complete-service-request.dto';

@Injectable()
export class ServiceCompletionService {
  constructor(
    @InjectRepository(ServiceRequest)
    private serviceRequestRepository: Repository<ServiceRequest>,
    @InjectRepository(Review)
    private reviewRepository: Repository<Review>,
  ) {}

  async completeServiceRequestWithReview(
    serviceRequestId: string,
    completeServiceRequestDto: CompleteServiceRequestDto,
    clientId: string,
  ): Promise<{ serviceRequest: ServiceRequest; review: Review }> {
    const serviceRequest = await this.serviceRequestRepository.findOne({
      where: { id: serviceRequestId },
    });

    if (!serviceRequest) {
      throw new NotFoundException('Demande de service non trouvée');
    }

    // Vérifier que c'est bien le client qui clôture
    if (serviceRequest.clientId !== clientId) {
      throw new ForbiddenException('Vous ne pouvez pas clôturer cette demande');
    }

    // Vérifier que la demande est assignée
    if (serviceRequest.status !== ServiceRequestStatus.ASSIGNED && 
        serviceRequest.status !== ServiceRequestStatus.IN_PROGRESS) {
      throw new ForbiddenException('Seules les demandes assignées peuvent être clôturées');
    }

    // Vérifier qu'il n'y a pas déjà un avis pour cette demande
    const existingReview = await this.reviewRepository.findOne({
      where: { serviceRequestId },
    });

    if (existingReview) {
      throw new ForbiddenException('Cette demande a déjà été évaluée');
    }

    // Mettre à jour la demande
    await this.serviceRequestRepository.update(serviceRequestId, {
      status: ServiceRequestStatus.COMPLETED,
      completionDate: new Date(completeServiceRequestDto.completionDate),
      completionNotes: completeServiceRequestDto.completionNotes,
    });

    // Créer l'avis
    const review = this.reviewRepository.create({
      serviceRequestId,
      prestataireId: serviceRequest.assignedPrestataireId!,
      clientId,
      rating: completeServiceRequestDto.rating,
      comment: completeServiceRequestDto.reviewComment,
    });

    const savedReview = await this.reviewRepository.save(review);

    // Récupérer la demande mise à jour
    const updatedServiceRequest = await this.serviceRequestRepository.findOne({
      where: { id: serviceRequestId },
    });

    if (!updatedServiceRequest) {
      throw new NotFoundException('Erreur lors de la mise à jour de la demande');
    }

    return {
      serviceRequest: updatedServiceRequest,
      review: savedReview,
    };
  }
}
