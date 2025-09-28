// backend/src/prestataires/dto/create-prestataire.dto.ts
import { IsString, IsEmail, IsOptional, IsNumber, IsArray, IsBoolean } from 'class-validator';

export class CreatePrestataireDto {
  @IsString()
  name: string;

  @IsEmail()
  email: string;

  @IsOptional()
  @IsString()
  avatar?: string;

  @IsOptional()
  @IsString()
  phone?: string;

  @IsString()
  category: string;

  @IsString()
  location: string;

  @IsString()
  description: string;

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