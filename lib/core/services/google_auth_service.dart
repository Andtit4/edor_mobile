import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../../domain/entities/user.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: kIsWeb 
      ? '582789633856-biiii8gm9qm0duhi61js85su1isrmdkm.apps.googleusercontent.com'
      : null, // Sur mobile, utilise google-services.json
  );

  /// Authentification Google simple et robuste
  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      print('🔵 === DÉBUT AUTHENTIFICATION GOOGLE ===');
      
      // Déconnecter d'abord pour forcer une nouvelle connexion
      await _googleSignIn.signOut();
      print('🔵 Déconnexion précédente effectuée');
      
      // Lancer l'authentification
      print('🔵 Lancement de l\'authentification Google...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('🔴 Authentification annulée par l\'utilisateur');
        return null;
      }

      print('✅ Utilisateur Google connecté:');
      print('   📧 Email: ${googleUser.email}');
      print('   🆔 ID: ${googleUser.id}');
      print('   👤 Nom: ${googleUser.displayName}');
      print('   🖼️ Photo: ${googleUser.photoUrl}');
      
      // Récupérer les tokens d'authentification
      print('🔵 Récupération des tokens...');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      if (googleAuth.accessToken == null) {
        print('🔴 AccessToken manquant');
        return null;
      }

      print('✅ Tokens obtenus:');
      print('   🔑 AccessToken: ${googleAuth.accessToken!.substring(0, 20)}...');
      print('   🆔 IDToken: ${googleAuth.idToken != null ? "Oui" : "Non"}');

      // Préparer les données utilisateur
      final userData = {
        'provider': 'google',
        'providerId': googleUser.id,
        'email': googleUser.email,
        'firstName': _extractFirstName(googleUser.displayName),
        'lastName': _extractLastName(googleUser.displayName),
        'profileImage': googleUser.photoUrl,
        'accessToken': googleAuth.accessToken,
        'idToken': googleAuth.idToken,
      };
      
      print('✅ Données utilisateur préparées:');
      print('   📧 Email: ${userData['email']}');
      print('   👤 Prénom: ${userData['firstName']}');
      print('   👤 Nom: ${userData['lastName']}');
      print('🔵 === FIN AUTHENTIFICATION GOOGLE ===');
      
      return userData;
    } catch (e) {
      print('🔴 Erreur lors de l\'authentification Google: $e');
      print('🔴 Type d\'erreur: ${e.runtimeType}');
      if (e is Exception) {
        print('🔴 Message: ${e.toString()}');
      }
      return null;
    }
  }

  /// Extraire le prénom du nom complet
  static String _extractFirstName(String? displayName) {
    if (displayName == null || displayName.isEmpty) return '';
    final parts = displayName.trim().split(' ');
    return parts.first;
  }

  /// Extraire le nom de famille du nom complet
  static String _extractLastName(String? displayName) {
    if (displayName == null || displayName.isEmpty) return '';
    final parts = displayName.trim().split(' ');
    if (parts.length <= 1) return '';
    return parts.skip(1).join(' ');
  }

  /// Authentifier avec le backend
  static Future<Map<String, dynamic>?> authenticateWithBackend(
    Map<String, dynamic> socialData,
    UserRole role,
  ) async {
    try {
      print('🔵 === AUTHENTIFICATION BACKEND ===');
      print('🔵 Rôle sélectionné: $role');
      print('🔵 Email: ${socialData['email']}');
      
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/auth/social'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          ...socialData,
          'role': role.name,
        }),
      );

      print('🔵 Réponse backend: ${response.statusCode}');
      print('🔵 Corps de la réponse: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('✅ Authentification backend réussie');
        print('🔵 === FIN AUTHENTIFICATION BACKEND ===');
        return responseData;
      } else {
        print('🔴 Erreur backend: ${response.statusCode}');
        print('🔴 Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('🔴 Erreur lors de l\'authentification backend: $e');
      return null;
    }
  }

  /// Déconnexion
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      print('✅ Déconnexion Google effectuée');
    } catch (e) {
      print('🔴 Erreur lors de la déconnexion: $e');
    }
  }
}



