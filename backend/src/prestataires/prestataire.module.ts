// backend/src/prestataires/prestataires.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PrestatairesService } from './prestataire.service';
// import { PrestatairesController } from './prestataires.controller';
import { Prestataire } from '../entities/prestataire.entity';
import { PrestatairesController } from './prestataire.controller';

@Module({
  imports: [TypeOrmModule.forFeature([Prestataire])],
  controllers: [PrestatairesController],
  providers: [PrestatairesService],
  exports: [PrestatairesService],
})
export class PrestatairesModule {}
