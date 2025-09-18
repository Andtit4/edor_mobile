// backend/src/prestataires/prestataire.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Prestataire } from '../entities/prestataire.entity';
import { CreatePrestataireDto } from './dto/create-prestataire.dto';
import { UpdatePrestataireProfileDto } from './dto/update-prestataire-profile.dto';
import { PrestataireWithStatsDto } from './dto/prestataire-with-stats.dto';
import { Review } from '../entities/review.entity';
import { ServiceRequest, ServiceRequestStatus } from '../entities/service-request.entity';

@Injectable()
export class PrestatairesService {
  constructor(
    @InjectRepository(Prestataire)
    private prestataireRepository: Repository<Prestataire>,
    @InjectRepository(Review)
    private reviewRepository: Repository<Review>,
    @InjectRepository(ServiceRequest)
    private serviceRequestRepository: Repository<ServiceRequest>,
  ) {}

  async create(
    createPrestataireDto: CreatePrestataireDto,
  ): Promise<Prestataire> {
    const prestataire = this.prestataireRepository.create({
      ...createPrestataireDto,
      skills: createPrestataireDto.skills || [], // Valeur par défaut dans le code
      portfolio: createPrestataireDto.portfolio || [], // Valeur par défaut dans le code
    });
    return this.prestataireRepository.save(prestataire);
  }

  async findAll(): Promise<PrestataireWithStatsDto[]> {
    const prestataires = await this.prestataireRepository.find({
      where: { isAvailable: true },
      order: { rating: 'DESC', createdAt: 'DESC' },
    });

    // Enrichir chaque prestataire avec les vraies statistiques
    const enrichedPrestataires = await Promise.all(
      prestataires.map(async (prestataire) => {
        // Récupérer les avis pour ce prestataire
        const reviews = await this.reviewRepository.find({
          where: { prestataireId: prestataire.id },
        });

        // Calculer la note moyenne et le nombre d'avis
        const totalReviews = reviews.length;
        const averageRating = totalReviews > 0 
          ? reviews.reduce((sum, review) => sum + review.rating, 0) / totalReviews 
          : 0;

        // Récupérer le nombre de travaux terminés
        const completedJobs = await this.serviceRequestRepository.count({
          where: { 
            assignedPrestataireId: prestataire.id,
            status: ServiceRequestStatus.COMPLETED,
          },
        });

        // Retourner le prestataire avec les vraies statistiques
        const enrichedPrestataire = Object.assign(new PrestataireWithStatsDto(), prestataire);
        enrichedPrestataire.rating = Math.round(averageRating * 10) / 10; // Arrondir à 1 décimale
        enrichedPrestataire.totalReviews = totalReviews;
        enrichedPrestataire.completedJobs = completedJobs;
        return enrichedPrestataire;
      })
    );

    // Trier par note moyenne réelle
    return enrichedPrestataires.sort((a, b) => b.rating - a.rating);
  }

  async findOne(id: string): Promise<PrestataireWithStatsDto> {
    const prestataire = await this.prestataireRepository.findOne({
      where: { id },
      relations: ['serviceOffers'],
    });

    if (!prestataire) {
      throw new NotFoundException('Prestataire non trouvé');
    }

    // Enrichir avec les vraies statistiques
    const reviews = await this.reviewRepository.find({
      where: { prestataireId: prestataire.id },
    });

    const totalReviews = reviews.length;
    const averageRating = totalReviews > 0 
      ? reviews.reduce((sum, review) => sum + review.rating, 0) / totalReviews 
      : 0;

    const completedJobs = await this.serviceRequestRepository.count({
      where: { 
        assignedPrestataireId: prestataire.id,
        status: ServiceRequestStatus.COMPLETED,
      },
    });

    const enrichedPrestataire = Object.assign(new PrestataireWithStatsDto(), prestataire);
    enrichedPrestataire.rating = Math.round(averageRating * 10) / 10;
    enrichedPrestataire.totalReviews = totalReviews;
    enrichedPrestataire.completedJobs = completedJobs;
    return enrichedPrestataire;
  }

  async findByCategory(category: string): Promise<Prestataire[]> {
    return this.prestataireRepository.find({
      where: { category, isAvailable: true },
      order: { rating: 'DESC' },
    });
  }

  async update(
    id: string,
    updateData: Partial<CreatePrestataireDto>,
  ): Promise<Prestataire> {
    await this.prestataireRepository.update(id, updateData);
    return this.findOne(id);
  }

  async remove(id: string): Promise<void> {
    const result = await this.prestataireRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException('Prestataire non trouvé');
    }
  }

  async findByUserId(userId: string): Promise<Prestataire> {
    const prestataire = await this.prestataireRepository.findOne({
      where: { email: userId }, // On utilise l'email comme lien entre User et Prestataire
    });

    if (!prestataire) {
      throw new NotFoundException('Profil prestataire non trouvé');
    }

    return prestataire;
  }

  async updateByUserId(
    userId: string,
    updateData: UpdatePrestataireProfileDto,
  ): Promise<Prestataire> {
    const prestataire = await this.findByUserId(userId);
    await this.prestataireRepository.update(prestataire.id, updateData);
    return this.findOne(prestataire.id);
  }
}
