// backend/src/price-negotiations/dto/create-price-negotiation.dto.ts
import { IsNumber, IsString, IsOptional, IsBoolean, IsUUID } from 'class-validator';

export class CreatePriceNegotiationDto {
  @IsUUID()
  serviceRequestId: string;

  @IsNumber()
  proposedPrice: number;

  @IsString()
  @IsOptional()
  message?: string;

  @IsBoolean()
  @IsOptional()
  isFromPrestataire?: boolean;

  @IsUUID()
  @IsOptional()
  parentNegotiationId?: string;
}
