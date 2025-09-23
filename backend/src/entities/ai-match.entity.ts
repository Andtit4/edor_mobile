// backend/src/entities/ai-match.entity.ts
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { ServiceRequest } from './service-request.entity';
import { Prestataire } from './prestataire.entity';

export enum AIMatchStatus {
  PENDING = 'pending',
  ACCEPTED = 'accepted',
  REJECTED = 'rejected',
  EXPIRED = 'expired',
}

@Entity('ai_matches')
@Index(['serviceRequestId', 'prestataireId'], { unique: true })
export class AIMatch {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  serviceRequestId: string;

  @Column()
  prestataireId: string;

  // Score global de compatibilité (0-100)
  @Column({ type: 'decimal', precision: 5, scale: 2 })
  compatibilityScore: number;

  // Scores détaillés par critère
  @Column({ type: 'decimal', precision: 5, scale: 2 })
  skillsScore: number; // Score de compatibilité des compétences

  @Column({ type: 'decimal', precision: 5, scale: 2 })
  performanceScore: number; // Score basé sur rating, completedJobs, etc.

  @Column({ type: 'decimal', precision: 5, scale: 2 })
  locationScore: number; // Score de proximité géographique

  @Column({ type: 'decimal', precision: 5, scale: 2 })
  budgetScore: number; // Score de compatibilité budget/tarifs

  @Column({ type: 'decimal', precision: 5, scale: 2 })
  availabilityScore: number; // Score de disponibilité

  // Données contextuelles pour l'IA
  @Column({ type: 'decimal', precision: 10, scale: 8, nullable: true })
  distance: number; // Distance en km

  @Column({ type: 'decimal', precision: 10, scale: 2, nullable: true })
  estimatedPrice: number; // Prix estimé basé sur le budget

  @Column({ type: 'text', nullable: true })
  reasoning: string; // Explication du matching pour l'utilisateur

  @Column({ type: 'json', nullable: true })
  matchingFactors: {
    skills: string[];
    location: string;
    budget: string;
    performance: string;
    availability: string;
  };

  @Column({
    type: 'enum',
    enum: AIMatchStatus,
    default: AIMatchStatus.PENDING,
  })
  status: AIMatchStatus;

  @Column({ type: 'timestamp', nullable: true })
  expiresAt: Date;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  // Relations
  @ManyToOne(() => ServiceRequest, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'serviceRequestId' })
  serviceRequest: ServiceRequest;

  @ManyToOne(() => Prestataire, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'prestataireId' })
  prestataire: Prestataire;

  // Méthodes utilitaires
  isExpired(): boolean {
    return this.expiresAt && new Date() > this.expiresAt;
  }

  getScoreBreakdown() {
    return {
      total: this.compatibilityScore,
      skills: this.skillsScore,
      performance: this.performanceScore,
      location: this.locationScore,
      budget: this.budgetScore,
      availability: this.availabilityScore,
    };
  }

  toJSON() {
    return {
      id: this.id,
      serviceRequestId: this.serviceRequestId,
      prestataireId: this.prestataireId,
      compatibilityScore: parseFloat(this.compatibilityScore.toString()),
      skillsScore: parseFloat(this.skillsScore.toString()),
      performanceScore: parseFloat(this.performanceScore.toString()),
      locationScore: parseFloat(this.locationScore.toString()),
      budgetScore: parseFloat(this.budgetScore.toString()),
      availabilityScore: parseFloat(this.availabilityScore.toString()),
      distance: this.distance ? parseFloat(this.distance.toString()) : null,
      estimatedPrice: this.estimatedPrice ? parseFloat(this.estimatedPrice.toString()) : null,
      reasoning: this.reasoning,
      matchingFactors: this.matchingFactors,
      status: this.status,
      expiresAt: this.expiresAt,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    };
  }
}
