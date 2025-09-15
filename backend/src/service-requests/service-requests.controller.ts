// backend/src/service-requests/service-requests.controller.ts
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
import { ServiceRequestsService } from './service-requests.service';
// import { CreateServiceRequestDto } from './dto/create-service-request.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CreateServiceRequestDto } from './dto/create-service-request';

@Controller('service-requests')
export class ServiceRequestsController {
  constructor(
    private readonly serviceRequestsService: ServiceRequestsService,
  ) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  create(
    @Body() createServiceRequestDto: CreateServiceRequestDto,
    @Request() req,
  ) {
    return this.serviceRequestsService.create(
      createServiceRequestDto,
      req.user.id,
    );
  }

  @Get()
  findAll() {
    return this.serviceRequestsService.findAll();
  }

  @Get('my-requests')
  @UseGuards(JwtAuthGuard)
  findMyRequests(@Request() req) {
    return this.serviceRequestsService.findByClient(req.user.id);
  }

  @Get('assigned-to-me')
  @UseGuards(JwtAuthGuard)
  findAssignedToMe(@Request() req) {
    return this.serviceRequestsService.findByPrestataire(req.user.id);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.serviceRequestsService.findOne(id);
  }

  @Put(':id')
  @UseGuards(JwtAuthGuard)
  update(
    @Param('id') id: string,
    @Body() updateServiceRequestDto: CreateServiceRequestDto,
  ) {
    return this.serviceRequestsService.update(id, updateServiceRequestDto);
  }

  @Put(':id/assign')
  @UseGuards(JwtAuthGuard)
  assignPrestataire(
    @Param('id') id: string,
    @Body() body: { prestataireId: string; prestataireName: string },
  ) {
    return this.serviceRequestsService.assignPrestataire(
      id,
      body.prestataireId,
      body.prestataireName,
    );
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  remove(@Param('id') id: string) {
    return this.serviceRequestsService.remove(id);
  }
}
