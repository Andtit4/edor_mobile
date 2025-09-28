// backend/src/prestataires/dto/update-prestataire-profile.dto.ts
import { IsString, IsOptional, IsNumber, IsArray, IsBoolean } from 'class-validator';

export class UpdatePrestataireProfileDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsString()
  category?: string;

  @IsOptional()
  @IsString()
  location?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsNumber()
  pricePerHour?: number;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  skills?: string[];

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  portfolio?: string[];

  @IsOptional()
  @IsBoolean()
  isAvailable?: boolean;
}