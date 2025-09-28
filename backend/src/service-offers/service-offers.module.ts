// backend/src/service-offers/service-offers.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ServiceOffersService } from './service-offers.service';
import { ServiceOffersController } from './service-offers.controller';
import { ServiceOffer } from '../entities/service-offer.entity';

@Module({
  imports: [TypeOrmModule.forFeature([ServiceOffer])],
  controllers: [ServiceOffersController],
  providers: [ServiceOffersService],
  exports: [ServiceOffersService],
})
export class ServiceOffersModule {}