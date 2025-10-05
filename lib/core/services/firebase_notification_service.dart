import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/app_config.dart';
import 'notification_backend_service.dart';

/// Service de gestion des notifications Firebase
class FirebaseNotificationService {
  static final FirebaseNotificationService _instance = FirebaseNotificationService._internal();
  factory FirebaseNotificationService() => _instance;
  FirebaseNotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Initialise le service de notifications
  Future<void> initialize() async {
    try {
      print('🔔 Initialisation du service de notifications Firebase...');

      // Demander les permissions
      await _requestPermissions();

      // Initialiser les notifications locales
      await _initializeLocalNotifications();

      // Obtenir le token FCM
      await _getFCMToken();

      // Configurer les handlers de messages
      _setupMessageHandlers();

      print('✅ Service de notifications Firebase initialisé avec succès');
    } catch (e) {
      print('❌ Erreur lors de l\'initialisation des notifications: $e');
    }
  }

  /// Demande les permissions de notification
  Future<void> _requestPermissions() async {
    try {
      print('🔔 Demande des permissions de notification...');
      print('🔔 Plateforme: ${Platform.operatingSystem}');
      
      // Vérifier si on est sur une plateforme mobile
      if (!Platform.isAndroid && !Platform.isIOS) {
        print('❌ Permissions de notification non supportées sur cette plateforme');
        return;
      }
      
      // Demander les permissions pour iOS
      if (Platform.isIOS) {
        final settings = await _firebaseMessaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

        print('🔔 Permissions iOS: ${settings.authorizationStatus}');
      }

      // Demander les permissions pour Android
      if (Platform.isAndroid) {
        print('🔔 Permissions Android gérées automatiquement');
        final androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
        final iosSettings = DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
        final initSettings = InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
        );

        await _localNotifications.initialize(
          initSettings,
          onDidReceiveNotificationResponse: _onNotificationTapped,
        );
      }
      
      // Vérifier le statut final
      final finalSettings = await _firebaseMessaging.getNotificationSettings();
      print('🔔 Statut final des permissions: ${finalSettings.authorizationStatus}');
      
      if (finalSettings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ Permissions accordées');
      } else {
        print('❌ Permissions refusées: ${finalSettings.authorizationStatus}');
      }
    } catch (e) {
      print('❌ Erreur lors de la demande de permissions: $e');
      
      // Si c'est une erreur de plateforme, ignorer
      if (e.toString().contains('Unsupported operation') || e.toString().contains('Platform._operatingSystem')) {
        print('⚠️ Erreur de plateforme détectée - probablement en mode web');
        return;
      }
    }
  }

  /// Initialise les notifications locales
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Obtient le token FCM
  Future<void> _getFCMToken() async {
    try {
      print('🔔 Tentative d\'obtention du token FCM...');
      print('🔔 Firebase Messaging instance: ${_firebaseMessaging != null}');
      print('🔔 Plateforme: ${Platform.operatingSystem}');
      
      // Vérifier si on est sur une plateforme mobile
      if (!Platform.isAndroid && !Platform.isIOS) {
        print('❌ Firebase Messaging n\'est pas supporté sur cette plateforme');
        print('❌ Plateforme détectée: ${Platform.operatingSystem}');
        return;
      }
      
      // Vérifier les permissions d'abord
      final settings = await _firebaseMessaging.getNotificationSettings();
      print('🔔 Permissions de notification: ${settings.authorizationStatus}');
      
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print('❌ Permissions de notification refusées par l\'utilisateur');
        print('❌ Demander les permissions...');
        await _requestPermissions();
      }
      
      _fcmToken = await _firebaseMessaging.getToken();
      
      print('🔔 Résultat getToken(): ${_fcmToken ?? "NULL"}');
      
      if (_fcmToken != null) {
        print('🔔 Token FCM obtenu avec succès: ${_fcmToken?.substring(0, 20)}...');
        
        // Envoyer le token au backend pour l'associer à l'utilisateur (sans auth token)
        await _sendTokenToBackend(_fcmToken);
      } else {
        print('❌ Token FCM null - Firebase pourrait ne pas être correctement configuré');
        print('❌ Vérifiez que Firebase est initialisé');
        print('❌ Vérifiez les permissions de notification');
        print('❌ Vérifiez la configuration firebase_options.dart');
        
        // Essayer de forcer la génération du token
        print('🔔 Tentative de génération forcée du token...');
        await Future.delayed(const Duration(seconds: 2));
        _fcmToken = await _firebaseMessaging.getToken();
        print('🔔 Token après délai: ${_fcmToken ?? "NULL"}');
      }
    } catch (e) {
      print('❌ Erreur lors de l\'obtention du token FCM: $e');
      print('❌ Stack trace: ${e.toString()}');
      
      // Si c'est une erreur de service worker (web), ignorer
      if (e.toString().contains('service-worker') || e.toString().contains('localhost')) {
        print('⚠️ Erreur de service worker détectée - probablement en mode web');
        print('⚠️ Firebase Messaging ne fonctionne que sur mobile');
        return;
      }
      
      print('❌ Vérifiez la configuration Firebase et les permissions');
    }
  }

  /// Envoie le token FCM au backend
  Future<void> _sendTokenToBackend(String? token) async {
    if (token == null) return;

    try {
      // TODO: Récupérer le token d'authentification de l'utilisateur
      // final authToken = await getAuthToken();
      
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/notifications/register-token'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'fcmToken': token,
          'platform': Platform.isIOS ? 'ios' : 'android',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Token FCM enregistré avec succès sur le backend');
      } else {
        print('❌ Erreur lors de l\'enregistrement du token: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur lors de l\'envoi du token au backend: $e');
    }
  }

  /// Configure les handlers de messages
  void _setupMessageHandlers() {
    // Message reçu en foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Message reçu en background (quand l'app est fermée)
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Notification tapée
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }

  /// Gère les messages reçus en foreground
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('🔔 Message reçu en foreground: ${message.notification?.title}');
    
    // Afficher une notification locale
    await _showLocalNotification(message);
  }

  /// Gère les messages reçus en background
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('🔔 Message reçu en background: ${message.notification?.title}');
    
    // Traiter le message en background
    await _processBackgroundMessage(message);
  }

  /// Traite un message en background
  static Future<void> _processBackgroundMessage(RemoteMessage message) async {
    try {
      // Extraire les données du message
      final data = message.data;
      final notificationType = data['type'];
      final serviceRequestId = data['serviceRequestId'];
      final category = data['category'];

      print('🔔 Traitement du message background:');
      print('   Type: $notificationType');
      print('   Service Request ID: $serviceRequestId');
      print('   Catégorie: $category');

      // TODO: Traiter selon le type de notification
      switch (notificationType) {
        case 'new_service_request':
          await _handleNewServiceRequest(data);
          break;
        case 'service_accepted':
          await _handleServiceAccepted(data);
          break;
        case 'service_completed':
          await _handleServiceCompleted(data);
          break;
        default:
          print('🔔 Type de notification non reconnu: $notificationType');
      }
    } catch (e) {
      print('❌ Erreur lors du traitement du message background: $e');
    }
  }

  /// Gère une nouvelle demande de service
  static Future<void> _handleNewServiceRequest(Map<String, dynamic> data) async {
    print('🔔 Nouvelle demande de service reçue');
    // TODO: Mettre à jour la base de données locale ou déclencher une action
  }

  /// Gère l'acceptation d'un service
  static Future<void> _handleServiceAccepted(Map<String, dynamic> data) async {
    print('🔔 Service accepté');
    // TODO: Mettre à jour la base de données locale
  }

  /// Gère la completion d'un service
  static Future<void> _handleServiceCompleted(Map<String, dynamic> data) async {
    print('🔔 Service terminé');
    // TODO: Mettre à jour la base de données locale
  }

  /// Affiche une notification locale
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'service_requests',
      'Demandes de Service',
      channelDescription: 'Notifications pour les nouvelles demandes de service',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      details,
      payload: json.encode(message.data),
    );
  }

  /// Gère le tap sur une notification
  void _onNotificationTapped(NotificationResponse response) {
    print('🔔 Notification tapée: ${response.payload}');
    
    if (response.payload != null) {
      try {
        final data = json.decode(response.payload!);
        _handleNotificationData(data);
      } catch (e) {
        print('❌ Erreur lors du parsing du payload: $e');
      }
    }
  }

  /// Gère le tap sur une notification (Firebase)
  void _handleNotificationTap(RemoteMessage message) {
    print('🔔 Notification Firebase tapée: ${message.data}');
    _handleNotificationData(message.data);
  }

  /// Traite les données d'une notification
  void _handleNotificationData(Map<String, dynamic> data) {
    final notificationType = data['type'];
    final serviceRequestId = data['serviceRequestId'];

    // TODO: Naviguer vers la page appropriée selon le type de notification
    switch (notificationType) {
      case 'new_service_request':
        // Naviguer vers la page de détails de la demande
        print('🔔 Navigation vers la demande: $serviceRequestId');
        break;
      case 'service_accepted':
        // Naviguer vers la page de conversation
        print('🔔 Navigation vers la conversation');
        break;
      default:
        print('🔔 Type de notification non géré: $notificationType');
    }
  }

  /// Envoie une notification à tous les prestataires d'une catégorie
  Future<void> sendNotificationToCategory({
    required String category,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    try {
      print('🔔 Envoi de notification pour la catégorie: $category');
      
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/notifications/send-to-category'),
        headers: {
          'Content-Type': 'application/json',
          // TODO: Ajouter le token d'authentification
        },
        body: json.encode({
          'category': category,
          'title': title,
          'body': body,
          'data': data,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Notification envoyée avec succès à la catégorie $category');
      } else {
        print('❌ Erreur lors de l\'envoi de la notification: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur lors de l\'envoi de la notification: $e');
    }
  }

  /// Envoie une notification à un utilisateur spécifique
  Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    try {
      print('🔔 Envoi de notification à l\'utilisateur: $userId');
      
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/notifications/send-to-user'),
        headers: {
          'Content-Type': 'application/json',
          // TODO: Ajouter le token d'authentification
        },
        body: json.encode({
          'userId': userId,
          'title': title,
          'body': body,
          'data': data,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Notification envoyée avec succès à l\'utilisateur $userId');
      } else {
        print('❌ Erreur lors de l\'envoi de la notification: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur lors de l\'envoi de la notification: $e');
    }
  }

  /// Configure les topics FCM pour recevoir les notifications par catégorie
  Future<void> subscribeToCategory(String category) async {
    try {
      await _firebaseMessaging.subscribeToTopic('category_$category');
      print('✅ Abonné au topic: category_$category');
    } catch (e) {
      print('❌ Erreur lors de l\'abonnement au topic: $e');
    }
  }

  /// Se désabonne d'un topic FCM
  Future<void> unsubscribeFromCategory(String category) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic('category_$category');
      print('✅ Désabonné du topic: category_$category');
    } catch (e) {
      print('❌ Erreur lors du désabonnement du topic: $e');
    }
  }

  /// Synchronise le token FCM avec le backend
  Future<void> syncTokenWithBackend(String authToken) async {
    print('🔔 === DÉBUT SYNCHRONISATION FCM ===');
    print('🔔 Auth Token: ${authToken.substring(0, 20)}...');
    print('🔔 Token FCM actuel: ${_fcmToken?.substring(0, 20) ?? "NULL"}...');
    
    // Toujours essayer de récupérer le token FCM (au cas où il ne serait pas encore généré)
    print('🔔 Tentative de génération du token FCM...');
    await _getFCMToken();
    
    print('🔔 Token FCM après génération: ${_fcmToken?.substring(0, 20) ?? "NULL"}...');
    
    if (_fcmToken != null) {
      print('🔔 Token FCM disponible: ${_fcmToken?.substring(0, 20)}...');
      
      final success = await NotificationBackendService.updateFcmToken(
        token: authToken,
        fcmToken: _fcmToken!,
      );
      
      if (success) {
        print('✅ Token FCM synchronisé avec le backend avec succès');
      } else {
        print('❌ Échec de la synchronisation du token FCM');
      }
    } else {
      print('❌ Aucun token FCM disponible après tentative de génération');
      print('❌ Vérifiez que Firebase est correctement configuré');
      print('❌ Vérifiez les permissions de notification');
      print('❌ Vérifiez la configuration Firebase dans firebase_options.dart');
      
      // Tentative de réinitialisation du service Firebase
      print('🔔 Tentative de réinitialisation du service Firebase...');
      await _forceReinitialize();
      
      // Nouvelle tentative de génération du token
      print('🔔 Nouvelle tentative de génération du token FCM...');
      await _getFCMToken();
      
      if (_fcmToken != null) {
        print('✅ Token FCM généré après réinitialisation: ${_fcmToken?.substring(0, 20)}...');
        
        final success = await NotificationBackendService.updateFcmToken(
          token: authToken,
          fcmToken: _fcmToken!,
        );
        
        if (success) {
          print('✅ Token FCM synchronisé avec le backend après réinitialisation');
        } else {
          print('❌ Échec de la synchronisation du token FCM après réinitialisation');
        }
      } else {
        print('❌ Impossible de générer le token FCM même après réinitialisation');
      }
    }
    
    print('🔔 === FIN SYNCHRONISATION FCM ===');
  }

  /// Force la réinitialisation du service Firebase
  Future<void> _forceReinitialize() async {
    try {
      print('🔔 Réinitialisation du service Firebase...');
      
      // Redemander les permissions
      await _requestPermissions();
      
      // Réinitialiser les notifications locales
      await _initializeLocalNotifications();
      
      // Configurer les handlers de messages
      _setupMessageHandlers();
      
      print('✅ Service Firebase réinitialisé');
    } catch (e) {
      print('❌ Erreur lors de la réinitialisation du service Firebase: $e');
    }
  }

  /// Nettoie les ressources
  void dispose() {
    // TODO: Nettoyer les listeners si nécessaire
  }
}

/// Point d'entrée pour les messages en background
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FirebaseNotificationService._handleBackgroundMessage(message);
}
