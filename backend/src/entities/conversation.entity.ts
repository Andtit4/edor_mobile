// backend/src/entities/conversation.entity.ts
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  OneToMany,
  JoinColumn,
} from 'typeorm';
import { User } from './user.entity';
import { Prestataire } from './prestataire.entity';
import { Message } from './message.entity';

@Entity('conversations')
export class Conversation {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  clientId: string;

  @Column()
  prestataireId: string;

  @Column({ nullable: true })
  serviceRequestId: string; // Optionnel, pour lier à une demande de service

  @Column({ default: false })
  isActive: boolean;

  @Column({ default: 0 })
  unreadCount: number;

  @Column({ nullable: true })
  lastMessageId: string;

  // Informations des utilisateurs (pour l'affichage)
  @Column({ nullable: true })
  clientName: string;

  @Column({ nullable: true })
  prestataireName: string;

  @Column({ nullable: true })
  clientAvatar: string;

  @Column({ nullable: true })
  prestataireAvatar: string;

  @Column({ nullable: true })
  lastMessageContent: string;

  @Column({ nullable: true })
  lastMessageTime: Date;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  // Relations
  @ManyToOne(() => User, { nullable: true })
  @JoinColumn({ name: 'clientId', foreignKeyConstraintName: 'FK_conversation_client' })
  client: User;

  @ManyToOne(() => Prestataire, { nullable: true })
  @JoinColumn({ name: 'prestataireId', foreignKeyConstraintName: 'FK_conversation_prestataire' })
  prestataire: Prestataire;

  @OneToMany(() => Message, (message) => message.conversation)
  messages: Message[];

  @ManyToOne(() => Message, { nullable: true })
  @JoinColumn({ name: 'lastMessageId' })
  lastMessage: Message;
}
