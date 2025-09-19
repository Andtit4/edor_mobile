// lib/core/config/app_config.dart
import 'dart:io';

class AppConfig {
  static String _apiBaseUrl = 'http://localhost:3000';
  static String _appName = 'Edor';
  static String _appVersion = '1.0.0';
  static String _environment = 'development';

  // Getters
  static String get apiBaseUrl => _apiBaseUrl;
  static String get appName => _appName;
  static String get appVersion => _appVersion;
  static String get environment => _environment;

  // URLs des endpoints
  static String get authEndpoint => '$_apiBaseUrl/auth';
  static String get uploadEndpoint => '$_apiBaseUrl/upload';
  static String get prestatairesEndpoint => '$_apiBaseUrl/prestataires';
  static String get serviceRequestsEndpoint => '$_apiBaseUrl/service-requests';
  static String get negotiationsEndpoint => '$_apiBaseUrl/negotiations';
  static String get reviewsEndpoint => '$_apiBaseUrl/reviews';

  // Méthode pour charger la configuration depuis un fichier .env
  static Future<void> loadFromEnvFile() async {
    try {
      final envFile = File('.env');
      if (await envFile.exists()) {
        final content = await envFile.readAsString();
        final lines = content.split('\n');
        
        for (final line in lines) {
          if (line.trim().isEmpty || line.startsWith('#')) continue;
          
          final parts = line.split('=');
          if (parts.length == 2) {
            final key = parts[0].trim();
            final value = parts[1].trim();
            
            switch (key) {
              case 'API_BASE_URL':
                _apiBaseUrl = value;
                break;
              case 'APP_NAME':
                _appName = value;
                break;
              case 'APP_VERSION':
                _appVersion = value;
                break;
              case 'ENVIRONMENT':
                _environment = value;
                break;
            }
          }
        }
      }
    } catch (e) {
      print('Erreur lors du chargement du fichier .env: $e');
      // Utiliser les valeurs par défaut
    }
  }

  // Méthode pour définir manuellement l'URL de l'API
  static void setApiBaseUrl(String url) {
    _apiBaseUrl = url;
  }

  // Méthode pour obtenir l'URL complète d'un endpoint
  static String getEndpointUrl(String endpoint) {
    return '$_apiBaseUrl$endpoint';
  }
}
