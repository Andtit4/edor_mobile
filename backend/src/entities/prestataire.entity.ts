// backend/src/entities/prestataire.entity.ts
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
  JoinColumn,
} from 'typeorm';
import { ServiceOffer } from './service-offer.entity';

@Entity('prestataires')
export class Prestataire {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column({ unique: true })
  email: string;

  @Column({ nullable: true })
  avatar: string;

  @Column({ nullable: true })
  phone: string;

  @Column()
  category: string;

  @Column()
  location: string;

  @Column({ type: 'text' })
  description: string;

  @Column({ type: 'decimal', precision: 3, scale: 2, default: 0 })
  rating: number;

  @Column({ default: 0 })
  pricePerHour: number;

  @Column({ type: 'json', nullable: true }) // Supprimer default: '[]'
  skills: string[];

  @Column({ type: 'json', nullable: true }) // Supprimer default: '[]'
  portfolio: string[];

  @Column({ default: true })
  isAvailable: boolean;

  @Column({ default: 0 })
  completedJobs: number;

  @Column({ default: 0 })
  totalReviews: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @OneToMany(() => ServiceOffer, (offer) => offer.prestataire)
  serviceOffers: ServiceOffer[];
}
