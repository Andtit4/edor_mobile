// backend/src/ai-matching/ai-matching.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AIMatchingController } from './ai-matching.controller';
import { AIMatchingService } from './ai-matching.service';
import { AIMatch } from '../entities/ai-match.entity';
import { ServiceRequest } from '../entities/service-request.entity';
import { Prestataire } from '../entities/prestataire.entity';
import { Review } from '../entities/review.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      AIMatch,
      ServiceRequest,
      Prestataire,
      Review,
    ]),
  ],
  controllers: [AIMatchingController],
  providers: [AIMatchingService],
  exports: [AIMatchingService],
})
export class AIMatchingModule {}
