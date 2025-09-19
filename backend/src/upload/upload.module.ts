// backend/src/upload/upload.module.ts
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UploadService } from './upload.service';
import { UploadController } from './upload.controller';
import { AuthService } from '../auth/auth.service';
import { User } from '../entities/user.entity';
import { Prestataire } from '../entities/prestataire.entity';
import { JwtService } from '@nestjs/jwt';
import { EmailModule } from '../email/email.module';

@Module({
  imports: [
    ConfigModule,
    TypeOrmModule.forFeature([User, Prestataire]),
    EmailModule,
  ],
  controllers: [UploadController],
  providers: [UploadService, AuthService, JwtService],
  exports: [UploadService],
})
export class UploadModule {}
