import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Review } from '../entities/review.entity';
import { ServiceRequest } from '../entities/service-request.entity';
import { CreateReviewDto } from './dto/create-review.dto';
import { ReviewResponseDto } from './dto/review-response.dto';

@Injectable()
export class ReviewsService {
  constructor(
    @InjectRepository(Review)
    private reviewRepository: Repository<Review>,
    @InjectRepository(ServiceRequest)
    private serviceRequestRepository: Repository<ServiceRequest>,
  ) {}

  async create(createReviewDto: CreateReviewDto, clientId: string): Promise<Review> {
    const { serviceRequestId, prestataireId, rating, comment } = createReviewDto;

    // Vérifier que la demande de service existe et appartient au client
    const serviceRequest = await this.serviceRequestRepository.findOne({
      where: { id: serviceRequestId },
    });

    if (!serviceRequest) {
      throw new NotFoundException('Demande de service non trouvée');
    }

    if (serviceRequest.clientId !== clientId) {
      throw new ForbiddenException('Vous ne pouvez pas évaluer cette demande');
    }

    if (serviceRequest.status !== 'completed') {
      throw new ForbiddenException('Vous ne pouvez évaluer que les demandes terminées');
    }

    // Vérifier qu'il n'y a pas déjà un avis pour cette demande
    const existingReview = await this.reviewRepository.findOne({
      where: { serviceRequestId },
    });

    if (existingReview) {
      throw new ForbiddenException('Vous avez déjà évalué cette demande');
    }

    // Créer l'avis
    const review = this.reviewRepository.create({
      serviceRequestId,
      prestataireId,
      clientId,
      rating,
      comment,
    });

    return this.reviewRepository.save(review);
  }

  async findByPrestataire(prestataireId: string): Promise<ReviewResponseDto[]> {
    const reviews = await this.reviewRepository.find({
      where: { prestataireId },
      relations: ['client', 'serviceRequest'],
      order: { createdAt: 'DESC' },
    });

    return reviews.map(review => {
      const reviewWithNames = {
        ...review,
        clientName: review.client ? 
          `${review.client.firstName} ${review.client.lastName}` : 
          'Client inconnu',
        serviceRequestTitle: review.serviceRequest ? 
          review.serviceRequest.title : 
          'Demande inconnue',
      };
      return new ReviewResponseDto(reviewWithNames);
    });
  }

  async getPrestataireAverageRating(prestataireId: string): Promise<number> {
    const result = await this.reviewRepository
      .createQueryBuilder('review')
      .select('AVG(review.rating)', 'average')
      .where('review.prestataireId = :prestataireId', { prestataireId })
      .getRawOne();

    return result?.average ? parseFloat(result.average) : 0;
  }

  async getPrestataireReviewsCount(prestataireId: string): Promise<number> {
    return this.reviewRepository.count({
      where: { prestataireId },
    });
  }
}
