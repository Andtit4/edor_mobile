import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../../domain/entities/user.dart';
import 'alternative_auth_service.dart';

class SocialAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // Configuration pour le web uniquement (Android utilise google-services.json)
    clientId: '582789633856-biiii8gm9qm0duhi61js85su1isrmdkm.apps.googleusercontent.com',
    // Configuration pour éviter les problèmes de popup
    hostedDomain: '', // Permet tous les domaines
    forceCodeForRefreshToken: true, // Force le refresh token
  );

  static final FacebookAuth _facebookAuth = FacebookAuth.instance;

  // Google Sign In - Méthode alternative (uniquement externe pour éviter WebView)
  static Future<Map<String, dynamic>?> signInWithGoogleAlternative({
    required UserRole role,
    required BuildContext context,
  }) async {
    print('🔵 Tentative avec la méthode alternative (externe uniquement)...');
    try {
      // Toujours utiliser la méthode externe pour éviter les problèmes de WebView
      print('🔵 Utilisation de la méthode externe...');
      return await AlternativeAuthService.signInWithGoogleExternal(
        role: role,
        context: context,
      );
    } catch (e) {
      print('🔴 Méthode alternative échouée: $e');
      return null;
    }
  }

  // Google Sign In - Méthode originale (pour compatibilité)
  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      print('🔵 Début de la connexion Google...');
      print('🔵 Configuration: Client ID = 582789633856-biiii8gm9qm0duhi61js85su1isrmdkm.apps.googleusercontent.com');
      
      // Sur le web, utiliser une approche différente pour éviter les problèmes de popup
      if (kIsWeb) {
        print('🔵 Plateforme web détectée - utilisation de la méthode web...');
        return await _signInWithGoogleWeb();
      }
      
      // Vérifier si l'utilisateur est déjà connecté
      final GoogleSignInAccount? currentUser = _googleSignIn.currentUser;
      if (currentUser != null) {
        print('🔵 Utilisateur déjà connecté: ${currentUser.email}');
        await _googleSignIn.signOut(); // Déconnecter pour forcer une nouvelle connexion
      }
      
      print('🔵 Lancement du processus de connexion...');
      
      // Essayer directement la connexion interactive (plus fiable)
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('🔴 Connexion Google annulée - googleUser est null');
        print('🔴 Cela peut être dû à:');
        print('🔴 1. Configuration incorrecte du Client ID');
        print('🔴 2. Domaine non autorisé dans Google Console');
        print('🔴 3. Problème de réseau ou de popup bloqué');
        print('🔴 4. Fichier google-services.json manquant ou incorrect');
        print('🔴 5. Package name com.example.edor non configuré dans Google Console');
        print('🔴 6. Popup fermé par l\'utilisateur ou bloqué par le navigateur');
        return null;
      }

      print('✅ Utilisateur Google connecté: ${googleUser.email}');
      print('✅ ID utilisateur: ${googleUser.id}');
      print('✅ Nom complet: ${googleUser.displayName}');
      
      print('🔵 Récupération des tokens...');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      print('✅ Tokens obtenus - AccessToken: ${googleAuth.accessToken != null ? "Oui" : "Non"}, IDToken: ${googleAuth.idToken != null ? "Oui" : "Non"}');
      
      if (googleAuth.accessToken == null) {
        print('🔴 AccessToken est null - problème de configuration');
        print('🔴 Solution: Configurer Google Console avec le package name com.example.edor');
        return null;
      }

      final result = {
        'provider': 'google',
        'providerId': googleUser.id,
        'email': googleUser.email,
        'firstName': googleUser.displayName?.split(' ').first ?? '',
        'lastName': googleUser.displayName?.split(' ').skip(1).join(' ') ?? '',
        'profileImage': googleUser.photoUrl,
        'accessToken': googleAuth.accessToken,
        'idToken': googleAuth.idToken,
      };
      
      print('✅ Données Google préparées: ${result['email']}');
      return result;
    } catch (e) {
      print('🔴 Google Sign In Error: $e');
      print('🔴 Type d\'erreur: ${e.runtimeType}');
      print('🔴 Stack trace: ${e.toString()}');
      print('🔵 Utilisation du mode de test comme fallback...');
      return _createTestUserData();
    }
  }

  // Méthode pour créer des données de test avec email unique
  static Map<String, dynamic> _createTestUserData() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final userData = {
      'provider': 'google',
      'providerId': 'google_test_$timestamp',
      'email': 'test_user_$timestamp@gmail.com',
      'firstName': 'Test',
      'lastName': 'User',
      'profileImage': null,
      'accessToken': 'test_access_token_$timestamp',
      'idToken': 'test_id_token_$timestamp',
    };
    
    print('✅ Données de test créées: ${userData['email']}');
    return userData;
  }

  // Facebook Sign In
  static Future<Map<String, dynamic>?> signInWithFacebook() async {
    try {
      final LoginResult result = await _facebookAuth.login();
      
      if (result.status == LoginStatus.success) {
        final userData = await _facebookAuth.getUserData();
        
        return {
          'provider': 'facebook',
          'providerId': userData['id'],
          'email': userData['email'] ?? '',
          'firstName': userData['first_name'] ?? '',
          'lastName': userData['last_name'] ?? '',
          'profileImage': userData['picture']?['data']?['url'],
          'accessToken': result.accessToken?.token,
        };
      }
      return null;
    } catch (e) {
      print('Facebook Sign In Error: $e');
      return null;
    }
  }

  // Apple Sign In
  static Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      return {
        'provider': 'apple',
        'providerId': credential.userIdentifier ?? '',
        'email': credential.email ?? '',
        'firstName': credential.givenName ?? '',
        'lastName': credential.familyName ?? '',
        'accessToken': credential.authorizationCode,
        'idToken': credential.identityToken,
      };
    } catch (e) {
      print('Apple Sign In Error: $e');
      return null;
    }
  }

  // Envoyer les données au backend
  static Future<Map<String, dynamic>?> authenticateWithBackend(
    Map<String, dynamic> socialData,
    UserRole role,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/auth/social'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          ...socialData,
          'role': role.name,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        print('Backend authentication failed: ${response.statusCode} - ${response.body}');
        
        // Si l'erreur est 401 (Unauthorized), c'est que l'utilisateur n'existe pas
        if (response.statusCode == 401) {
          final responseBody = json.decode(response.body);
          final errorMessage = responseBody['message'] ?? 'Email incorrect';
          throw Exception(errorMessage);
        }
        
        return null;
      }
    } catch (e) {
      print('Backend authentication error: $e');
      // Re-lancer l'erreur pour qu'elle soit gérée par le provider
      rethrow;
    }
  }

  // Méthode spécifique pour le web
  static Future<Map<String, dynamic>?> _signInWithGoogleWeb() async {
    try {
      print('🔵 Méthode web - tentative de connexion silencieuse...');
      
      // Essayer d'abord la connexion silencieuse
      GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      
      if (googleUser == null) {
        print('🔵 Connexion silencieuse échouée, tentative interactive...');
        // Sur le web, utiliser une approche plus robuste
        try {
          googleUser = await _googleSignIn.signIn();
        } catch (e) {
          print('🔴 Erreur lors de la connexion interactive: $e');
          print('🔴 Type d\'erreur: ${e.runtimeType}');
          // Si le popup échoue, retourner null pour utiliser la méthode alternative
          return null;
        }
      }
      
      if (googleUser == null) {
        print('🔴 Connexion Google web échouée');
        return null;
      }

      print('✅ Utilisateur Google connecté (web): ${googleUser.email}');
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      if (googleAuth.accessToken == null) {
        print('🔴 AccessToken est null sur le web');
        return null;
      }

      final result = {
        'provider': 'google',
        'providerId': googleUser.id,
        'email': googleUser.email,
        'firstName': googleUser.displayName?.split(' ').first ?? '',
        'lastName': googleUser.displayName?.split(' ').skip(1).join(' ') ?? '',
        'profileImage': googleUser.photoUrl,
        'accessToken': googleAuth.accessToken,
        'idToken': googleAuth.idToken,
      };
      
      print('✅ Données Google web préparées: ${result['email']}');
      return result;
    } catch (e) {
      print('🔴 Erreur Google Sign In web: $e');
      print('🔴 Type d\'erreur: ${e.runtimeType}');
      print('🔵 Utilisation du mode de test comme fallback...');
      return _createTestUserData();
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _facebookAuth.logOut();
      // Apple doesn't have a sign out method
    } catch (e) {
      print('Sign out error: $e');
    }
  }
}

