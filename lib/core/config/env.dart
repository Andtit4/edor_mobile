// lib/core/config/env.dart
class Env {
  // Configuration de l'API
  static const String apiBaseUrl = 'http://192.168.100.34:3000';
  
  // Configuration de l'application
  static const String appName = 'Edor';
  static const String appVersion = '1.0.0';
  
  // Configuration de l'environnement
  static const String environment = 'development';
  
  // URLs des endpoints
  static const String authEndpoint = '$apiBaseUrl/auth';
  static const String uploadEndpoint = '$apiBaseUrl/upload';
  static const String prestatairesEndpoint = '$apiBaseUrl/prestataires';
  static const String serviceRequestsEndpoint = '$apiBaseUrl/service-requests';
  static const String negotiationsEndpoint = '$apiBaseUrl/negotiations';
  static const String reviewsEndpoint = '$apiBaseUrl/reviews';
}
