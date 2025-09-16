// backend/src/prestataires/prestataire.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Prestataire } from '../entities/prestataire.entity';
import { CreatePrestataireDto } from './dto/create-prestataire.dto';
import { UpdatePrestataireProfileDto } from './dto/update-prestataire-profile.dto';

@Injectable()
export class PrestatairesService {
  constructor(
    @InjectRepository(Prestataire)
    private prestataireRepository: Repository<Prestataire>,
  ) {}

  async create(
    createPrestataireDto: CreatePrestataireDto,
  ): Promise<Prestataire> {
    const prestataire = this.prestataireRepository.create({
      ...createPrestataireDto,
      skills: createPrestataireDto.skills || [], // Valeur par défaut dans le code
      portfolio: createPrestataireDto.portfolio || [], // Valeur par défaut dans le code
    });
    return this.prestataireRepository.save(prestataire);
  }

  async findAll(): Promise<Prestataire[]> {
    return this.prestataireRepository.find({
      where: { isAvailable: true },
      order: { rating: 'DESC', createdAt: 'DESC' },
    });
  }

  async findOne(id: string): Promise<Prestataire> {
    const prestataire = await this.prestataireRepository.findOne({
      where: { id },
      relations: ['serviceOffers'],
    });

    if (!prestataire) {
      throw new NotFoundException('Prestataire non trouvé');
    }

    return prestataire;
  }

  async findByCategory(category: string): Promise<Prestataire[]> {
    return this.prestataireRepository.find({
      where: { category, isAvailable: true },
      order: { rating: 'DESC' },
    });
  }

  async update(
    id: string,
    updateData: Partial<CreatePrestataireDto>,
  ): Promise<Prestataire> {
    await this.prestataireRepository.update(id, updateData);
    return this.findOne(id);
  }

  async remove(id: string): Promise<void> {
    const result = await this.prestataireRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException('Prestataire non trouvé');
    }
  }

  async findByUserId(userId: string): Promise<Prestataire> {
    const prestataire = await this.prestataireRepository.findOne({
      where: { email: userId }, // On utilise l'email comme lien entre User et Prestataire
    });

    if (!prestataire) {
      throw new NotFoundException('Profil prestataire non trouvé');
    }

    return prestataire;
  }

  async updateByUserId(
    userId: string,
    updateData: UpdatePrestataireProfileDto,
  ): Promise<Prestataire> {
    const prestataire = await this.findByUserId(userId);
    await this.prestataireRepository.update(prestataire.id, updateData);
    return this.findOne(prestataire.id);
  }
}
