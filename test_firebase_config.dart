// Script de test pour vérifier la configuration Firebase
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🔵 Test de configuration Firebase...');
  
  try {
    // Initialiser Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialisé');
    
    // Tester Google Sign In
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      clientId: '205344853554-p0qffu3icdbo0lk4kpeses6df6g1lusu.apps.googleusercontent.com',
      serverClientId: '205344853554-p0qffu3icdbo0lk4kpeses6df6g1lusu.apps.googleusercontent.com',
    );
    
    print('🔵 Test de Google Sign In...');
    final GoogleSignInAccount? account = await googleSignIn.signIn();
    
    if (account != null) {
      print('✅ Google Sign In réussi: ${account.email}');
      
      final GoogleSignInAuthentication auth = await account.authentication;
      print('✅ Tokens obtenus:');
      print('   AccessToken: ${auth.accessToken != null ? "Oui" : "Non"}');
      print('   IDToken: ${auth.idToken != null ? "Oui" : "Non"}');
      
      // Tester Firebase Auth
      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      print('✅ Firebase Auth réussi: ${userCredential.user?.email}');
      
    } else {
      print('🔴 Google Sign In annulé');
    }
    
  } catch (e) {
    print('🔴 Erreur: $e');
  }
}


