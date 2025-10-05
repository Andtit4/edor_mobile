import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/app_config.dart';
import 'firebase_notification_service.dart';

/// Service pour gérer les notifications liées aux demandes de service
class ServiceRequestNotificationService {
  static final ServiceRequestNotificationService _instance = ServiceRequestNotificationService._internal();
  factory ServiceRequestNotificationService() => _instance;
  ServiceRequestNotificationService._internal();

  final FirebaseNotificationService _notificationService = FirebaseNotificationService();

  /// Crée une nouvelle demande de service et notifie les prestataires
  Future<Map<String, dynamic>?> createServiceRequest({
    required String title,
    required String description,
    required String category,
    required String location,
    required String clientId,
    required String clientName,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      print('🔔 Création d\'une nouvelle demande de service...');
      print('   Catégorie: $category');
      print('   Client: $clientName');

      // Créer la demande de service sur le backend
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/service-requests'),
        headers: {
          'Content-Type': 'application/json',
          // TODO: Ajouter le token d'authentification
        },
        body: json.encode({
          'title': title,
          'description': description,
          'category': category,
          'location': location,
          'clientId': clientId,
          'additionalData': additionalData,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final serviceRequest = json.decode(response.body);
        final serviceRequestId = serviceRequest['id'];

        print('✅ Demande de service créée avec l\'ID: $serviceRequestId');

        // Notifier tous les prestataires de cette catégorie
        await _notifyPrestatairesForCategory(
          category: category,
          serviceRequestId: serviceRequestId,
          title: title,
          description: description,
          location: location,
          clientName: clientName,
        );

        return serviceRequest;
      } else {
        print('❌ Erreur lors de la création de la demande: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la création de la demande de service: $e');
      return null;
    }
  }

  /// Notifie tous les prestataires d'une catégorie spécifique
  Future<void> _notifyPrestatairesForCategory({
    required String category,
    required String serviceRequestId,
    required String title,
    required String description,
    required String location,
    required String clientName,
  }) async {
    try {
      print('🔔 Notification des prestataires pour la catégorie: $category');

      // Préparer les données de la notification
      final notificationData = {
        'type': 'new_service_request',
        'serviceRequestId': serviceRequestId,
        'category': category,
        'title': title,
        'description': description,
        'location': location,
        'clientName': clientName,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Envoyer la notification via le service Firebase
      await _notificationService.sendNotificationToCategory(
        category: category,
        title: 'Nouvelle demande de service - $category',
        body: '$clientName a publié une nouvelle demande: $title',
        data: notificationData,
      );

      print('✅ Notifications envoyées aux prestataires de la catégorie $category');
    } catch (e) {
      print('❌ Erreur lors de l\'envoi des notifications: $e');
    }
  }

  /// Notifie un client qu'un prestataire a accepté sa demande
  Future<void> notifyServiceAccepted({
    required String clientId,
    required String prestataireId,
    required String prestataireName,
    required String serviceRequestId,
    required String serviceTitle,
  }) async {
    try {
      print('🔔 Notification d\'acceptation de service...');

      final notificationData = {
        'type': 'service_accepted',
        'serviceRequestId': serviceRequestId,
        'prestataireId': prestataireId,
        'prestataireName': prestataireName,
        'serviceTitle': serviceTitle,
        'timestamp': DateTime.now().toIso8601String(),
      };

      await _notificationService.sendNotificationToUser(
        userId: clientId,
        title: 'Service accepté !',
        body: '$prestataireName a accepté votre demande: $serviceTitle',
        data: notificationData,
      );

      print('✅ Notification d\'acceptation envoyée au client');
    } catch (e) {
      print('❌ Erreur lors de l\'envoi de la notification d\'acceptation: $e');
    }
  }

  /// Notifie un client qu'un service est terminé
  Future<void> notifyServiceCompleted({
    required String clientId,
    required String prestataireId,
    required String prestataireName,
    required String serviceRequestId,
    required String serviceTitle,
  }) async {
    try {
      print('🔔 Notification de completion de service...');

      final notificationData = {
        'type': 'service_completed',
        'serviceRequestId': serviceRequestId,
        'prestataireId': prestataireId,
        'prestataireName': prestataireName,
        'serviceTitle': serviceTitle,
        'timestamp': DateTime.now().toIso8601String(),
      };

      await _notificationService.sendNotificationToUser(
        userId: clientId,
        title: 'Service terminé !',
        body: '$prestataireName a terminé votre service: $serviceTitle',
        data: notificationData,
      );

      print('✅ Notification de completion envoyée au client');
    } catch (e) {
      print('❌ Erreur lors de l\'envoi de la notification de completion: $e');
    }
  }

  /// Notifie un prestataire qu'un client a annulé sa demande
  Future<void> notifyServiceCancelled({
    required String prestataireId,
    required String clientId,
    required String clientName,
    required String serviceRequestId,
    required String serviceTitle,
  }) async {
    try {
      print('🔔 Notification d\'annulation de service...');

      final notificationData = {
        'type': 'service_cancelled',
        'serviceRequestId': serviceRequestId,
        'clientId': clientId,
        'clientName': clientName,
        'serviceTitle': serviceTitle,
        'timestamp': DateTime.now().toIso8601String(),
      };

      await _notificationService.sendNotificationToUser(
        userId: prestataireId,
        title: 'Service annulé',
        body: '$clientName a annulé la demande: $serviceTitle',
        data: notificationData,
      );

      print('✅ Notification d\'annulation envoyée au prestataire');
    } catch (e) {
      print('❌ Erreur lors de l\'envoi de la notification d\'annulation: $e');
    }
  }

  /// Notifie un client qu'un prestataire a commencé le service
  Future<void> notifyServiceStarted({
    required String clientId,
    required String prestataireId,
    required String prestataireName,
    required String serviceRequestId,
    required String serviceTitle,
  }) async {
    try {
      print('🔔 Notification de début de service...');

      final notificationData = {
        'type': 'service_started',
        'serviceRequestId': serviceRequestId,
        'prestataireId': prestataireId,
        'prestataireName': prestataireName,
        'serviceTitle': serviceTitle,
        'timestamp': DateTime.now().toIso8601String(),
      };

      await _notificationService.sendNotificationToUser(
        userId: clientId,
        title: 'Service en cours',
        body: '$prestataireName a commencé votre service: $serviceTitle',
        data: notificationData,
      );

      print('✅ Notification de début envoyée au client');
    } catch (e) {
      print('❌ Erreur lors de l\'envoi de la notification de début: $e');
    }
  }

  /// Récupère les prestataires d'une catégorie spécifique
  Future<List<Map<String, dynamic>>> getPrestatairesByCategory(String category) async {
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
  Future<void> sendTestNotification(String category) async {
    try {
      print('🔔 Envoi d\'une notification de test pour la catégorie: $category');

      final notificationData = {
        'type': 'test_notification',
        'category': category,
        'timestamp': DateTime.now().toIso8601String(),
      };

      await _notificationService.sendNotificationToCategory(
        category: category,
        title: 'Test de notification',
        body: 'Ceci est une notification de test pour la catégorie $category',
        data: notificationData,
      );

      print('✅ Notification de test envoyée');
    } catch (e) {
      print('❌ Erreur lors de l\'envoi de la notification de test: $e');
    }
  }
}




