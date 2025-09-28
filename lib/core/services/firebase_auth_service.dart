import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../../domain/entities/user.dart';

class FirebaseAuthService {
  static final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Initialiser Firebase Auth
  static Future<void> initialize() async {
    try {
      print('🔵 Initialisation de Firebase Auth...');
      // Firebase est déjà initialisé dans main.dart
      print('✅ Firebase Auth initialisé');
    } catch (e) {
      print('🔴 Erreur lors de l\'initialisation de Firebase Auth: $e');
    }
  }

  /// Authentification Google avec Firebase
  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      print('🔵 === DÉBUT AUTHENTIFICATION GOOGLE FIREBASE ===');
      
      // Déclencher le flux d'authentification Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
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

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print('🔴 Tokens Google manquants');
        return null;
      }

      print('✅ Tokens Google obtenus:');
      print('   🔑 AccessToken: ${googleAuth.accessToken!.substring(0, 20)}...');
      print('   🆔 IDToken: ${googleAuth.idToken!.substring(0, 20)}...');

      // Créer un nouveau credential
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('🔵 Authentification avec Firebase...');
      
      // Une fois connecté, retourner le UserCredential
      final firebase_auth.UserCredential userCredential = await _auth.signInWithCredential(credential);
      final firebase_auth.User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        print('🔴 Échec de l\'authentification Firebase');
        return null;
      }

      print('✅ Authentification Firebase réussie:');
      print('   🔥 UID Firebase: ${firebaseUser.uid}');
      print('   📧 Email: ${firebaseUser.email}');
      print('   👤 Nom: ${firebaseUser.displayName}');
      print('   🖼️ Photo: ${firebaseUser.photoURL}');
      print('   ✅ Email vérifié: ${firebaseUser.emailVerified}');

      // Préparer les données utilisateur pour le backend
      final userData = {
        'provider': 'google',
        'providerId': firebaseUser.uid, // Utiliser l'UID Firebase
        'email': firebaseUser.email,
        'firstName': _extractFirstName(firebaseUser.displayName),
        'lastName': _extractLastName(firebaseUser.displayName),
        'profileImage': firebaseUser.photoURL,
        'firebaseUid': firebaseUser.uid,
        'emailVerified': firebaseUser.emailVerified,
        'accessToken': googleAuth.accessToken,
        'idToken': googleAuth.idToken,
      };
      
      print('✅ Données utilisateur préparées:');
      print('   📧 Email: ${userData['email']}');
      print('   👤 Prénom: ${userData['firstName']}');
      print('   👤 Nom: ${userData['lastName']}');
      print('   🔥 Firebase UID: ${userData['firebaseUid']}');
      print('🔵 === FIN AUTHENTIFICATION GOOGLE FIREBASE ===');
      
      return userData;
    } catch (e) {
      print('🔴 Erreur lors de l\'authentification Google Firebase: $e');
      print('🔴 Type d\'erreur: ${e.runtimeType}');
      if (e is firebase_auth.FirebaseAuthException) {
        print('🔴 Code d\'erreur Firebase: ${e.code}');
        print('🔴 Message d\'erreur Firebase: ${e.message}');
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

  /// Synchroniser les données Firebase avec la base de données
  static Future<Map<String, dynamic>?> syncWithBackend(
    Map<String, dynamic> firebaseData,
    UserRole role,
  ) async {
    try {
      print('🔵 === SYNCHRONISATION AVEC BACKEND ===');
      print('🔵 Rôle sélectionné: $role');
      print('🔵 Email: ${firebaseData['email']}');
      print('🔵 Firebase UID: ${firebaseData['firebaseUid']}');
      
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/auth/social'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          ...firebaseData,
          'role': role.name,
        }),
      );

      print('🔵 Réponse backend: ${response.statusCode}');
      print('🔵 Corps de la réponse: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('✅ Synchronisation backend réussie');
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

  /// Obtenir l'utilisateur Firebase actuel
  static firebase_auth.User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Vérifier si l'utilisateur est connecté
  static bool isSignedIn() {
    return _auth.currentUser != null;
  }

  /// Déconnexion
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      print('✅ Déconnexion Firebase et Google effectuée');
    } catch (e) {
      print('🔴 Erreur lors de la déconnexion: $e');
    }
  }

  /// Obtenir le token d'ID Firebase
  static Future<String?> getIdToken() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return await user.getIdToken();
      }
      return null;
    } catch (e) {
      print('🔴 Erreur lors de la récupération du token: $e');
      return null;
    }
  }

  /// Écouter les changements d'état d'authentification
  static Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();
}


