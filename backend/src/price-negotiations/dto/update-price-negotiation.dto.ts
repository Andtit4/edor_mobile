// backend/src/price-negotiations/dto/update-price-negotiation.dto.ts
import { IsEnum, IsOptional } from 'class-validator';
import { NegotiationStatus } from '../../entities/price-negotiation.entity';

export class UpdatePriceNegotiationDto {
  @IsEnum(NegotiationStatus)
  @IsOptional()
  status?: NegotiationStatus;
}
