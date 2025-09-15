// backend/src/service-offers/service-offers.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ServiceOffer } from '../entities/service-offer.entity';
import { CreateServiceOfferDto } from './dto/create-service-offer.dto';

@Injectable()
export class ServiceOffersService {
  constructor(
    @InjectRepository(ServiceOffer)
    private serviceOfferRepository: Repository<ServiceOffer>,
  ) {}

  async create(
    createServiceOfferDto: CreateServiceOfferDto,
    prestataireId: string,
  ): Promise<ServiceOffer> {
    const serviceOffer = this.serviceOfferRepository.create({
      ...createServiceOfferDto,
      images: createServiceOfferDto.images || [], // Valeur par défaut dans le code
    });
    return this.serviceOfferRepository.save(serviceOffer);
  }

  async findAll(): Promise<ServiceOffer[]> {
    return this.serviceOfferRepository.find({
      where: { status: 'available' as any },
      order: { rating: 'DESC', createdAt: 'DESC' },
    });
  }

  async findByPrestataire(prestataireId: string): Promise<ServiceOffer[]> {
    return this.serviceOfferRepository.find({
      where: { prestataireId },
      order: { createdAt: 'DESC' },
    });
  }

  async findByCategory(category: string): Promise<ServiceOffer[]> {
    return this.serviceOfferRepository.find({
      where: { category, status: 'available' as any },
      order: { rating: 'DESC' },
    });
  }

  async findOne(id: string): Promise<ServiceOffer> {
    const serviceOffer = await this.serviceOfferRepository.findOne({
      where: { id },
    });

    if (!serviceOffer) {
      throw new NotFoundException('Offre de service non trouvée');
    }

    return serviceOffer;
  }

  async update(
    id: string,
    updateData: Partial<CreateServiceOfferDto>,
  ): Promise<ServiceOffer> {
    await this.serviceOfferRepository.update(id, updateData);
    return this.findOne(id);
  }

  async remove(id: string): Promise<void> {
    const result = await this.serviceOfferRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException('Offre de service non trouvée');
    }
  }
}
