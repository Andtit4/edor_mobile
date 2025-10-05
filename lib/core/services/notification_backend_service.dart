import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class NotificationBackendService {
  static String get _baseUrl => AppConfig.apiBaseUrl;

  /// Mettre à jour le token FCM d'un utilisateur
  static Future<bool> updateFcmToken({
    required String token,
    required String fcmToken,
  }) async {
    try {
      print('🔔 Mise à jour du token FCM...');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/notifications/update-token'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'fcmToken': fcmToken,
        }),
      );

      print('🔔 Réponse mise à jour token FCM: ${response.statusCode}');
      print('🔔 Corps de la réponse: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Token FCM mis à jour avec succès');
        return true;
      } else {
        print('❌ Erreur lors de la mise à jour du token FCM: ${response.statusCode}');
        print('❌ Message: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors de la mise à jour du token FCM: $e');
      return false;
    }
  }

  /// Envoyer une notification de test à une catégorie
  static Future<bool> sendTestNotification({
    required String token,
    required String category,
    required String title,
    required String body,
  }) async {
    try {
      print('🔔 Envoi de notification de test...');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/notifications/test-category'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'category': category,
          'title': title,
          'body': body,
        }),
      );

      print('🔔 Réponse notification de test: ${response.statusCode}');
      print('🔔 Corps de la réponse: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Notification de test envoyée avec succès');
        return true;
      } else {
        print('❌ Erreur lors de l\'envoi de la notification de test: ${response.statusCode}');
        print('❌ Message: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors de l\'envoi de la notification de test: $e');
      return false;
    }
  }
}
