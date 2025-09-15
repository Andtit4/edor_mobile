// backend/src/entities/service-offer.entity.ts
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from './user.entity';

export enum ServiceOfferStatus {
  AVAILABLE = 'available',
  UNAVAILABLE = 'unavailable',
  PAUSED = 'paused',
}

@Entity('service_offers')
export class ServiceOffer {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  title: string;

  @Column({ type: 'text' })
  description: string;

  @Column()
  category: string;

  @Column()
  prestataireId: string;

  @Column()
  prestataireName: string;

  @Column()
  prestatairePhone: string;

  @Column()
  location: string;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  price: number;

  @Column({
    type: 'enum',
    enum: ServiceOfferStatus,
    default: ServiceOfferStatus.AVAILABLE,
  })
  status: ServiceOfferStatus;

  @Column({ type: 'decimal', precision: 3, scale: 2, default: 0 })
  rating: number;

  @Column({ default: 0 })
  reviewCount: number;

  @Column({ type: 'json', nullable: true }) // Supprimer default: '[]'
  images: string[];

  @Column({ type: 'text', nullable: true })
  experience: string;

  @Column({ type: 'text', nullable: true })
  availability: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @ManyToOne(() => User, { nullable: true })
  @JoinColumn({ name: 'prestataireId' })
  prestataire: User;
}
