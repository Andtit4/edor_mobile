// backend/src/messages/messages.service.ts
import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Conversation } from '../entities/conversation.entity';
import { Message, MessageType } from '../entities/message.entity';
import { User } from '../entities/user.entity';
import { Prestataire } from '../entities/prestataire.entity';
import { CreateMessageDto } from './dto/create-message.dto';
import { CreateConversationDto } from './dto/create-conversation.dto';

@Injectable()
export class MessagesService {
  constructor(
    @InjectRepository(Conversation)
    private conversationRepository: Repository<Conversation>,
    @InjectRepository(Message)
    private messageRepository: Repository<Message>,
    @InjectRepository(User)
    private userRepository: Repository<User>,
    @InjectRepository(Prestataire)
    private prestataireRepository: Repository<Prestataire>,
  ) {}

  async createConversation(
    createConversationDto: CreateConversationDto,
    clientId: string,
  ): Promise<Conversation> {
    const { prestataireId, serviceRequestId } = createConversationDto;

    // Vérifier si une conversation existe déjà
    const existingConversation = await this.conversationRepository.findOne({
      where: {
        clientId,
        prestataireId,
        isActive: true,
      },
    });

    if (existingConversation) {
      return existingConversation;
    }

    // Vérifier que le prestataire existe
    const prestataire = await this.prestataireRepository.findOne({
      where: { id: prestataireId },
    });

    if (!prestataire) {
      throw new NotFoundException('Prestataire non trouvé');
    }

    // Créer la nouvelle conversation
    const conversation = this.conversationRepository.create({
      clientId,
      prestataireId,
      serviceRequestId,
      isActive: true,
      prestataireName: prestataire.firstName + ' ' + prestataire.lastName,
      prestataireAvatar: prestataire.profileImage,
    });

    return this.conversationRepository.save(conversation);
  }

  async getConversations(userId: string, userType: 'client' | 'prestataire'): Promise<Conversation[]> {
    const whereCondition = userType === 'client' 
      ? { clientId: userId, isActive: true }
      : { prestataireId: userId, isActive: true };

    return this.conversationRepository.find({
      where: whereCondition,
      relations: ['client', 'prestataire', 'lastMessage'],
      order: { updatedAt: 'DESC' },
    });
  }

  async getConversationById(
    conversationId: string,
    userId: string,
    userType: 'client' | 'prestataire',
  ): Promise<Conversation> {
    const conversation = await this.conversationRepository.findOne({
      where: { id: conversationId },
      relations: ['client', 'prestataire'],
    });

    if (!conversation) {
      throw new NotFoundException('Conversation non trouvée');
    }

    // Vérifier que l'utilisateur a accès à cette conversation
    const hasAccess = userType === 'client' 
      ? conversation.clientId === userId
      : conversation.prestataireId === userId;

    if (!hasAccess) {
      throw new ForbiddenException('Accès non autorisé à cette conversation');
    }

    return conversation;
  }

  async getMessages(
    conversationId: string,
    userId: string,
    userType: 'client' | 'prestataire',
  ): Promise<Message[]> {
    // Vérifier l'accès à la conversation
    await this.getConversationById(conversationId, userId, userType);

    const messages = await this.messageRepository.find({
      where: { conversationId },
      relations: ['senderUser', 'senderPrestataire'],
      order: { createdAt: 'ASC' },
    });

    // Marquer les messages comme lus si l'utilisateur n'est pas l'expéditeur
    const unreadMessages = messages.filter(
      (message) => 
        !message.isRead && 
        (message.senderUserId !== userId && message.senderPrestataireId !== userId)
    );

    if (unreadMessages.length > 0) {
      // Marquer chaque message individuellement comme lu
      for (const message of unreadMessages) {
        await this.messageRepository.update(
          { id: message.id },
          { isRead: true }
        );
      }

      // Mettre à jour le compteur de messages non lus
      await this.conversationRepository.update(
        { id: conversationId },
        { unreadCount: 0 }
      );
    }

    return messages;
  }

  async sendMessage(
    conversationId: string,
    createMessageDto: CreateMessageDto,
    senderId: string,
    senderType: 'client' | 'prestataire',
  ): Promise<Message> {
    // Vérifier que la conversation existe et que l'utilisateur y a accès
    const conversation = await this.getConversationById(
      conversationId,
      senderId,
      senderType,
    );

    // Créer le message
    const message = new Message();
    message.conversationId = conversationId;
    message.senderUserId = senderType === 'client' ? senderId : null;
    message.senderPrestataireId = senderType === 'prestataire' ? senderId : null;
    message.senderType = senderType;
    message.content = createMessageDto.content;
    message.type = createMessageDto.type || MessageType.TEXT;
    message.imageUrl = createMessageDto.imageUrl || null;

    const savedMessage = await this.messageRepository.save(message);

    // Mettre à jour la conversation avec le dernier message
    await this.conversationRepository.update(conversationId, {
      lastMessageId: savedMessage.id,
      lastMessageContent: savedMessage.content,
      lastMessageTime: savedMessage.createdAt,
      updatedAt: new Date(),
    });

    // Incrémenter le compteur de messages non lus pour l'autre utilisateur
    const otherUserId = senderType === 'client' 
      ? conversation.prestataireId 
      : conversation.clientId;

    await this.conversationRepository.update(conversationId, {
      unreadCount: () => 'unread_count + 1',
    });

    return savedMessage;
  }

  async markMessagesAsRead(
    conversationId: string,
    userId: string,
    userType: 'client' | 'prestataire',
  ): Promise<void> {
    await this.getConversationById(conversationId, userId, userType);

    // Récupérer la conversation pour obtenir l'ID de l'autre utilisateur
    const conversation = await this.conversationRepository.findOne({
      where: { id: conversationId }
    });

    if (conversation) {
      const otherUserId = userType === 'client' 
        ? conversation.prestataireId 
        : conversation.clientId;

      // Marquer tous les messages de l'autre utilisateur comme lus
      const whereCondition = userType === 'client' 
        ? { conversationId, senderPrestataireId: otherUserId, isRead: false }
        : { conversationId, senderUserId: otherUserId, isRead: false };
        
      await this.messageRepository.update(
        whereCondition,
        { isRead: true }
      );

      // Mettre à jour le compteur de messages non lus
      await this.conversationRepository.update(conversationId, {
        unreadCount: 0,
      });
    }
  }

  async getUnreadCount(userId: string, userType: 'client' | 'prestataire'): Promise<number> {
    const whereCondition = userType === 'client' 
      ? { clientId: userId, isActive: true }
      : { prestataireId: userId, isActive: true };

    const result = await this.conversationRepository
      .createQueryBuilder('conversation')
      .select('SUM(conversation.unreadCount)', 'total')
      .where(whereCondition)
      .getRawOne();

    return parseInt(result.total) || 0;
  }
}
