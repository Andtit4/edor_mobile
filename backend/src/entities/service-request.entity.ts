// backend/src/entities/service-request.entity.ts
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
  
  export enum ServiceRequestStatus {
	PENDING = 'pending',
	ASSIGNED = 'assigned',
	IN_PROGRESS = 'in_progress',
	COMPLETED = 'completed',
	CANCELLED = 'cancelled',
  }
  
  @Entity('service_requests')
  export class ServiceRequest {
	@PrimaryGeneratedColumn('uuid')
	id: string;
  
	@Column()
	title: string;
  
	@Column({ type: 'text' })
	description: string;
  
	@Column()
	category: string;
  
	@Column()
	clientId: string;
  
	@Column()
	clientName: string;
  
	@Column()
	clientPhone: string;
  
	@Column()
	location: string;
  
	@Column({ type: 'decimal', precision: 10, scale: 2 })
	budget: number;
  
	@Column()
	deadline: Date;
  
	@Column({
	  type: 'enum',
	  enum: ServiceRequestStatus,
	  default: ServiceRequestStatus.PENDING,
	})
	status: ServiceRequestStatus;
  
	@Column({ nullable: true })
	assignedPrestataireId: string;
  
	@Column({ nullable: true })
	prestataireName: string;
  
	@Column({ type: 'text', nullable: true })
	notes: string;

	@Column({ type: 'date', nullable: true })
	completionDate: Date;

	@Column({ type: 'text', nullable: true })
	completionNotes: string;
  
	@CreateDateColumn()
	createdAt: Date;
  
	@UpdateDateColumn()
	updatedAt: Date;
  
	@ManyToOne(() => Prestataire, { nullable: true })
	@JoinColumn({ name: 'assignedPrestataireId' })
	assignedPrestataire: Prestataire;
  }