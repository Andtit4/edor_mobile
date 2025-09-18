// backend/src/service-requests/dto/create-service-request.dto.ts
import { IsString, IsNumber, IsDateString, IsOptional, IsEnum } from 'class-validator';
// import { ServiceRequestStatus } from '../entities/service-request.entity';

export class CreateServiceRequestDto {
  @IsString()
  title: string;

  @IsString()
  description: string;

  @IsString()
  category: string;

  @IsString()
  clientName: string;

  @IsString()
  clientPhone: string;

  @IsString()
  location: string;

  @IsOptional()
  @IsNumber()
  latitude?: number;

  @IsOptional()
  @IsNumber()
  longitude?: number;

  @IsNumber()
  budget: number;

  @IsDateString()
  deadline: string;

  @IsOptional()
  @IsString()
  notes?: string;
}