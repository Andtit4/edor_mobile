// backend/src/prestataires/prestataire.controller.ts
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
import { UpdatePrestataireProfileDto } from './dto/update-prestataire-profile.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('prestataires')
export class PrestatairesController {
  constructor(private readonly prestatairesService: PrestatairesService) {}

  @Post()
  create(@Body() createPrestataireDto: CreatePrestataireDto) {
    return this.prestatairesService.create(createPrestataireDto);
  }

  @Get()
  findAll() {
    return this.prestatairesService.findAll();
  }

  @Get('my-profile')
  @UseGuards(JwtAuthGuard)
  findMyProfile(@Request() req) {
    return this.prestatairesService.findByUserId(req.user.id);
  }

  @Put('my-profile')
  @UseGuards(JwtAuthGuard)
  updateMyProfile(
    @Request() req,
    @Body() updatePrestataireProfileDto: UpdatePrestataireProfileDto,
  ) {
    return this.prestatairesService.updateByUserId(
      req.user.id,
      updatePrestataireProfileDto,
    );
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
  update(
    @Param('id') id: string,
    @Body() updatePrestataireDto: CreatePrestataireDto,
  ) {
    return this.prestatairesService.update(id, updatePrestataireDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.prestatairesService.remove(id);
  }
}
