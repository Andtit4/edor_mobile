// backend/src/service-offers/service-offers.controller.ts
import { Controller, Get, Post, Body, Param, Put, Delete, UseGuards, Request } from '@nestjs/common';
import { ServiceOffersService } from './service-offers.service';
import { CreateServiceOfferDto } from './dto/create-service-offer.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('service-offers')
export class ServiceOffersController {
  constructor(private readonly serviceOffersService: ServiceOffersService) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  create(@Body() createServiceOfferDto: CreateServiceOfferDto, @Request() req) {
    return this.serviceOffersService.create(createServiceOfferDto, req.user.id);
  }

  @Get()
  findAll() {
    return this.serviceOffersService.findAll();
  }

  @Get('my-offers')
  @UseGuards(JwtAuthGuard)
  findMyOffers(@Request() req) {
    return this.serviceOffersService.findByPrestataire(req.user.id);
  }

  @Get('category/:category')
  findByCategory(@Param('category') category: string) {
    return this.serviceOffersService.findByCategory(category);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.serviceOffersService.findOne(id);
  }

  @Put(':id')
  @UseGuards(JwtAuthGuard)
  update(@Param('id') id: string, @Body() updateServiceOfferDto: CreateServiceOfferDto) {
    return this.serviceOffersService.update(id, updateServiceOfferDto);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  remove(@Param('id') id: string) {
    return this.serviceOffersService.remove(id);
  }
}