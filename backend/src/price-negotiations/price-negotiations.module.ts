// backend/src/price-negotiations/price-negotiations.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PriceNegotiationsService } from './price-negotiations.service';
import { PriceNegotiationsController } from './price-negotiations.controller';
import { PriceNegotiation } from '../entities/price-negotiation.entity';
import { ServiceRequest } from '../entities/service-request.entity';

@Module({
  imports: [TypeOrmModule.forFeature([PriceNegotiation, ServiceRequest])],
  controllers: [PriceNegotiationsController],
  providers: [PriceNegotiationsService],
  exports: [PriceNegotiationsService],
})
export class PriceNegotiationsModule {}
