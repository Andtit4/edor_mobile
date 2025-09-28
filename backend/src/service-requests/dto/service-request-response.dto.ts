import { ServiceRequest } from '../../entities/service-request.entity';

export class ServiceRequestResponseDto {
  id: string;
  title: string;
  description: string;
  category: string;
  clientId: string;
  clientName: string;
  clientPhone: string;
  location: string;
  latitude?: number;
  longitude?: number;
  budget: number;
  deadline: Date;
  status: string;
  assignedPrestataireId?: string;
  prestataireName?: string;
  notes?: string;
  completionDate?: Date;
  completionNotes?: string;
  photos?: string[];
  clientImage?: string;
  createdAt: Date;
  updatedAt: Date;

  // Informations supplémentaires du prestataire assigné
  assignedPrestataireName?: string;

  constructor(partial: Partial<ServiceRequestResponseDto>) {
    Object.assign(this, partial);
  }
}
