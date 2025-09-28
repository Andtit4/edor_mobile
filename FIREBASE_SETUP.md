# 🔥 Configuration Firebase pour Edor Mobile

## 📋 Prérequis

1. **Flutter installé** sur votre système
2. **Compte Google** pour accéder à Firebase Console
3. **Projet Firebase** créé

## 🚀 Étapes de configuration

### 1. Installation des dépendances Firebase

```bash
# Exécuter le script d'installation
./install_firebase.sh

# Ou manuellement :
flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add firebase_analytics
```

### 2. Création du projet Firebase

1. Aller sur [Firebase Console](https://console.firebase.google.com)
2. Cliquer sur "Créer un projet"
3. Nommer le projet : `edor-app`
4. Activer Google Analytics (optionnel)
5. Créer le projet

### 3. Configuration de l'authentification

1. Dans Firebase Console, aller dans **Authentication**
2. Cliquer sur **Commencer**
3. Aller dans l'onglet **Sign-in method**
4. Activer **Google** comme fournisseur
5. Configurer le nom du projet et l'email de support
6. Sauvegarder

### 4. Configuration des applications

#### Android
1. Cliquer sur l'icône Android dans Firebase Console
2. Package name : `com.example.edor` (ou votre package)
3. Télécharger `google-services.json`
4. Placer le fichier dans `android/app/`

#### iOS
1. Cliquer sur l'icône iOS dans Firebase Console
2. Bundle ID : `com.example.edor` (ou votre bundle)
3. Télécharger `GoogleService-Info.plist`
4. Placer le fichier dans `ios/Runner/`

### 5. Configuration FlutterFire CLI

```bash
# Installer FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurer le projet
flutterfire configure --project=edor-app
```

### 6. Mise à jour des fichiers de configuration

Le fichier `lib/firebase_options.dart` sera automatiquement généré avec les bonnes clés.

## 🔧 Configuration manuelle (si FlutterFire CLI ne fonctionne pas)

### Mise à jour de `lib/firebase_options.dart`

Remplacer les valeurs par défaut par vos vraies clés Firebase :

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'VOTRE_API_KEY_ANDROID',
  appId: 'VOTRE_APP_ID_ANDROID',
  messagingSenderId: 'VOTRE_SENDER_ID',
  projectId: 'edor-app',
  storageBucket: 'edor-app.appspot.com',
);
```

### Configuration Google Sign In

Dans `android/app/build.gradle`, ajouter :

```gradle
android {
    defaultConfig {
        // ...
        minSdkVersion 21
    }
}
```

## 🧪 Test de l'authentification

1. Démarrer l'application
2. Aller sur l'écran de connexion
3. Cliquer sur "Se connecter avec Google"
4. Sélectionner un compte Google
5. Choisir le rôle (Client/Prestataire)
6. Vérifier que l'utilisateur est créé dans Firebase Console

## 🐛 Dépannage

### Erreur "Google Sign In failed"
- Vérifier que `google-services.json` est dans `android/app/`
- Vérifier que le package name correspond
- Vérifier que Google Sign In est activé dans Firebase Console

### Erreur "Firebase not initialized"
- Vérifier que `firebase_options.dart` est correct
- Vérifier que Firebase.initializeApp() est appelé dans main()

### Erreur de permissions
- Vérifier les permissions dans `android/app/src/main/AndroidManifest.xml`
- Ajouter `<uses-permission android:name="android.permission.INTERNET" />`

## 📱 Fonctionnalités implémentées

- ✅ Authentification Google avec Firebase
- ✅ Sélection de rôle (Client/Prestataire)
- ✅ Synchronisation avec la base de données backend
- ✅ Gestion des erreurs
- ✅ Déconnexion
- ✅ Persistance de session

## 🔗 Liens utiles

- [Documentation Firebase Auth](https://firebase.google.com/docs/auth/flutter/start)
- [Documentation Google Sign In](https://pub.dev/packages/google_sign_in)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)

