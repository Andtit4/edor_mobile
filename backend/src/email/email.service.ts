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
