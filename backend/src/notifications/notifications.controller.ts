import { Controller, Post, Body, UseGuards, Request, Get, Param } from '@nestjs/common';
import { NotificationsService } from './notifications.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Prestataire } from '../entities/prestataire.entity';
import { User } from '../entities/user.entity';

@Controller('notifications')
export class NotificationsController {
  constructor(
    private readonly notificationsService: NotificationsService,
    @InjectRepository(Prestataire)
    private prestataireRepository: Repository<Prestataire>,
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  @Post('update-token')
  @UseGuards(JwtAuthGuard)
  async updateFcmToken(
    @Request() req,
    @Body() body: { fcmToken: string }
  ) {
    await this.notificationsService.updateFcmToken(req.user.id, body.fcmToken);
    return { message: 'Token FCM mis à jour avec succès' };
  }

  @Post('test-category')
  @UseGuards(JwtAuthGuard)
  async testCategoryNotification(
    @Body() body: { 
      category: string;
      title: string;
      body: string;
    }
  ) {
    await this.notificationsService.sendNotificationToCategory(
      body.category,
      {
        title: body.title,
        body: body.body,
        data: { test: true }
      }
    );
    return { message: 'Notification de test envoyée' };
  }

  @Get('debug/prestataires')
  async debugPrestataires() {
    const prestataires = await this.prestataireRepository.find({
      select: ['id', 'firstName', 'lastName', 'category', 'fcmToken'],
    });

    const stats = {
      total: prestataires.length,
      withToken: prestataires.filter(p => p.fcmToken).length,
      withoutToken: prestataires.filter(p => !p.fcmToken).length,
      byCategory: {},
    };

    prestataires.forEach(p => {
      if (!stats.byCategory[p.category]) {
        stats.byCategory[p.category] = { total: 0, withToken: 0 };
      }
      stats.byCategory[p.category].total++;
      if (p.fcmToken) {
        stats.byCategory[p.category].withToken++;
      }
    });

    return {
      message: 'Debug info for prestataires FCM tokens',
      stats,
      prestataires: prestataires.map(p => ({
        id: p.id,
        name: `${p.firstName} ${p.lastName}`,
        category: p.category,
        hasToken: !!p.fcmToken,
      })),
    };
  }

  @Get('debug/users')
  async debugUsers() {
    try {
      const users = await this.userRepository.find({
        select: ['id', 'firstName', 'lastName', 'fcmToken', 'role']
      });

      const stats = {
        total: users.length,
        withToken: users.filter(u => u.fcmToken).length,
        withoutToken: users.filter(u => !u.fcmToken).length,
        byRole: {}
      };

      // Grouper par rôle
      users.forEach(user => {
        const role = user.role || 'client';
        if (!stats.byRole[role]) {
          stats.byRole[role] = { total: 0, withToken: 0 };
        }
        stats.byRole[role].total++;
        if (user.fcmToken) {
          stats.byRole[role].withToken++;
        }
      });

      const usersInfo = users.map(u => ({
        id: u.id,
        name: `${u.firstName} ${u.lastName}`,
        role: u.role || 'client',
        hasToken: !!u.fcmToken
      }));

      return {
        message: 'Debug info for users FCM tokens',
        stats,
        users: usersInfo
      };
    } catch (error) {
      return {
        error: 'Erreur lors de la récupération des utilisateurs',
        details: error.message
      };
    }
  }

  @Post('debug/set-token/:prestataireId')
  async setTestToken(
    @Param('prestataireId') prestataireId: string,
    @Body() body: { fcmToken?: string },
  ) {
    const testToken = body.fcmToken || 'test-token-' + Date.now();
    
    await this.prestataireRepository.update(prestataireId, {
      fcmToken: testToken,
    });

    return {
      message: `Token FCM de test défini pour le prestataire ${prestataireId}`,
      token: testToken,
    };
  }

  @Post('debug/test-notification/:category')
  async testNotification(
    @Param('category') category: string,
    @Body() body: { title?: string; body?: string },
  ) {
    const title = body.title || `Test notification ${category}`;
    const notificationBody = body.body || `Ceci est un test de notification pour la catégorie ${category}`;
    
    await this.notificationsService.sendNotificationToCategory(
      category,
      {
        title,
        body: notificationBody,
        data: { test: true, timestamp: new Date().toISOString() }
      }
    );

    return {
      message: `Notification de test envoyée pour la catégorie ${category}`,
      title,
      body: notificationBody,
    };
  }

  @Get('debug/get-my-token')
  @UseGuards(JwtAuthGuard)
  async getMyToken(@Request() req) {
    const prestataire = await this.prestataireRepository.findOne({
      where: { id: req.user.id },
      select: ['id', 'firstName', 'lastName', 'fcmToken', 'category']
    });

    if (!prestataire) {
      return { message: 'Prestataire non trouvé' };
    }

    return {
      message: 'Token FCM récupéré',
      prestataire: {
        id: prestataire.id,
        name: `${prestataire.firstName} ${prestataire.lastName}`,
        category: prestataire.category,
        hasToken: !!prestataire.fcmToken,
        token: prestataire.fcmToken || 'Aucun token FCM'
      }
    };
  }

  @Post('debug/force-firebase-init')
  async forceFirebaseInit() {
    try {
      const admin = require('firebase-admin');
      const path = require('path');
      
      if (!admin.apps.length) {
        const serviceAccountPath = path.join(process.cwd(), 'key.json');
        console.log(`🔍 Force initialisation Firebase: ${serviceAccountPath}`);
        
        const serviceAccount = require(serviceAccountPath);
        admin.initializeApp({
          credential: admin.credential.cert(serviceAccount),
          projectId: 'edor-mobile',
        });
        
        return { 
          message: 'Firebase Admin SDK initialisé avec succès',
          path: serviceAccountPath,
          projectId: 'edor-mobile'
        };
      } else {
        return { message: 'Firebase Admin SDK déjà initialisé' };
      }
    } catch (error) {
      return { 
        error: 'Erreur lors de l\'initialisation Firebase',
        details: error.message,
        stack: error.stack
      };
    }
  }

  @Post('debug/test-offer-notification')
  async testOfferNotification(@Body() body: {
    clientId: string;
    prestataireId: string;
    prestataireName: string;
    serviceRequestId: string;
    serviceTitle: string;
    proposedPrice: number;
    message?: string;
  }) {
    try {
      await this.notificationsService.notifyClientOfOffer({
        clientId: body.clientId,
        prestataireId: body.prestataireId,
        prestataireName: body.prestataireName,
        serviceRequestId: body.serviceRequestId,
        serviceTitle: body.serviceTitle,
        proposedPrice: body.proposedPrice,
        message: body.message,
      });

      return {
        message: 'Notification d\'offre de test envoyée au client',
        details: body
      };
    } catch (error) {
      return {
        error: 'Erreur lors de l\'envoi de la notification d\'offre',
        details: error.message
      };
    }
  }

  @Post('debug/test-acceptance-notification')
  async testAcceptanceNotification(@Body() body: {
    prestataireId: string;
    clientId: string;
    clientName: string;
    serviceRequestId: string;
    serviceTitle: string;
    acceptedPrice: number;
  }) {
    try {
      await this.notificationsService.notifyPrestataireOfAcceptance({
        prestataireId: body.prestataireId,
        clientId: body.clientId,
        clientName: body.clientName,
        serviceRequestId: body.serviceRequestId,
        serviceTitle: body.serviceTitle,
        acceptedPrice: body.acceptedPrice,
      });

      return {
        message: 'Notification d\'acceptation de test envoyée au prestataire',
        details: body
      };
    } catch (error) {
      return {
        error: 'Erreur lors de l\'envoi de la notification d\'acceptation',
        details: error.message
      };
    }
  }

  @Get('debug/fcm-status')
  async getFcmStatus() {
    try {
      const prestataires = await this.prestataireRepository.find({
        select: ['id', 'firstName', 'lastName', 'fcmToken', 'category']
      });

      const users = await this.userRepository.find({
        select: ['id', 'firstName', 'lastName', 'fcmToken', 'role']
      });

      const stats = {
        prestataires: {
          total: prestataires.length,
          withToken: prestataires.filter(p => p.fcmToken).length,
          withoutToken: prestataires.filter(p => !p.fcmToken).length,
        },
        users: {
          total: users.length,
          withToken: users.filter(u => u.fcmToken).length,
          withoutToken: users.filter(u => !u.fcmToken).length,
        }
      };

      const allUsers = [
        ...prestataires.map(p => ({
          id: p.id,
          name: `${p.firstName} ${p.lastName}`,
          type: 'prestataire',
          category: p.category,
          hasToken: !!p.fcmToken,
          token: p.fcmToken || 'NULL'
        })),
        ...users.map(u => ({
          id: u.id,
          name: `${u.firstName} ${u.lastName}`,
          type: 'client',
          role: u.role,
          hasToken: !!u.fcmToken,
          token: u.fcmToken || 'NULL'
        }))
      ];

      return {
        message: 'Statut FCM de tous les utilisateurs',
        stats,
        users: allUsers
      };
    } catch (error) {
      return {
        error: 'Erreur lors de la récupération du statut FCM',
        details: error.message
      };
    }
  }

  @Post('debug/set-fcm-token')
  async setFcmToken(@Body() body: { userId: string; fcmToken: string; userType: 'client' | 'prestataire' }) {
    try {
      console.log(`🔧 Définition du token FCM pour ${body.userType} ${body.userId}...`);
      
      if (body.userType === 'prestataire') {
        const prestataire = await this.prestataireRepository.findOne({ where: { id: body.userId } });
        if (!prestataire) {
          return { error: 'Prestataire non trouvé' };
        }
        
        prestataire.fcmToken = body.fcmToken;
        await this.prestataireRepository.save(prestataire);
        
        return {
          message: `Token FCM défini pour le prestataire ${prestataire.firstName} ${prestataire.lastName}`,
          prestataire: {
            id: prestataire.id,
            name: `${prestataire.firstName} ${prestataire.lastName}`,
            fcmToken: prestataire.fcmToken
          }
        };
      } else {
        const user = await this.userRepository.findOne({ where: { id: body.userId } });
        if (!user) {
          return { error: 'Utilisateur non trouvé' };
        }
        
        user.fcmToken = body.fcmToken;
        await this.userRepository.save(user);
        
        return {
          message: `Token FCM défini pour le client ${user.firstName} ${user.lastName}`,
          user: {
            id: user.id,
            name: `${user.firstName} ${user.lastName}`,
            fcmToken: user.fcmToken
          }
        };
      }
    } catch (error) {
      return {
        error: 'Erreur lors de la définition du token FCM',
        details: error.message
      };
    }
  }

  @Post('debug/simulate-offer-notification')
  async simulateOfferNotification(@Body() body: {
    clientId: string;
    prestataireId: string;
    prestataireName: string;
    serviceRequestId: string;
    serviceTitle: string;
    proposedPrice: number;
    message?: string;
  }) {
    try {
      console.log(`🧪 Simulation de notification d'offre...`);
      
      // Définir des tokens de test si nécessaire
      const client = await this.userRepository.findOne({ where: { id: body.clientId } });
      const prestataire = await this.prestataireRepository.findOne({ where: { id: body.prestataireId } });
      
      if (!client) {
        return { error: 'Client non trouvé' };
      }
      
      if (!prestataire) {
        return { error: 'Prestataire non trouvé' };
      }
      
      // Définir des tokens de test si ils sont NULL
      if (!client.fcmToken) {
        client.fcmToken = `test-client-token-${client.id.substring(0, 8)}`;
        await this.userRepository.save(client);
        console.log(`🔧 Token de test défini pour le client: ${client.fcmToken}`);
      }
      
      if (!prestataire.fcmToken) {
        prestataire.fcmToken = `test-prestataire-token-${prestataire.id.substring(0, 8)}`;
        await this.prestataireRepository.save(prestataire);
        console.log(`🔧 Token de test défini pour le prestataire: ${prestataire.fcmToken}`);
      }
      
      // Envoyer la notification
      await this.notificationsService.notifyClientOfOffer({
        clientId: body.clientId,
        prestataireId: body.prestataireId,
        prestataireName: body.prestataireName,
        serviceRequestId: body.serviceRequestId,
        serviceTitle: body.serviceTitle,
        proposedPrice: body.proposedPrice,
        message: body.message,
      });
      
      return {
        message: 'Notification d\'offre simulée avec succès',
        details: {
          client: {
            id: client.id,
            name: `${client.firstName} ${client.lastName}`,
            fcmToken: client.fcmToken
          },
          prestataire: {
            id: prestataire.id,
            name: `${prestataire.firstName} ${prestataire.lastName}`,
            fcmToken: prestataire.fcmToken
          }
        }
      };
    } catch (error) {
      return {
        error: 'Erreur lors de la simulation de notification',
        details: error.message
      };
    }
  }
}

