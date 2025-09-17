// backend/src/entities/price-negotiation.entity.ts
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { ServiceRequest } from './service-request.entity';
import { User } from './user.entity';
import { Prestataire } from './prestataire.entity';

export enum NegotiationStatus {
  PENDING = 'pending',
  ACCEPTED = 'accepted',
  REJECTED = 'rejected',
  COUNTERED = 'countered',
}

@Entity('price_negotiations')
export class PriceNegotiation {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'service_request_id' })
  serviceRequestId: string;

  @Column({ name: 'prestataire_id' })
  prestataireId: string;

  @Column({ name: 'client_id' })
  clientId: string;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  proposedPrice: number;

  @Column({ type: 'text', nullable: true })
  message: string;

  @Column({
    type: 'enum',
    enum: NegotiationStatus,
    default: NegotiationStatus.PENDING,
  })
  status: NegotiationStatus;

  @Column({ name: 'is_from_prestataire', default: true })
  isFromPrestataire: boolean;

  @Column({ name: 'parent_negotiation_id', nullable: true })
  parentNegotiationId: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  // Relations
  @ManyToOne(() => ServiceRequest, { nullable: false })
  @JoinColumn({ name: 'service_request_id' })
  serviceRequest: ServiceRequest;

  @ManyToOne(() => Prestataire, { nullable: false })
  @JoinColumn({ name: 'prestataire_id' })
  prestataire: Prestataire;

  @ManyToOne(() => User, { nullable: false })
  @JoinColumn({ name: 'client_id' })
  client: User;

  @ManyToOne(() => PriceNegotiation, { nullable: true })
  @JoinColumn({ name: 'parent_negotiation_id' })
  parentNegotiation: PriceNegotiation;
}
