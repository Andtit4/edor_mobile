import { Review } from '../../entities/review.entity';

export class ReviewResponseDto {
  id: string;
  serviceRequestId: string;
  prestataireId: string;
  clientId: string;
  rating: number;
  comment?: string;
  createdAt: Date;
  updatedAt: Date;
  // Informations enrichies
  clientName: string;
  serviceRequestTitle: string;

  constructor(partial: Partial<ReviewResponseDto>) {
    Object.assign(this, partial);
  }
}
