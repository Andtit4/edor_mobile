// backend/src/app.module.ts
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { databaseConfig } from './config/database.config';
import { AuthModule } from './auth/auth.module';
import { PrestatairesModule } from './prestataires/prestataire.module';
import { ServiceRequestsModule } from './service-requests/service-requests.module';
import { ServiceOffersModule } from './service-offers/service-offers.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forRoot(databaseConfig),
    AuthModule,
    PrestatairesModule,
    ServiceRequestsModule,
    ServiceOffersModule,
  ],
})
export class AppModule {}