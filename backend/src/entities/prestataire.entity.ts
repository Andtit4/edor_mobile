// backend/src/entities/prestataire.entity.ts
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
  OneToOne,
  JoinColumn,
  BeforeInsert,
} from 'typeorm';
import { ServiceOffer } from './service-offer.entity';
import { User } from './user.entity';
import * as bcrypt from 'bcryptjs';

@Entity('prestataires')
export class Prestataire {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  // Champs communs avec User
  @Column({ unique: true })
  email: string;

  @Column()
  firstName: string;

  @Column()
  lastName: string;

  @Column()
  phone: string;

  @Column()
  password: string;

  @Column({
    type: 'enum',
    enum: ['client', 'prestataire'],
    default: 'prestataire',
  })
  role: string;

  @Column({ nullable: true })
  profileImage: string;

  @Column({ nullable: true })
  address: string;

  @Column({ nullable: true })
  city: string;

  @Column({ nullable: true })
  postalCode: string;

  @Column({ nullable: true, type: 'text' })
  bio: string;

  @Column({ type: 'float', default: 0 })
  rating: number;

  @Column({ type: 'int', default: 0 })
  reviewCount: number;

  @Column({ type: 'json', nullable: true })
  skills: string[];

  @Column({ type: 'json', nullable: true })
  categories: string[];

  // Champs spécifiques aux prestataires
  @Column()
  name: string;

  @Column()
  category: string;

  @Column()
  location: string;

  @Column({ type: 'text' })
  description: string;

  @Column({ type: 'float', default: 0 })
  pricePerHour: number;

  @Column({ type: 'json', nullable: true })
  portfolio: string[];

  @Column({ default: true })
  isAvailable: boolean;

  @Column({ type: 'int', default: 0 })
  completedJobs: number;

  @Column({ type: 'int', default: 0 })
  totalReviews: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @OneToMany(() => ServiceOffer, (offer) => offer.prestataire)
  serviceOffers: ServiceOffer[];

  @BeforeInsert()
  async hashPassword() {
    this.password = await bcrypt.hash(this.password, 12);
  }

  async validatePassword(password: string): Promise<boolean> {
    return bcrypt.compare(password, this.password);
  }

  toJSON() {
    return {
      id: this.id,
      email: this.email,
      firstName: this.firstName,
      lastName: this.lastName,
      phone: this.phone,
      role: this.role,
      profileImage: this.profileImage,
      address: this.address,
      city: this.city,
      postalCode: this.postalCode,
      bio: this.bio,
      rating: parseFloat(this.rating.toString()),
      reviewCount: parseInt(this.reviewCount.toString()),
      skills: this.skills,
      categories: this.categories,
      name: this.name,
      category: this.category,
      location: this.location,
      description: this.description,
      pricePerHour: parseFloat(this.pricePerHour.toString()),
      portfolio: this.portfolio,
      isAvailable: this.isAvailable,
      completedJobs: parseInt(this.completedJobs.toString()),
      totalReviews: parseInt(this.totalReviews.toString()),
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    };
  }
}
