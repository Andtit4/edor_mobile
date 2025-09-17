// backend/src/price-negotiations/price-negotiations.controller.ts
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
import { PriceNegotiationsService } from './price-negotiations.service';
import { CreatePriceNegotiationDto } from './dto/create-price-negotiation.dto';
import { UpdatePriceNegotiationDto } from './dto/update-price-negotiation.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('price-negotiations')
export class PriceNegotiationsController {
  constructor(private readonly priceNegotiationsService: PriceNegotiationsService) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  create(
    @Body() createPriceNegotiationDto: CreatePriceNegotiationDto,
    @Request() req,
  ) {
    return this.priceNegotiationsService.create(
      createPriceNegotiationDto,
      req.user.id,
      req.user.role,
    );
  }

  @Get('service-request/:serviceRequestId')
  @UseGuards(JwtAuthGuard)
  findByServiceRequest(
    @Param('serviceRequestId') serviceRequestId: string,
    @Request() req,
  ) {
    return this.priceNegotiationsService.findByServiceRequest(serviceRequestId, req.user.id);
  }

  @Get(':id')
  @UseGuards(JwtAuthGuard)
  findOne(@Param('id') id: string, @Request() req) {
    return this.priceNegotiationsService.findOne(id, req.user.id);
  }

  @Put(':id/status')
  @UseGuards(JwtAuthGuard)
  updateStatus(
    @Param('id') id: string,
    @Body() updatePriceNegotiationDto: UpdatePriceNegotiationDto,
    @Request() req,
  ) {
    return this.priceNegotiationsService.updateStatus(id, updatePriceNegotiationDto, req.user.id);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  remove(@Param('id') id: string, @Request() req) {
    return this.priceNegotiationsService.remove(id, req.user.id);
  }
}
