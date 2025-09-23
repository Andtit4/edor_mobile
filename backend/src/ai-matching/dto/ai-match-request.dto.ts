// backend/src/ai-matching/dto/ai-match-request.dto.ts
import {
  IsString,
  IsOptional,
  IsNumber,
  IsArray,
  IsEnum,
  Min,
  Max,
} from 'class-validator';

export class AIMatchRequestDto {
  @IsString()
  serviceRequestId: string;

  @IsOptional()
  @IsNumber()
  @Min(1)
  @Max(50)
  maxResults?: number = 10;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(100)
  minScore?: number = 60;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(1000)
  maxDistance?: number = 50; // km

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  preferredSkills?: string[];

  @IsOptional()
  @IsEnum(['distance', 'rating', 'price', 'availability', 'compatibility'])
  sortBy?: string = 'compatibility';
}

export class AIMatchResponseDto {
  id: string;
  serviceRequestId: string;
  prestataireId: string;
  compatibilityScore: number;
  skillsScore: number;
  performanceScore: number;
  locationScore: number;
  budgetScore: number;
  availabilityScore: number;
  distance?: number | null;
  estimatedPrice?: number | null;
  reasoning: string;
  matchingFactors: {
    skills: string[];
    location: string;
    budget: string;
    performance: string;
    availability: string;
  };
  status: string;
  expiresAt?: Date | null;
  createdAt: Date;
  updatedAt: Date;
  prestataire?: {
    id: string;
    name: string;
    category: string;
    location: string;
    rating: number;
    pricePerHour: number;
    skills: string[];
    isAvailable: boolean;
    completedJobs: number;
    totalReviews: number;
  };
}
