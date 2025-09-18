import { Injectable } from '@nestjs/common';
import { MailerService } from '@nestjs-modules/mailer';

@Injectable()
export class EmailService {
  constructor(private readonly mailerService: MailerService) {}

  async sendWelcomeEmail(email: string, firstName: string, lastName: string, role: string) {
    const fullName = `${firstName} ${lastName}`;
    const roleText = role === 'prestataire' ? 'prestataire de services' : 'client';
    const isPrestataire = role === 'prestataire';
    
    // Vérifier si les credentials email sont configurés
    if (!process.env.MAIL_USER || !process.env.MAIL_PASS) {
      console.log(`Email de bienvenue non envoyé à ${email} - Configuration email manquante`);
      console.log('Pour activer l\'envoi d\'emails, configurez MAIL_USER et MAIL_PASS dans votre fichier .env');
      return;
    }
    
    try {
      await this.mailerService.sendMail({
        to: email,
        subject: 'Bienvenue sur Edor - Votre compte a été créé avec succès !',
        template: 'welcome', // Nom du template
        context: {
          fullName,
          firstName,
          lastName,
          role: roleText,
          email,
          isPrestataire,
        },
      });
      console.log(`Email de bienvenue envoyé à ${email}`);
    } catch (error) {
      console.error(`Erreur lors de l'envoi de l'email à ${email}:`, error);
      // Ne pas faire échouer l'inscription si l'email ne peut pas être envoyé
    }
  }

  async sendServiceRequestConfirmation(
    clientEmail: string,
    clientName: string,
    requestData: {
      id: string;
      title: string;
      description: string;
      category: string;
      location: string;
      budget: number;
      deadline: string;
    }
  ) {
    // Vérifier si les credentials email sont configurés
    if (!process.env.MAIL_USER || !process.env.MAIL_PASS) {
      console.log(`Email de confirmation non envoyé à ${clientEmail} - Configuration email manquante`);
      return;
    }

    try {
      await this.mailerService.sendMail({
        to: clientEmail,
        subject: 'Confirmation de votre demande de service - Edor',
        template: 'service-request-confirmation',
        context: {
          clientName,
          requestId: requestData.id.substring(0, 8).toUpperCase(),
          title: requestData.title,
          description: requestData.description,
          category: requestData.category,
          location: requestData.location,
          budget: requestData.budget.toLocaleString(),
          deadline: requestData.deadline,
        },
      });
      console.log(`Email de confirmation envoyé à ${clientEmail} pour la demande ${requestData.id}`);
    } catch (error) {
      console.error(`Erreur lors de l'envoi de l'email de confirmation à ${clientEmail}:`, error);
      // Ne pas faire échouer la création de demande si l'email ne peut pas être envoyé
    }
  }

  async sendPriceProposalNotification(
    clientEmail: string,
    clientName: string,
    proposalData: {
      requestId: string;
      serviceTitle: string;
      proposedPrice: number;
      initialBudget: number;
      location: string;
      prestataireName: string;
      prestataireCategory: string;
      prestataireRating: number;
      prestataireReviews: number;
      message?: string;
    }
  ) {
    // Vérifier si les credentials email sont configurés
    if (!process.env.MAIL_USER || !process.env.MAIL_PASS) {
      console.log(`Email de notification non envoyé à ${clientEmail} - Configuration email manquante`);
      return;
    }

    try {
      await this.mailerService.sendMail({
        to: clientEmail,
        subject: 'Nouvelle proposition de prix reçue - Edor',
        template: 'price-proposal-notification',
        context: {
          clientName,
          requestId: proposalData.requestId.substring(0, 8).toUpperCase(),
          serviceTitle: proposalData.serviceTitle,
          proposedPrice: proposalData.proposedPrice.toLocaleString(),
          initialBudget: proposalData.initialBudget.toLocaleString(),
          location: proposalData.location,
          prestataireName: proposalData.prestataireName,
          prestataireInitial: proposalData.prestataireName.charAt(0).toUpperCase(),
          prestataireCategory: proposalData.prestataireCategory,
          prestataireRating: proposalData.prestataireRating.toFixed(1),
          prestataireReviews: proposalData.prestataireReviews,
          message: proposalData.message,
        },
      });
      console.log(`Email de notification envoyé à ${clientEmail} pour la proposition ${proposalData.requestId}`);
    } catch (error) {
      console.error(`Erreur lors de l'envoi de l'email de notification à ${clientEmail}:`, error);
      // Ne pas faire échouer la création de proposition si l'email ne peut pas être envoyé
    }
  }

  async sendOfferAcceptedNotification(
    prestataireEmail: string,
    prestataireName: string,
    offerData: {
      requestId: string;
      serviceTitle: string;
      acceptedPrice: number;
      location: string;
      deadline: string;
      clientName: string;
      clientPhone: string;
      acceptanceDate: string;
      message?: string;
    }
  ) {
    // Vérifier si les credentials email sont configurés
    if (!process.env.MAIL_USER || !process.env.MAIL_PASS) {
      console.log(`Email de notification non envoyé à ${prestataireEmail} - Configuration email manquante`);
      return;
    }

    try {
      await this.mailerService.sendMail({
        to: prestataireEmail,
        subject: 'Félicitations ! Votre offre a été acceptée - Edor',
        template: 'offer-accepted-notification',
        context: {
          prestataireName,
          requestId: offerData.requestId.substring(0, 8).toUpperCase(),
          serviceTitle: offerData.serviceTitle,
          acceptedPrice: offerData.acceptedPrice.toLocaleString(),
          location: offerData.location,
          deadline: offerData.deadline,
          clientName: offerData.clientName,
          clientInitial: offerData.clientName.charAt(0).toUpperCase(),
          clientPhone: offerData.clientPhone,
          acceptanceDate: offerData.acceptanceDate,
          message: offerData.message,
        },
      });
      console.log(`Email de notification envoyé à ${prestataireEmail} pour l'offre acceptée ${offerData.requestId}`);
    } catch (error) {
      console.error(`Erreur lors de l'envoi de l'email de notification à ${prestataireEmail}:`, error);
      // Ne pas faire échouer l'acceptation si l'email ne peut pas être envoyé
    }
  }

  async sendProjectCompletionFeedback(
    prestataireEmail: string,
    prestataireName: string,
    feedbackData: {
      requestId: string;
      serviceTitle: string;
      finalPrice: number;
      completionDate: string;
      location: string;
      clientName: string;
      clientPhone: string;
      rating: number;
      reviewComment?: string;
      completionNotes?: string;
    }
  ) {
    // Vérifier si les credentials email sont configurés
    if (!process.env.MAIL_USER || !process.env.MAIL_PASS) {
      console.log(`Email de feedback non envoyé à ${prestataireEmail} - Configuration email manquante`);
      return;
    }

    // Générer les étoiles pour l'affichage
    const stars = '★'.repeat(feedbackData.rating) + '☆'.repeat(5 - feedbackData.rating);

    try {
      await this.mailerService.sendMail({
        to: prestataireEmail,
        subject: 'Feedback de votre projet terminé - Edor',
        template: 'project-completion-feedback',
        context: {
          prestataireName,
          requestId: feedbackData.requestId.substring(0, 8).toUpperCase(),
          serviceTitle: feedbackData.serviceTitle,
          finalPrice: feedbackData.finalPrice.toLocaleString(),
          completionDate: feedbackData.completionDate,
          location: feedbackData.location,
          clientName: feedbackData.clientName,
          clientInitial: feedbackData.clientName.charAt(0).toUpperCase(),
          clientPhone: feedbackData.clientPhone,
          rating: feedbackData.rating,
          stars: stars,
          reviewComment: feedbackData.reviewComment,
          completionNotes: feedbackData.completionNotes,
        },
      });
      console.log(`Email de feedback envoyé à ${prestataireEmail} pour le projet ${feedbackData.requestId}`);
    } catch (error) {
      console.error(`Erreur lors de l'envoi de l'email de feedback à ${prestataireEmail}:`, error);
      // Ne pas faire échouer la clôture si l'email ne peut pas être envoyé
    }
  }

  async sendTestEmail() {
    try {
      await this.mailerService.sendMail({
        to: 'test@example.com',
        subject: 'Test Email',
        text: 'Ceci est un email de test',
      });
      console.log('Email de test envoyé avec succès');
    } catch (error) {
      console.error('Erreur lors de l\'envoi de l\'email de test:', error);
    }
  }
}
