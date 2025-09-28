import { IsString, IsInt, IsOptional, Min, Max, IsUUID } from 'class-validator';

export class CreateReviewDto {
  @IsUUID()
  serviceRequestId: string;

  @IsUUID()
  prestataireId: string;

  @IsInt()
  @Min(1)
  @Max(5)
  rating: number;

  @IsString()
  @IsOptional()
  comment?: string;
}
