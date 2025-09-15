// backend/src/prestataires/prestataires.controller.ts
import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Put,
  Delete,
  UseGuards,
  Request,
} from '@nestjs/common';
import { PrestatairesService } from './prestataire.service';
import { CreatePrestataireDto } from './dto/create-prestataire.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('prestataires')
export class PrestatairesController {
  constructor(private readonly prestatairesService: PrestatairesService) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  create(@Body() createPrestataireDto: CreatePrestataireDto, @Request() req) {
    return this.prestatairesService.create(createPrestataireDto);
  }

  @Get()
  findAll() {
    return this.prestatairesService.findAll();
  }

  @Get('category/:category')
  findByCategory(@Param('category') category: string) {
    return this.prestatairesService.findByCategory(category);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.prestatairesService.findOne(id);
  }

  @Put(':id')
  @UseGuards(JwtAuthGuard)
  update(
    @Param('id') id: string,
    @Body() updatePrestataireDto: CreatePrestataireDto,
  ) {
    return this.prestatairesService.update(id, updatePrestataireDto);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  remove(@Param('id') id: string) {
    return this.prestatairesService.remove(id);
  }
}
