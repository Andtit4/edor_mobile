import { IsString, IsEmail, IsOptional, IsEnum } from 'class-validator';
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
