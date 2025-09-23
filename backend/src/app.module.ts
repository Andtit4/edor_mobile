// backend/src/app.module.ts
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { databaseConfig } from './config/database.config';
import { AuthModule } from './auth/auth.module';
import { PrestatairesModule } from './prestataires/prestataire.module';
import { ServiceOffersModule } from './service-offers/service-offers.module';
import { ServiceRequestsModule } from './service-requests/service-requests.module';
import { MessagesModule } from './messages/messages.module';
import { PriceNegotiationsModule } from './price-negotiations/price-negotiations.module';
import { ReviewsModule } from './reviews/reviews.module';
import { EmailModule } from './email/email.module';
import { UploadModule } from './upload/upload.module';
import { AIMatchingModule } from './ai-matching/ai-matching.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    TypeOrmModule.forRoot(databaseConfig),
    AuthModule,
    PrestatairesModule,
    ServiceOffersModule,
    ServiceRequestsModule,
    MessagesModule,
    PriceNegotiationsModule,
    ReviewsModule,
    EmailModule,
    UploadModule,
    AIMatchingModule,
  ],
})
export class AppModule {}