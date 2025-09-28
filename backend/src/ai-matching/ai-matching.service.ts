// backend/src/ai-matching/ai-matching.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AIMatch } from '../entities/ai-match.entity';
import { ServiceRequest, ServiceRequestStatus } from '../entities/service-request.entity';
import { Prestataire } from '../entities/prestataire.entity';
import { Review } from '../entities/review.entity';
import { AIMatchRequestDto, AIMatchResponseDto } from './dto/ai-match-request.dto';

@Injectable()
export class AIMatchingService {
  constructor(
    @InjectRepository(AIMatch)
    private aiMatchRepository: Repository<AIMatch>,
    @InjectRepository(ServiceRequest)
    private serviceRequestRepository: Repository<ServiceRequest>,
    @InjectRepository(Prestataire)
    private prestataireRepository: Repository<Prestataire>,
    @InjectRepository(Review)
    private reviewRepository: Repository<Review>,
  ) {}

  /**
   * Génère des recommandations IA pour une demande de service
   */
  async generateMatches(requestDto: AIMatchRequestDto): Promise<AIMatchResponseDto[]> {
    console.log('🔍 AI Matching - Début de generateMatches');
    console.log('📋 ServiceRequestId:', requestDto.serviceRequestId);
    
    const serviceRequest = await this.serviceRequestRepository.findOne({
      where: { id: requestDto.serviceRequestId },
    });

    if (!serviceRequest) {
      console.log('❌ ServiceRequest non trouvée');
      throw new NotFoundException('Demande de service non trouvée');
    }
    
    console.log('✅ ServiceRequest trouvée:', serviceRequest.title);

    // Récupérer tous les prestataires disponibles
    // D'abord essayer la catégorie exacte, puis tous les prestataires disponibles
    let prestataires = await this.prestataireRepository.find({
      where: { 
        category: serviceRequest.category,
        isAvailable: true,
      },
    });

    // Si aucun prestataire dans la catégorie exacte, prendre tous les disponibles
    if (prestataires.length === 0) {
      console.log('🔍 Aucun prestataire dans la catégorie exacte, recherche dans toutes les catégories...');
      prestataires = await this.prestataireRepository.find({
        where: { 
          isAvailable: true,
        },
      });
    }

    console.log('👥 Prestataires trouvés:', prestataires.length);
    console.log('📂 Catégorie recherchée:', serviceRequest.category);
    console.log('📋 Détails de la demande:', {
      title: serviceRequest.title,
      category: serviceRequest.category,
      location: serviceRequest.location,
      budget: serviceRequest.budget
    });

    if (prestataires.length === 0) {
      console.log('⚠️ Aucun prestataire trouvé pour cette catégorie');
      console.log('🔍 Vérification des prestataires en base...');
      
      // Vérifier tous les prestataires
      const allPrestataires = await this.prestataireRepository.find();
      console.log('📊 Total prestataires en base:', allPrestataires.length);
      console.log('📊 Prestataires par catégorie:', 
        allPrestataires.reduce((acc, p) => {
          acc[p.category] = (acc[p.category] || 0) + 1;
          return acc;
        }, {})
      );
      console.log('📊 Prestataires disponibles:', 
        allPrestataires.filter(p => p.isAvailable).length
      );
      
      return [];
    }

    // Calculer les scores pour chaque prestataire
    const matches = await Promise.all(
      prestataires.map(async (prestataire) => {
        const scores = await this.calculateMatchScores(serviceRequest, prestataire);
        return this.createAIMatch(serviceRequest, prestataire, scores);
      })
    );

    console.log('🔍 Matches calculés:', matches.length);
    console.log('📊 Scores des matches:', matches.map(m => ({
      prestataireId: m.prestataireId,
      compatibilityScore: m.compatibilityScore,
      skillsScore: m.skillsScore,
      performanceScore: m.performanceScore
    })));

    // Filtrer et trier les résultats
    const minScore = requestDto.minScore || 60;
    const maxDistance = requestDto.maxDistance || 50;
    
    console.log('🔍 Filtres appliqués:', { minScore, maxDistance });
    
    const filteredMatches = matches
      .filter(match => {
        const scoreOk = match.compatibilityScore >= minScore;
        const distanceOk = !match.distance || match.distance <= maxDistance;
        console.log(`🔍 Match ${match.prestataireId}: score=${match.compatibilityScore} (${scoreOk ? '✅' : '❌'}), distance=${match.distance} (${distanceOk ? '✅' : '❌'})`);
        return scoreOk && distanceOk;
      })
      .sort((a, b) => {
        switch (requestDto.sortBy) {
          case 'distance':
            return (a.distance || 0) - (b.distance || 0);
          case 'rating':
            return b.performanceScore - a.performanceScore;
          case 'price':
            return (a.estimatedPrice || 0) - (b.estimatedPrice || 0);
          case 'availability':
            return b.availabilityScore - a.availabilityScore;
          default:
            return b.compatibilityScore - a.compatibilityScore;
        }
      })
      .slice(0, requestDto.maxResults || 10);
      
    console.log('🔍 Matches après filtrage:', filteredMatches.length);

    console.log('💾 Sauvegarde de', filteredMatches.length, 'matches');
    
    // Sauvegarder les matches en base
    const savedMatches = await this.aiMatchRepository.save(filteredMatches);
    
    console.log('✅ Matches sauvegardés:', savedMatches.length);

    // Retourner les résultats avec les données du prestataire
    return Promise.all(
      savedMatches.map(async (match) => {
        const prestataire = await this.prestataireRepository.findOne({
          where: { id: match.prestataireId },
        });

        // Enrichir le prestataire avec les VRAIES données
        const enrichedPrestataire = prestataire ? await this.enrichPrestataireWithRealData(prestataire) : null;
        
        return {
          ...match.toJSON(),
          prestataire: enrichedPrestataire ? {
            id: enrichedPrestataire.id,
            name: enrichedPrestataire.name,
            firstName: enrichedPrestataire.firstName,
            lastName: enrichedPrestataire.lastName,
            email: enrichedPrestataire.email,
            phone: enrichedPrestataire.phone,
            category: enrichedPrestataire.category,
            location: enrichedPrestataire.location,
            address: enrichedPrestataire.address,
            city: enrichedPrestataire.city,
            bio: enrichedPrestataire.bio,
            rating: enrichedPrestataire.rating,
            reviewCount: enrichedPrestataire.totalReviews,
            pricePerHour: enrichedPrestataire.pricePerHour,
            skills: enrichedPrestataire.skills || [],
            portfolio: enrichedPrestataire.portfolio || [],
            profileImage: enrichedPrestataire.profileImage,
            isAvailable: enrichedPrestataire.isAvailable,
            completedJobs: enrichedPrestataire.completedJobs,
            totalReviews: enrichedPrestataire.totalReviews,
            totalEarnings: enrichedPrestataire.totalEarnings,
          } : undefined,
        };
      })
    );
  }

  /**
   * Calcule les scores de compatibilité pour un prestataire donné
   */
  private async calculateMatchScores(
    serviceRequest: ServiceRequest,
    prestataire: Prestataire,
  ): Promise<{
    skillsScore: number;
    performanceScore: number;
    locationScore: number;
    budgetScore: number;
    availabilityScore: number;
    compatibilityScore: number;
    distance?: number;
    estimatedPrice?: number;
    reasoning: string;
    matchingFactors: any;
  }> {
    // 1. Score des compétences (40% du score total)
    const skillsScore = this.calculateSkillsScore(serviceRequest, prestataire);

    // 2. Score de performance (25% du score total)
    const performanceScore = await this.calculatePerformanceScore(prestataire);

    // 3. Score de localisation (20% du score total)
    const { locationScore, distance } = this.calculateLocationScore(serviceRequest, prestataire);

    // 4. Score de budget (10% du score total)
    const { budgetScore, estimatedPrice } = this.calculateBudgetScore(serviceRequest, prestataire);

    // 5. Score de disponibilité (5% du score total)
    const availabilityScore = this.calculateAvailabilityScore(prestataire);

    // Score global pondéré
    const compatibilityScore = 
      (skillsScore * 0.4) +
      (performanceScore * 0.25) +
      (locationScore * 0.2) +
      (budgetScore * 0.1) +
      (availabilityScore * 0.05);

    // Génération du raisonnement
    const reasoning = this.generateReasoning({
      skillsScore,
      performanceScore,
      locationScore,
      budgetScore,
      availabilityScore,
      distance,
      estimatedPrice,
    });

    // Facteurs de matching
    const matchingFactors = this.generateMatchingFactors(serviceRequest, prestataire, {
      skillsScore,
      performanceScore,
      locationScore,
      budgetScore,
      availabilityScore,
      distance,
    });

    return {
      skillsScore,
      performanceScore,
      locationScore,
      budgetScore,
      availabilityScore,
      compatibilityScore: Math.round(compatibilityScore * 100) / 100,
      distance,
      estimatedPrice,
      reasoning,
      matchingFactors,
    };
  }

  /**
   * Calcule le score de compatibilité des compétences
   */
  private calculateSkillsScore(serviceRequest: ServiceRequest, prestataire: Prestataire): number {
    const requestCategory = serviceRequest.category.toLowerCase();
    const prestataireCategory = prestataire.category.toLowerCase();
    const prestataireSkills = (prestataire.skills || []).map(s => s.toLowerCase());

    let score = 0;

    // Correspondance exacte de catégorie (60 points)
    if (requestCategory === prestataireCategory) {
      score += 60;
    } else if (prestataireCategory.includes(requestCategory) || requestCategory.includes(prestataireCategory)) {
      score += 40;
    } else {
      // Même si les catégories ne correspondent pas, donner des points de base
      score += 20;
    }

    // Correspondance des compétences (40 points)
    const requestKeywords = this.extractKeywords(serviceRequest.description);
    const matchingSkills = prestataireSkills.filter(skill => 
      requestKeywords.some(keyword => skill.includes(keyword) || keyword.includes(skill))
    );

    if (matchingSkills.length > 0) {
      score += Math.min(40, (matchingSkills.length / Math.max(1, prestataireSkills.length)) * 40);
    } else {
      // Même sans compétences correspondantes, donner des points de base
      score += 10;
    }

    return Math.min(100, score);
  }

  /**
   * Calcule le score de performance basé sur l'historique
   */
  private async calculatePerformanceScore(prestataire: Prestataire): Promise<number> {
    // Récupérer les avis récents
    const reviews = await this.reviewRepository.find({
      where: { prestataireId: prestataire.id },
      order: { createdAt: 'DESC' },
      take: 10,
    });

    if (reviews.length === 0) {
      return 50; // Score neutre pour les nouveaux prestataires
    }

    const averageRating = reviews.reduce((sum, review) => sum + review.rating, 0) / reviews.length;
    const completionRate = Math.min(1, prestataire.completedJobs / Math.max(1, prestataire.completedJobs + 5));
    
    // Score basé sur la note moyenne (70%) et le taux de completion (30%)
    const score = (averageRating * 20 * 0.7) + (completionRate * 100 * 0.3);
    
    return Math.min(100, Math.max(0, score));
  }

  /**
   * Calcule le score de localisation
   */
  private calculateLocationScore(serviceRequest: ServiceRequest, prestataire: Prestataire): {
    locationScore: number;
    distance?: number;
  } {
    if (!serviceRequest.latitude || !serviceRequest.longitude) {
      return { locationScore: 50 }; // Score neutre si pas de coordonnées
    }

    // Calcul de la distance (simplifié - en réalité utiliser une librairie de géolocalisation)
    const distance = this.calculateDistance(
      serviceRequest.latitude,
      serviceRequest.longitude,
      // Coordonnées du prestataire (à extraire de prestataire.location ou ajouter des champs lat/lng)
      6.1378, // Lomé par défaut - à remplacer par les vraies coordonnées
      1.2123
    );

    // Score basé sur la distance (100 points à 0km, 0 points à 50km+)
    const locationScore = Math.max(0, 100 - (distance * 2));

    return { locationScore, distance: Math.round(distance * 100) / 100 };
  }

  /**
   * Calcule le score de compatibilité budget
   */
  private calculateBudgetScore(serviceRequest: ServiceRequest, prestataire: Prestataire): {
    budgetScore: number;
    estimatedPrice?: number;
  } {
    const clientBudget = serviceRequest.budget;
    const prestatairePrice = prestataire.pricePerHour;

    // Estimation du prix basée sur la durée estimée (2-8 heures)
    const estimatedDuration = 4; // heures par défaut
    const estimatedPrice = prestatairePrice * estimatedDuration;

    let budgetScore = 0;

    if (estimatedPrice <= clientBudget) {
      // Prix dans le budget
      const ratio = estimatedPrice / clientBudget;
      budgetScore = 100 - (ratio * 20); // 80-100 points
    } else {
      // Prix au-dessus du budget
      const ratio = clientBudget / estimatedPrice;
      budgetScore = ratio * 60; // 0-60 points
    }

    return { 
      budgetScore: Math.max(0, Math.min(100, budgetScore)),
      estimatedPrice: Math.round(estimatedPrice * 100) / 100,
    };
  }

  /**
   * Calcule le score de disponibilité
   */
  private calculateAvailabilityScore(prestataire: Prestataire): number {
    if (!prestataire.isAvailable) {
      return 0;
    }

    // Score basé sur le nombre de travaux récents
    const recentJobs = prestataire.completedJobs;
    if (recentJobs === 0) {
      return 100; // Nouveau prestataire, très disponible
    } else if (recentJobs < 5) {
      return 90; // Peu de travaux, très disponible
    } else if (recentJobs < 20) {
      return 70; // Modérément occupé
    } else {
      return 50; // Très occupé
    }
  }

  /**
   * Génère une explication du matching
   */
  private generateReasoning(scores: any): string {
    const factors: string[] = [];
    
    if (scores.skillsScore >= 80) factors.push('excellente correspondance des compétences');
    else if (scores.skillsScore >= 60) factors.push('bonne correspondance des compétences');
    
    if (scores.performanceScore >= 80) factors.push('excellent historique de performance');
    else if (scores.performanceScore >= 60) factors.push('bon historique de performance');
    
    if (scores.locationScore >= 80) factors.push('très proche géographiquement');
    else if (scores.locationScore >= 60) factors.push('proche géographiquement');
    
    if (scores.budgetScore >= 80) factors.push('tarifs très compétitifs');
    else if (scores.budgetScore >= 60) factors.push('tarifs compétitifs');
    
    if (scores.availabilityScore >= 80) factors.push('très disponible');
    else if (scores.availabilityScore >= 60) factors.push('disponible');

    return `Recommandé pour ${factors.join(', ')}. Score de compatibilité: ${scores.compatibilityScore}%`;
  }

  /**
   * Génère les facteurs de matching détaillés
   */
  private generateMatchingFactors(serviceRequest: ServiceRequest, prestataire: Prestataire, scores: any): any {
    return {
      skills: prestataire.skills || [],
      location: scores.distance ? `${scores.distance} km` : 'Non disponible',
      budget: scores.estimatedPrice ? `${scores.estimatedPrice} FCFA` : 'Non estimé',
      performance: `${prestataire.rating}/5 (${prestataire.totalReviews} avis)`,
      availability: prestataire.isAvailable ? 'Disponible' : 'Indisponible',
    };
  }

  /**
   * Extrait les mots-clés d'une description
   */
  private extractKeywords(text: string): string[] {
    const commonWords = ['le', 'la', 'les', 'de', 'du', 'des', 'un', 'une', 'et', 'ou', 'avec', 'pour', 'dans', 'sur', 'par'];
    return text
      .toLowerCase()
      .replace(/[^\w\s]/g, '')
      .split(/\s+/)
      .filter(word => word.length > 2 && !commonWords.includes(word));
  }

  /**
   * Calcule la distance entre deux points (formule de Haversine simplifiée)
   */
  private calculateDistance(lat1: number, lon1: number, lat2: number, lon2: number): number {
    const R = 6371; // Rayon de la Terre en km
    const dLat = this.toRadians(lat2 - lat1);
    const dLon = this.toRadians(lon2 - lon1);
    const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
              Math.cos(this.toRadians(lat1)) * Math.cos(this.toRadians(lat2)) *
              Math.sin(dLon/2) * Math.sin(dLon/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return R * c;
  }

  private toRadians(degrees: number): number {
    return degrees * (Math.PI/180);
  }

  /**
   * Enrichit un prestataire avec les VRAIES données de la base
   */
  private async enrichPrestataireWithRealData(prestataire: Prestataire): Promise<any> {
    console.log(`🔍 Enrichissement des données pour prestataire: ${prestataire.name} (${prestataire.id})`);
    
    // Récupérer les VRAIS avis pour ce prestataire
    const reviews = await this.reviewRepository.find({
      where: { prestataireId: prestataire.id },
    });
    
    console.log(`📊 Avis trouvés: ${reviews.length}`);
    
    // Calculer la VRAIE note moyenne et le VRAI nombre d'avis
    const totalReviews = reviews.length;
    const averageRating = totalReviews > 0 
      ? reviews.reduce((sum, review) => sum + review.rating, 0) / totalReviews 
      : 0;
    
    // Récupérer le VRAI nombre de travaux terminés
    const completedJobs = await this.serviceRequestRepository.count({
      where: { 
        assignedPrestataireId: prestataire.id,
        status: ServiceRequestStatus.COMPLETED,
      },
    });
    
    console.log(`🏗️ Travaux terminés: ${completedJobs}`);
    console.log(`⭐ Note moyenne: ${averageRating.toFixed(1)}/5`);
    console.log(`📝 Total avis: ${totalReviews}`);
    
    return {
      ...prestataire,
      rating: Math.round(averageRating * 10) / 10, // Arrondir à 1 décimale
      totalReviews: totalReviews,
      completedJobs: completedJobs,
      // Calculer les gains basés sur les VRAIES données
      totalEarnings: completedJobs * (prestataire.pricePerHour || 5000) * 6, // 6h par travail
    };
  }


  /**
   * Crée un objet AIMatch
   */
  private createAIMatch(serviceRequest: ServiceRequest, prestataire: Prestataire, scores: any): AIMatch {
    const match = new AIMatch();
    match.serviceRequestId = serviceRequest.id;
    match.prestataireId = prestataire.id;
    match.compatibilityScore = scores.compatibilityScore;
    match.skillsScore = scores.skillsScore;
    match.performanceScore = scores.performanceScore;
    match.locationScore = scores.locationScore;
    match.budgetScore = scores.budgetScore;
    match.availabilityScore = scores.availabilityScore;
    match.distance = scores.distance;
    match.estimatedPrice = scores.estimatedPrice;
    match.reasoning = scores.reasoning;
    match.matchingFactors = scores.matchingFactors;
    match.expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000); // Expire dans 7 jours
    return match;
  }

  /**
   * Récupère les matches existants pour une demande
   */
  async getMatchesForRequest(serviceRequestId: string): Promise<AIMatchResponseDto[]> {
    const matches = await this.aiMatchRepository.find({
      where: { serviceRequestId },
      order: { compatibilityScore: 'DESC' },
    });

    return Promise.all(
      matches.map(async (match) => {
        const prestataire = await this.prestataireRepository.findOne({
          where: { id: match.prestataireId },
        });

        // Enrichir le prestataire avec les VRAIES données
        const enrichedPrestataire = prestataire ? await this.enrichPrestataireWithRealData(prestataire) : null;
        
        return {
          ...match.toJSON(),
          prestataire: enrichedPrestataire ? {
            id: enrichedPrestataire.id,
            name: enrichedPrestataire.name,
            firstName: enrichedPrestataire.firstName,
            lastName: enrichedPrestataire.lastName,
            email: enrichedPrestataire.email,
            phone: enrichedPrestataire.phone,
            category: enrichedPrestataire.category,
            location: enrichedPrestataire.location,
            address: enrichedPrestataire.address,
            city: enrichedPrestataire.city,
            bio: enrichedPrestataire.bio,
            rating: enrichedPrestataire.rating,
            reviewCount: enrichedPrestataire.totalReviews,
            pricePerHour: enrichedPrestataire.pricePerHour,
            skills: enrichedPrestataire.skills || [],
            portfolio: enrichedPrestataire.portfolio || [],
            profileImage: enrichedPrestataire.profileImage,
            isAvailable: enrichedPrestataire.isAvailable,
            completedJobs: enrichedPrestataire.completedJobs,
            totalReviews: enrichedPrestataire.totalReviews,
            totalEarnings: enrichedPrestataire.totalEarnings,
          } : undefined,
        };
      })
    );
  }
}
