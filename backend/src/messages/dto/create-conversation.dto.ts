// backend/src/messages/dto/create-conversation.dto.ts
import { IsString, IsNotEmpty, IsOptional } from 'class-validator';

export class CreateConversationDto {
  @IsString()
  @IsNotEmpty()
  prestataireId: string;

  @IsString()
  @IsOptional()
  serviceRequestId?: string;
}

