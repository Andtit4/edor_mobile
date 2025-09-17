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

  @Column({ name: 'client_id' })
  clientId: string;

  @Column({ name: 'prestataire_id' })
  prestataireId: string;

  @Column({ name: 'service_request_id', nullable: true })
  serviceRequestId: string; // Optionnel, pour lier à une demande de service

  @Column({ name: 'is_active', default: false })
  isActive: boolean;

  @Column({ name: 'unread_count', default: 0 })
  unreadCount: number;

  @Column({ name: 'last_message_id', nullable: true })
  lastMessageId: string;

  // Informations des utilisateurs (pour l'affichage)
  @Column({ name: 'client_name', nullable: true })
  clientName: string;

  @Column({ name: 'prestataire_name', nullable: true })
  prestataireName: string;

  @Column({ name: 'client_avatar', nullable: true })
  clientAvatar: string;

  @Column({ name: 'prestataire_avatar', nullable: true })
  prestataireAvatar: string;

  @Column({ name: 'last_message_content', nullable: true })
  lastMessageContent: string;

  @Column({ name: 'last_message_time', nullable: true })
  lastMessageTime: Date;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  // Relations
  @ManyToOne(() => User, { nullable: true })
  @JoinColumn({ name: 'client_id', foreignKeyConstraintName: 'FK_conversation_client' })
  client: User;

  @ManyToOne(() => Prestataire, { nullable: true })
  @JoinColumn({ name: 'prestataire_id', foreignKeyConstraintName: 'FK_conversation_prestataire' })
  prestataire: Prestataire;

  @OneToMany(() => Message, (message) => message.conversation)
  messages: Message[];

  @ManyToOne(() => Message, { nullable: true })
  @JoinColumn({ name: 'last_message_id' })
  lastMessage: Message;
}
