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
import { Prestataire } from './prestataire.entity';
import { ServiceRequest } from './service-request.entity';

@Entity('reviews')
export class Review {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'service_request_id' })
  serviceRequestId: string;

  @Column({ name: 'prestataire_id' })
  prestataireId: string;

  @Column({ name: 'client_id' })
  clientId: string;

  @Column({ type: 'int', comment: 'Note de 1 à 5 étoiles' })
  rating: number;

  @Column({ type: 'text', nullable: true })
  comment: string;

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
}
