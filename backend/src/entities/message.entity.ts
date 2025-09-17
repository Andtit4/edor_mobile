// backend/src/entities/message.entity.ts
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Conversation } from './conversation.entity';
import { User } from './user.entity';
import { Prestataire } from './prestataire.entity';

export enum MessageType {
  TEXT = 'text',
  IMAGE = 'image',
  SYSTEM = 'system',
}

@Entity('messages')
export class Message {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'conversation_id' })
  conversationId: string;

  @Column({ name: 'sender_user_id', type: 'varchar', nullable: true })
  senderUserId: string | null;

  @Column({ name: 'sender_prestataire_id', type: 'varchar', nullable: true })
  senderPrestataireId: string | null;

  @Column({ name: 'sender_type' })
  senderType: 'client' | 'prestataire';

  @Column({ type: 'text' })
  content: string;

  @Column({
    type: 'enum',
    enum: MessageType,
    default: MessageType.TEXT,
  })
  type: MessageType;

  @Column({ name: 'is_read', default: false })
  isRead: boolean;

  @Column({ name: 'image_url', type: 'varchar', nullable: true })
  imageUrl: string | null;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  // Relations
  @ManyToOne(() => Conversation, (conversation) => conversation.messages, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'conversation_id' })
  conversation: Conversation;

  @ManyToOne(() => User, { nullable: true })
  @JoinColumn({ name: 'sender_user_id' })
  senderUser: User;

  @ManyToOne(() => Prestataire, { nullable: true })
  @JoinColumn({ name: 'sender_prestataire_id' })
  senderPrestataire: Prestataire;
}
