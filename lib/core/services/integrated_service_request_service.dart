import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/app_config.dart';
import 'service_request_notification_service.dart';
import '../../domain/entities/user.dart';

/// Service intégré pour gérer les demandes de service avec notifications
class IntegratedServiceRequestService {
  static final IntegratedServiceRequestService _instance = IntegratedServiceRequestService._internal();
  factory IntegratedServiceRequestService() => _instance;
  IntegratedServiceRequestService._internal();

  final ServiceRequestNotificationService _notificationService = ServiceRequestNotificationService();

  /// Crée une nouvelle demande de service et notifie automatiquement les prestataires
  Future<Map<String, dynamic>?> createServiceRequestWithNotifications({
    required String title,
    required String description,
    required String category,
    required String location,
    required User client,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      print('🔔 Création d\'une demande de service avec notifications...');
      print('   Client: ${client.firstName} ${client.lastName}');
      print('   Catégorie: $category');
      print('   Titre: $title');

      // Créer la demande de service
      final serviceRequest = await _notificationService.createServiceRequest(
        title: title,
        description: description,
        category: category,
        location: location,
        clientId: client.id,
        clientName: '${client.firstName} ${client.lastName}',
        additionalData: additionalData,
      );

      if (serviceRequest != null) {
        print('✅ Demande de service créée avec succès');
        print('   ID: ${serviceRequest['id']}');
        
        // Les notifications sont automatiquement envoyées par le service
        return serviceRequest;
      } else {
        print('❌ Échec de la création de la demande de service');
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la création de la demande avec notifications: $e');
      return null;
    }
  }

  /// Accepte une demande de service et notifie le client
  Future<bool> acceptServiceRequestWithNotification({
    required String serviceRequestId,
    required User prestataire,
    required String clientId,
    required String serviceTitle,
  }) async {
    try {
      print('🔔 Acceptation d\'une demande de service...');
      print('   Prestataire: ${prestataire.firstName} ${prestataire.lastName}');
      print('   Service: $serviceTitle');

      // Accepter la demande sur le backend
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/service-requests/$serviceRequestId/accept'),
        headers: {
          'Content-Type': 'application/json',
          // TODO: Ajouter le token d'authentification
        },
        body: json.encode({
          'prestataireId': prestataire.id,
          'acceptedAt': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Demande acceptée avec succès');

        // Notifier le client
        await _notificationService.notifyServiceAccepted(
          clientId: clientId,
          prestataireId: prestataire.id,
          prestataireName: '${prestataire.firstName} ${prestataire.lastName}',
          serviceRequestId: serviceRequestId,
          serviceTitle: serviceTitle,
        );

        return true;
      } else {
        print('❌ Erreur lors de l\'acceptation: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors de l\'acceptation avec notification: $e');
      return false;
    }
  }

  /// Marque un service comme terminé et notifie le client
  Future<bool> completeServiceWithNotification({
    required String serviceRequestId,
    required User prestataire,
    required String clientId,
    required String serviceTitle,
  }) async {
    try {
      print('🔔 Completion d\'un service...');
      print('   Prestataire: ${prestataire.firstName} ${prestataire.lastName}');
      print('   Service: $serviceTitle');

      // Marquer comme terminé sur le backend
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/service-requests/$serviceRequestId/complete'),
        headers: {
          'Content-Type': 'application/json',
          // TODO: Ajouter le token d'authentification
        },
        body: json.encode({
          'prestataireId': prestataire.id,
          'completedAt': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Service marqué comme terminé');

        // Notifier le client
        await _notificationService.notifyServiceCompleted(
          clientId: clientId,
          prestataireId: prestataire.id,
          prestataireName: '${prestataire.firstName} ${prestataire.lastName}',
          serviceRequestId: serviceRequestId,
          serviceTitle: serviceTitle,
        );

        return true;
      } else {
        print('❌ Erreur lors de la completion: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors de la completion avec notification: $e');
      return false;
    }
  }

  /// Annule un service et notifie les parties concernées
  Future<bool> cancelServiceWithNotification({
    required String serviceRequestId,
    required User cancellingUser,
    required String otherUserId,
    required String otherUserName,
    required String serviceTitle,
    required UserRole cancellingUserRole,
  }) async {
    try {
      print('🔔 Annulation d\'un service...');
      print('   Annulé par: ${cancellingUser.firstName} ${cancellingUser.lastName}');
      print('   Service: $serviceTitle');

      // Annuler sur le backend
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/service-requests/$serviceRequestId/cancel'),
        headers: {
          'Content-Type': 'application/json',
          // TODO: Ajouter le token d'authentification
        },
        body: json.encode({
          'cancelledBy': cancellingUser.id,
          'cancelledAt': DateTime.now().toIso8601String(),
          'reason': 'Annulé par l\'utilisateur',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Service annulé avec succès');

        // Notifier l'autre partie
        if (cancellingUserRole == UserRole.client) {
          // Le client a annulé, notifier le prestataire
          await _notificationService.notifyServiceCancelled(
            prestataireId: otherUserId,
            clientId: cancellingUser.id,
            clientName: '${cancellingUser.firstName} ${cancellingUser.lastName}',
            serviceRequestId: serviceRequestId,
            serviceTitle: serviceTitle,
          );
        } else {
          // Le prestataire a annulé, notifier le client
          await _notificationService.notifyServiceCancelled(
            prestataireId: cancellingUser.id,
            clientId: otherUserId,
            clientName: otherUserName,
            serviceRequestId: serviceRequestId,
            serviceTitle: serviceTitle,
          );
        }

        return true;
      } else {
        print('❌ Erreur lors de l\'annulation: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors de l\'annulation avec notification: $e');
      return false;
    }
  }

  /// Démarre un service et notifie le client
  Future<bool> startServiceWithNotification({
    required String serviceRequestId,
    required User prestataire,
    required String clientId,
    required String serviceTitle,
  }) async {
    try {
      print('🔔 Démarrage d\'un service...');
      print('   Prestataire: ${prestataire.firstName} ${prestataire.lastName}');
      print('   Service: $serviceTitle');

      // Marquer comme démarré sur le backend
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/service-requests/$serviceRequestId/start'),
        headers: {
          'Content-Type': 'application/json',
          // TODO: Ajouter le token d'authentification
        },
        body: json.encode({
          'prestataireId': prestataire.id,
          'startedAt': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Service marqué comme démarré');

        // Notifier le client
        await _notificationService.notifyServiceStarted(
          clientId: clientId,
          prestataireId: prestataire.id,
          prestataireName: '${prestataire.firstName} ${prestataire.lastName}',
          serviceRequestId: serviceRequestId,
          serviceTitle: serviceTitle,
        );

        return true;
      } else {
        print('❌ Erreur lors du démarrage: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors du démarrage avec notification: $e');
      return false;
    }
  }

  /// Récupère les prestataires disponibles pour une catégorie
  Future<List<Map<String, dynamic>>> getAvailablePrestataires(String category) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/prestataires/category/$category'),
        headers: {
          'Content-Type': 'application/json',
          // TODO: Ajouter le token d'authentification
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['prestataires'] ?? []);
      } else {
        print('❌ Erreur lors de la récupération des prestataires: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des prestataires: $e');
      return [];
    }
  }

  /// Envoie une notification de test à une catégorie
  Future<void> sendTestNotificationToCategory(String category) async {
    await _notificationService.sendTestNotification(category);
  }
}

/// Provider pour le service intégré
final integratedServiceRequestServiceProvider = Provider<IntegratedServiceRequestService>((ref) {
  return IntegratedServiceRequestService();
});




