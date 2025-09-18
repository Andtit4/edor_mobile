import { PriceNegotiation, NegotiationStatus } from '../../entities/price-negotiation.entity';

export class PriceNegotiationResponseDto {
  id: string;
  serviceRequestId: string;
  prestataireId: string;
  clientId: string;
  proposedPrice: number;
  message?: string;
  status: NegotiationStatus;
  isFromPrestataire: boolean;
  parentNegotiationId?: string;
  createdAt: Date;
  updatedAt: Date;
  
  // Informations supplémentaires
  prestataireName?: string;
  serviceRequestTitle?: string;
  clientName?: string;

  constructor(negotiation: PriceNegotiation & { 
    prestataireName?: string; 
    serviceRequestTitle?: string; 
    clientName?: string; 
  }) {
    this.id = negotiation.id;
    this.serviceRequestId = negotiation.serviceRequestId;
    this.prestataireId = negotiation.prestataireId;
    this.clientId = negotiation.clientId;
    this.proposedPrice = negotiation.proposedPrice;
    this.message = negotiation.message;
    this.status = negotiation.status;
    this.isFromPrestataire = negotiation.isFromPrestataire;
    this.parentNegotiationId = negotiation.parentNegotiationId;
    this.createdAt = negotiation.createdAt;
    this.updatedAt = negotiation.updatedAt;
    this.prestataireName = negotiation.prestataireName;
    this.serviceRequestTitle = negotiation.serviceRequestTitle;
    this.clientName = negotiation.clientName;
  }
}
