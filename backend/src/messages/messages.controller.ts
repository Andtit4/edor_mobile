// backend/src/messages/messages.controller.ts
import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Request,
  Query,
} from '@nestjs/common';
import { MessagesService } from './messages.service';
import { CreateMessageDto } from './dto/create-message.dto';
import { CreateConversationDto } from './dto/create-conversation.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('messages')
@UseGuards(JwtAuthGuard)
export class MessagesController {
  constructor(private readonly messagesService: MessagesService) {}

  @Post('conversations')
  async createConversation(
    @Body() createConversationDto: CreateConversationDto,
    @Request() req,
  ) {
    const userType = req.user.role === 'prestataire' ? 'prestataire' : 'client';
    return this.messagesService.createConversation(
      createConversationDto,
      req.user.id,
    );
  }

  @Get('conversations')
  async getConversations(@Request() req) {
    const userType = req.user.role === 'prestataire' ? 'prestataire' : 'client';
    return this.messagesService.getConversations(req.user.id, userType);
  }

  @Get('conversations/:id')
  async getConversation(
    @Param('id') id: string,
    @Request() req,
  ) {
    const userType = req.user.role === 'prestataire' ? 'prestataire' : 'client';
    return this.messagesService.getConversationById(id, req.user.id, userType);
  }

  @Get('conversations/:id/messages')
  async getMessages(
    @Param('id') id: string,
    @Request() req,
  ) {
    const userType = req.user.role === 'prestataire' ? 'prestataire' : 'client';
    return this.messagesService.getMessages(id, req.user.id, userType);
  }

  @Post('conversations/:id/messages')
  async sendMessage(
    @Param('id') id: string,
    @Body() createMessageDto: CreateMessageDto,
    @Request() req,
  ) {
    const userType = req.user.role === 'prestataire' ? 'prestataire' : 'client';
    return this.messagesService.sendMessage(
      id,
      createMessageDto,
      req.user.id,
      userType,
    );
  }

  @Post('conversations/:id/read')
  async markAsRead(
    @Param('id') id: string,
    @Request() req,
  ) {
    const userType = req.user.role === 'prestataire' ? 'prestataire' : 'client';
    await this.messagesService.markMessagesAsRead(id, req.user.id, userType);
    return { success: true };
  }

  @Get('unread-count')
  async getUnreadCount(@Request() req) {
    const userType = req.user.role === 'prestataire' ? 'prestataire' : 'client';
    const count = await this.messagesService.getUnreadCount(req.user.id, userType);
    return { unreadCount: count };
  }
}

