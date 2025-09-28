// src/auth/auth.controller.ts
import { Controller, Post, Body, Get, UseGuards, Request } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import { SocialAuthDto } from './dto/social-auth.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  // Dans votre AuthController
@Post('register')
async register(@Body() registerDto: RegisterDto) {
  const result = await this.authService.register(registerDto);
  return {
    user: result.user,
    token: result.token
  };
}

  @Post('login')
  async login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }

  @UseGuards(JwtAuthGuard)
  @Get('profile')
  async getProfile(@Request() req) {
    return this.authService.findById(req.user.id);
  }

  @Post('social')
  async socialAuth(@Body() socialAuthDto: SocialAuthDto) {
    return this.authService.socialAuth(socialAuthDto);
  }
}