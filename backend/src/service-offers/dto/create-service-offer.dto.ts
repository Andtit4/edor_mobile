// backend/src/service-offers/dto/create-service-offer.dto.ts
import { IsString, IsNumber, IsOptional, IsArray, IsEnum } from 'class-validator';
import { ServiceOfferStatus } from 'src/entities/service-offer.entity';
// import { ServiceOfferStatus } from '../entities/service-offer.entity';

export class CreateServiceOfferDto {
  @IsString()
  title: string;

  @IsString()
  description: string;

  @IsString()
  category: string;

  @IsString()
  prestataireName: string;

  @IsString()
  prestatairePhone: string;

  @IsString()
  location: string;

  @IsNumber()
  price: number;

  @IsOptional()
  @IsEnum(ServiceOfferStatus)
  status?: ServiceOfferStatus;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  images?: string[];

  @IsOptional()
  @IsString()
  experience?: string;

  @IsOptional()
  @IsString()
  availability?: string;
}