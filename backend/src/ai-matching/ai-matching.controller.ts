// backend/src/ai-matching/ai-matching.controller.ts
import {
  Controller,
  Post,
  Get,
  Body,
  Param,
  UseGuards,
  Request,
} from '@nestjs/common';
import { AIMatchingService } from './ai-matching.service';
import { AIMatchRequestDto, AIMatchResponseDto } from './dto/ai-match-request.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('ai-matching')
export class AIMatchingController {
  constructor(private readonly aiMatchingService: AIMatchingService) {}

  /**
   * Génère des recommandations IA pour une demande de service
   */
  @Post('generate-matches')
  @UseGuards(JwtAuthGuard)
  async generateMatches(
    @Body() requestDto: AIMatchRequestDto,
    @Request() req,
  ): Promise<AIMatchResponseDto[]> {
    return this.aiMatchingService.generateMatches(requestDto);
  }

  /**
   * Récupère les matches existants pour une demande de service
   */
  @Get('matches/:serviceRequestId')
  @UseGuards(JwtAuthGuard)
  async getMatchesForRequest(
    @Param('serviceRequestId') serviceRequestId: string,
    @Request() req,
  ): Promise<AIMatchResponseDto[]> {
    return this.aiMatchingService.getMatchesForRequest(serviceRequestId);
  }

  /**
   * Endpoint pour tester le matching (sans authentification pour les tests)
   */
  @Post('test-matches')
  async testMatches(@Body() requestDto: AIMatchRequestDto): Promise<AIMatchResponseDto[]> {
    return this.aiMatchingService.generateMatches(requestDto);
  }
}
