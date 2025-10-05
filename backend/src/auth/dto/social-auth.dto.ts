import { IsString, IsEmail, IsOptional, IsEnum, IsArray, IsNumber } from 'class-validator';
import { UserRole } from '../../entities/user.entity';

export class SocialAuthDto {
  @IsString()
  provider: 'google' | 'facebook' | 'apple';

  @IsString()
  providerId: string;

  @IsEmail()
  email: string;

  @IsString()
  firstName: string;

  @IsString()
  lastName: string;

  @IsOptional()
  @IsString()
  phone?: string;

  @IsOptional()
  @IsString()
  profileImage?: string;

  @IsEnum(UserRole)
  role: UserRole;

  @IsOptional()
  @IsString()
  accessToken?: string;

  @IsOptional()
  @IsString()
  idToken?: string;

  @IsOptional()
  @IsString()
  firebaseUid?: string;

  @IsOptional()
  emailVerified?: boolean;

  // Champs optionnels pour tous les utilisateurs
  @IsOptional()
  @IsString()
  address?: string;

  @IsOptional()
  @IsString()
  city?: string;

  @IsOptional()
  @IsString()
  postalCode?: string;

  @IsOptional()
  @IsString()
  bio?: string;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  skills?: string[];

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  categories?: string[];

  // Champs spécifiques aux prestataires
  @IsOptional()
  @IsString()
  category?: string;

  @IsOptional()
  @IsString()
  location?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsNumber()
  pricePerHour?: number;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  portfolio?: string[];

  // Champs de notification
  @IsOptional()
  @IsString()
  fcmToken?: string;
}

export class SocialAuthResponseDto {
  user: {
    id: string;
    email: string;
    firstName: string;
    lastName: string;
    phone?: string;
    role: string;
    profileImage?: string;
    isSocialAuth: boolean;
  };
  token: string;
}
