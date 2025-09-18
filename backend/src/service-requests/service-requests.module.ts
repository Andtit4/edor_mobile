// backend/src/service-requests/service-requests.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ServiceRequestsService } from './service-requests.service';
import { ServiceRequestsController } from './service-requests.controller';
import { ServiceCompletionService } from './service-completion.service';
import { ServiceRequest } from '../entities/service-request.entity';
import { Review } from '../entities/review.entity';

@Module({
  imports: [TypeOrmModule.forFeature([ServiceRequest, Review])],
  controllers: [ServiceRequestsController],
  providers: [ServiceRequestsService, ServiceCompletionService],
  exports: [ServiceRequestsService, ServiceCompletionService],
})
export class ServiceRequestsModule {}