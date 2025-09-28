import { Controller, Post, UseGuards } from '@nestjs/common';
import { EmailService } from './email.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('email')
export class EmailController {
  constructor(private readonly emailService: EmailService) {}

  @Post('test')
  @UseGuards(JwtAuthGuard)
  async testEmail() {
    await this.emailService.sendTestEmail();
    return { message: 'Email de test envoyé avec succès' };
  }
}
