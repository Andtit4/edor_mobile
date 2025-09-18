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
import { ServiceCompletionService } from './service-completion.service';
// import { CreateServiceRequestDto } from './dto/create-service-request.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CreateServiceRequestDto } from './dto/create-service-request';
import { CompleteServiceRequestDto } from './dto/complete-service-request.dto';

@Controller('service-requests')
export class ServiceRequestsController {
  constructor(
    private readonly serviceRequestsService: ServiceRequestsService,
    private readonly serviceCompletionService: ServiceCompletionService,
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
      req.user.email, // Passer l'email du client connecté
    );
  }

  @Get()
  findAll() {
    return this.serviceRequestsService.findAll();
  }

  @Get('my-requests')
  @UseGuards(JwtAuthGuard)
  findMyRequests(@Request() req) {
    console.log('=== MY REQUESTS ENDPOINT ===');
    console.log('User ID:', req.user?.id);
    console.log('User email:', req.user?.email);
    console.log('User role:', req.user?.role);
    console.log('===========================');
    return this.serviceRequestsService.findByClient(req.user.id);
  }

  @Get('assigned-to-me')
  @UseGuards(JwtAuthGuard)
  findAssignedToMe(@Request() req) {
    return this.serviceRequestsService.findByPrestataire(req.user.id);
  }

  @Get(':id')
  @UseGuards(JwtAuthGuard)
  findOne(@Param('id') id: string, @Request() req) {
    return this.serviceRequestsService.findOne(id, req.user.id, req.user.role);
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

  @Put(':id/complete')
  @UseGuards(JwtAuthGuard)
  completeServiceRequest(
    @Param('id') id: string,
    @Body() completeServiceRequestDto: CompleteServiceRequestDto,
    @Request() req,
  ) {
    return this.serviceCompletionService.completeServiceRequestWithReview(
      id,
      completeServiceRequestDto,
      req.user.id,
    );
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  remove(@Param('id') id: string) {
    return this.serviceRequestsService.remove(id);
  }
}
