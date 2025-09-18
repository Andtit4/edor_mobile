import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Request,
} from '@nestjs/common';
import { ReviewsService } from './reviews.service';
import { CreateReviewDto } from './dto/create-review.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('reviews')
export class ReviewsController {
  constructor(private readonly reviewsService: ReviewsService) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  create(@Body() createReviewDto: CreateReviewDto, @Request() req) {
    return this.reviewsService.create(createReviewDto, req.user.id);
  }

  @Get('prestataire/:prestataireId')
  findByPrestataire(@Param('prestataireId') prestataireId: string) {
    return this.reviewsService.findByPrestataire(prestataireId);
  }

  @Get('prestataire/:prestataireId/average')
  getPrestataireAverageRating(@Param('prestataireId') prestataireId: string) {
    return this.reviewsService.getPrestataireAverageRating(prestataireId);
  }

  @Get('prestataire/:prestataireId/count')
  getPrestataireReviewsCount(@Param('prestataireId') prestataireId: string) {
    return this.reviewsService.getPrestataireReviewsCount(prestataireId);
  }
}
