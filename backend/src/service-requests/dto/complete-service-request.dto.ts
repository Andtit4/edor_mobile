import { IsDateString, IsString, IsInt, IsOptional, Min, Max } from 'class-validator';

export class CompleteServiceRequestDto {
  @IsDateString()
  completionDate: string;

  @IsString()
  @IsOptional()
  completionNotes?: string;

  @IsInt()
  @Min(1)
  @Max(5)
  rating: number;

  @IsString()
  @IsOptional()
  reviewComment?: string;
}
