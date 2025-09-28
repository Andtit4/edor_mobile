import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../../domain/entities/user.dart';

class SimpleGoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Authentification Google simple (sans Firebase)
  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      print('🔵 === DÉBUT AUTHENTIFICATION GOOGLE SIMPLE5 ===');
      print('🔵 Configuration GoogleSignIn: ${_googleSignIn.toString()}');
      
      // Déclencher le flux d'authentification Google
      print('🔵 Appel de _googleSignIn.signIn()...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      print('\n\n🔵 GoogleUser: $googleUser');
      
      if (googleUser == null) {
        print('🔴 Authentification Google annulée par l\'utilisateur');
        return null;
      }

      print('✅ Compte Google sélectionné:');
      print('   📧 Email: ${googleUser.email}');
      print('   🆔 ID: ${googleUser.id}');
      print('   👤 Nom: ${googleUser.displayName}');
      print('   🖼️ Photo: ${googleUser.photoUrl}');

      // Obtenir les détails d'authentification du compte Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken == null) {
        print('🔴 AccessToken manquant');
        return null;
      }

      print('✅ Tokens Google obtenus:');
      print('   🔑 AccessToken: ${googleAuth.accessToken!.substring(0, 20)}...');
      print('   🆔 IDToken: ${googleAuth.idToken != null ? "Oui" : "Non"}');

      // Préparer les données utilisateur pour le backend
      final userData = {
        'provider': 'google',
        'providerId': googleUser.id, // Utiliser l'ID Google
        'email': googleUser.email,
        'firstName': _extractFirstName(googleUser.displayName),
        'lastName': _extractLastName(googleUser.displayName),
        'profileImage': googleUser.photoUrl,
        'firebaseUid': googleUser.id, // Utiliser l'ID Google comme Firebase UID
        'emailVerified': true, // Google vérifie automatiquement l'email
        'accessToken': googleAuth.accessToken,
        'idToken': googleAuth.idToken,
      };
      
      print('✅ Données utilisateur préparées:');
      print('   📧 Email: ${userData['email']}');
      print('   👤 Prénom: ${userData['firstName']}');
      print('   👤 Nom: ${userData['lastName']}');
      print('   🔥 Google ID: ${userData['firebaseUid']}');
      print('🔵 === FIN AUTHENTIFICATION GOOGLE SIMPLE ===');
      
      return userData;
    } catch (e) {
      print('🔴 Erreur lors de l\'authentification Google: $e');
      print('🔴 Type d\'erreur: ${e.runtimeType}');
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

  /// Synchroniser les données Google avec la base de données
  static Future<Map<String, dynamic>?> syncWithBackend(
    Map<String, dynamic> googleData,
    UserRole role,
  ) async {
    try {
      print('🔵 === SYNCHRONISATION AVEC BACKEND ===');
      print('🔵 Rôle sélectionné: $role');
      print('🔵 Email: ${googleData['email']}');
      print('🔵 Google ID: ${googleData['firebaseUid']}');
      
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/auth/social'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          ...googleData,
          'role': role.name,
        }),
      );

      print('🔵 Réponse backend: ${response.statusCode}');
      print('🔵 Corps de la réponse: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('✅ Synchronisation backend réussie');
        print('🔵 Structure de la réponse:');
        print('   - Type: ${responseData.runtimeType}');
        print('   - Clés: ${responseData.keys.toList()}');
        if (responseData['user'] != null) {
          print('   - User: ${responseData['user']}');
        }
        if (responseData['token'] != null) {
          print('   - Token: ${responseData['token'].toString().substring(0, 20)}...');
        }
        print('🔵 === FIN SYNCHRONISATION BACKEND ===');
        return responseData;
      } else {
        print('🔴 Erreur backend: ${response.statusCode}');
        print('🔴 Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('🔴 Erreur lors de la synchronisation backend: $e');
      return null;
    }
  }

  /// Obtenir l'utilisateur Google actuel
  static GoogleSignInAccount? getCurrentUser() {
    return _googleSignIn.currentUser;
  }

  /// Vérifier si l'utilisateur est connecté
  static bool isSignedIn() {
    return _googleSignIn.currentUser != null;
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

  /// Obtenir le token d'ID Google
  static Future<String?> getIdToken() async {
    try {
      final user = _googleSignIn.currentUser;
      if (user != null) {
        final auth = await user.authentication;
        return auth.idToken;
      }
      return null;
    } catch (e) {
      print('🔴 Erreur lors de la récupération du token: $e');
      return null;
    }
  }
}
