import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Prestataire } from '../entities/prestataire.entity';
import { User } from '../entities/user.entity';
import * as admin from 'firebase-admin';
import * as path from 'path';

@Injectable()
export class NotificationsService {
  constructor(
    @InjectRepository(Prestataire)
    private readonly prestataireRepository: Repository<Prestataire>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {
    // Initialiser Firebase Admin SDK si pas déjà fait
    try {
      if (!admin.apps.length) {
        // Utiliser la clé de service locale
        const serviceAccountPath = path.join(process.cwd(), 'key.json');
        console.log(`🔍 Tentative de chargement de: ${serviceAccountPath}`);
        
        const serviceAccount = require(serviceAccountPath);
        console.log('📄 Fichier key.json chargé avec succès');
        
        admin.initializeApp({
          credential: admin.credential.cert(serviceAccount),
          projectId: 'edor-mobile',
        });
        console.log('✅ Firebase Admin SDK initialisé avec succès !');
        console.log(`📁 Clé de service: ${serviceAccountPath}`);
        console.log(`🔑 Project ID: edor-mobile`);
      } else {
        console.log('✅ Firebase Admin SDK déjà initialisé');
      }
    } catch (error) {
      console.error('❌ ERREUR CRITIQUE Firebase Admin SDK:', error.message);
      console.error('❌ Stack trace:', error.stack);
      console.log('📋 Vérifiez que le fichier key.json existe dans le dossier backend');
    }
  }

  /**
   * Envoyer une notification push à tous les prestataires d'une catégorie
   */
  async sendNotificationToCategory(
    category: string,
    notification: {
      title: string;
      body: string;
      data?: any;
    }
  ): Promise<void> {
    try {
      console.log(`🔔 Envoi de notification pour la catégorie: ${category}`);
      
      // Récupérer tous les prestataires de cette catégorie
      const prestataires = await this.prestataireRepository.find({
        where: { category },
        select: ['id', 'firstName', 'lastName', 'fcmToken', 'category']
      });

      console.log(`📱 ${prestataires.length} prestataires trouvés pour la catégorie ${category}`);

      if (prestataires.length === 0) {
        console.log(`⚠️ Aucun prestataire trouvé pour la catégorie ${category}`);
        return;
      }

      // Filtrer les prestataires qui ont un token FCM
      const prestatairesWithTokens = prestataires.filter(p => p.fcmToken);
      console.log(`📱 ${prestatairesWithTokens.length} prestataires avec token FCM`);

      if (prestatairesWithTokens.length === 0) {
        console.log(`⚠️ Aucun prestataire avec token FCM pour la catégorie ${category}`);
        return;
      }

      // Envoyer les notifications individuellement
      let successCount = 0;
      let failureCount = 0;

      for (const prestataire of prestatairesWithTokens) {
        try {
          // Convertir toutes les données en strings pour Firebase
          const dataPayload: { [key: string]: string } = {
            type: 'service_request',
            category: category,
          };

          // Ajouter les données supplémentaires en les convertissant en strings
          if (notification.data) {
            Object.keys(notification.data).forEach(key => {
              const value = notification.data[key];
              dataPayload[key] = typeof value === 'string' ? value : JSON.stringify(value);
            });
          }

          const message = {
            notification: {
              title: notification.title,
              body: notification.body,
            },
            data: dataPayload,
            token: prestataire.fcmToken,
          };

          // Vérifier si Firebase Admin SDK est disponible et configuré
          if (admin.apps.length > 0) {
            try {
              await admin.messaging().send(message);
              successCount++;
              console.log(`✅ Notification envoyée à ${prestataire.firstName} ${prestataire.lastName}`);
            } catch (firebaseError) {
              console.error(`❌ ERREUR Firebase pour ${prestataire.firstName} ${prestataire.lastName}:`, firebaseError);
              failureCount++;
            }
          } else {
            console.error(`❌ Firebase Admin SDK non initialisé pour ${prestataire.firstName} ${prestataire.lastName}`);
            failureCount++;
          }
        } catch (error) {
          failureCount++;
          console.error(`❌ Échec pour ${prestataire.firstName} ${prestataire.lastName}:`, error);
        }
      }
      
      console.log(`✅ Notifications envoyées: ${successCount} succès, ${failureCount} échecs`);

    } catch (error) {
      console.error('❌ Erreur lors de l\'envoi de notification:', error);
      throw error;
    }
  }

  /**
   * Envoyer une notification à un prestataire spécifique
   */
  async sendNotificationToPrestataire(
    prestataireId: string,
    notification: {
      title: string;
      body: string;
      data?: any;
    }
  ): Promise<void> {
    try {
      const prestataire = await this.prestataireRepository.findOne({
        where: { id: prestataireId },
        select: ['id', 'firstName', 'lastName', 'fcmToken']
      });

      if (!prestataire) {
        console.log(`⚠️ Prestataire ${prestataireId} non trouvé`);
        return;
      }

      if (!prestataire.fcmToken) {
        console.log(`⚠️ Prestataire ${prestataire.firstName} ${prestataire.lastName} n'a pas de token FCM`);
        return;
      }

      const message = {
        notification: {
          title: notification.title,
          body: notification.body,
        },
        data: {
          type: 'direct',
          ...notification.data,
        },
        token: prestataire.fcmToken,
      };

      const response = await admin.messaging().send(message);
      console.log(`✅ Notification envoyée à ${prestataire.firstName} ${prestataire.lastName}: ${response}`);

    } catch (error) {
      console.error('❌ Erreur lors de l\'envoi de notification:', error);
      throw error;
    }
  }

  /**
   * Mettre à jour le token FCM d'un utilisateur (client ou prestataire)
   */
  async updateFcmToken(userId: string, fcmToken: string): Promise<void> {
    try {
      console.log(`🔧 Mise à jour du token FCM pour l'utilisateur ${userId}...`);
      
      // Essayer d'abord de mettre à jour dans la table prestataires
      const prestataireResult = await this.prestataireRepository.update(userId, { fcmToken });
      if (prestataireResult.affected && prestataireResult.affected > 0) {
        console.log(`✅ Token FCM mis à jour pour le prestataire ${userId}`);
        return;
      }
      
      // Si pas trouvé dans prestataires, essayer dans la table users
      const userResult = await this.userRepository.update(userId, { fcmToken });
      if (userResult.affected && userResult.affected > 0) {
        console.log(`✅ Token FCM mis à jour pour le client ${userId}`);
        return;
      }
      
      // Si aucun utilisateur trouvé
      console.log(`⚠️ Aucun utilisateur trouvé avec l'ID ${userId}`);
      throw new Error(`Utilisateur non trouvé: ${userId}`);
      
    } catch (error) {
      console.error('❌ Erreur lors de la mise à jour du token FCM:', error);
      throw error;
    }
  }

  /**
   * Notifier un client qu'il a reçu une offre d'un prestataire
   */
  async notifyClientOfOffer({
    clientId,
    prestataireId,
    prestataireName,
    serviceRequestId,
    serviceTitle,
    proposedPrice,
    message,
  }: {
    clientId: string;
    prestataireId: string;
    prestataireName: string;
    serviceRequestId: string;
    serviceTitle: string;
    proposedPrice: number;
    message?: string;
  }): Promise<void> {
    try {
      console.log(`🔔 Notification d'offre au client ${clientId}...`);
      
      // Récupérer le client avec son token FCM
      const client = await this.userRepository.findOne({
        where: { id: clientId },
      });

      if (!client) {
        console.log(`⚠️ Client ${clientId} non trouvé`);
        return;
      }

      if (!client.fcmToken) {
        console.log(`⚠️ Client ${client.firstName} ${client.lastName} n'a pas de token FCM`);
        return;
      }

      const notificationTitle = `Nouvelle offre reçue !`;
      const notificationBody = message 
        ? `${prestataireName} propose ${proposedPrice} FCFA pour "${serviceTitle}"`
        : `${prestataireName} propose ${proposedPrice} FCFA pour "${serviceTitle}"`;

      const fcmMessage = {
        notification: {
          title: notificationTitle,
          body: notificationBody,
        },
        data: {
          type: 'offer_received',
          serviceRequestId: serviceRequestId,
          prestataireId: prestataireId,
          prestataireName: prestataireName,
          proposedPrice: proposedPrice.toString(),
          serviceTitle: serviceTitle,
          message: message || '',
        },
        token: client.fcmToken,
      };

      const response = await admin.messaging().send(fcmMessage);
      console.log(`✅ Notification d'offre envoyée au client ${client.firstName} ${client.lastName}: ${response}`);

    } catch (error) {
      console.error('❌ Erreur lors de l\'envoi de notification d\'offre au client:', error);
      throw error;
    }
  }

  /**
   * Notifier un prestataire que le client a accepté son offre
   */
  async notifyPrestataireOfAcceptance({
    prestataireId,
    clientId,
    clientName,
    serviceRequestId,
    serviceTitle,
    acceptedPrice,
  }: {
    prestataireId: string;
    clientId: string;
    clientName: string;
    serviceRequestId: string;
    serviceTitle: string;
    acceptedPrice: number;
  }): Promise<void> {
    try {
      console.log(`🔔 Notification d'acceptation au prestataire ${prestataireId}...`);
      
      // Récupérer le prestataire avec son token FCM
      const prestataire = await this.prestataireRepository.findOne({
        where: { id: prestataireId },
      });

      if (!prestataire) {
        console.log(`⚠️ Prestataire ${prestataireId} non trouvé`);
        return;
      }

      if (!prestataire.fcmToken) {
        console.log(`⚠️ Prestataire ${prestataire.firstName} ${prestataire.lastName} n'a pas de token FCM`);
        return;
      }

      const notificationTitle = `Offre acceptée ! 🎉`;
      const notificationBody = `${clientName} a accepté votre offre de ${acceptedPrice} FCFA pour "${serviceTitle}"`;

      const fcmMessage = {
        notification: {
          title: notificationTitle,
          body: notificationBody,
        },
        data: {
          type: 'offer_accepted',
          serviceRequestId: serviceRequestId,
          clientId: clientId,
          clientName: clientName,
          acceptedPrice: acceptedPrice.toString(),
          serviceTitle: serviceTitle,
        },
        token: prestataire.fcmToken,
      };

      const response = await admin.messaging().send(fcmMessage);
      console.log(`✅ Notification d'acceptation envoyée au prestataire ${prestataire.firstName} ${prestataire.lastName}: ${response}`);

    } catch (error) {
      console.error('❌ Erreur lors de l\'envoi de notification d\'acceptation au prestataire:', error);
      throw error;
    }
  }
}
