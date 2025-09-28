# 🔍 Vérification de la configuration Firebase

## ✅ Checklist de vérification

### 1. Firebase Console - Authentication
- [ ] Aller dans **Authentication** → **Sign-in method**
- [ ] **Google** est activé
- [ ] **Support email** est configuré
- [ ] **Project support email** est configuré

### 2. Firebase Console - Project Settings
- [ ] **Package name** : `com.example.edor`
- [ ] **SHA-1 fingerprint** : `40:88:5A:7C:A4:F8:02:5B:C3:C5:B5:D7:81:3B:5A:B0:A7:AD:51:DA`
- [ ] **google-services.json** téléchargé après ajout du SHA-1

### 3. Configuration Android
- [ ] `android/app/google-services.json` présent
- [ ] `android/app/build.gradle.kts` contient `id("com.google.gms.google-services")`
- [ ] `android/build.gradle.kts` contient `classpath("com.google.gms:google-services:4.4.0")`

### 4. Configuration Flutter
- [ ] `pubspec.yaml` contient `google_sign_in: ^6.2.1`
- [ ] `lib/core/services/simple_google_auth_service.dart` configuré
- [ ] Pas de paramètres `clientId` ou `serverClientId` dans GoogleSignIn

## 🚨 Problèmes courants

1. **SHA-1 fingerprint manquant** → Erreur `ApiException: 10`
2. **Google Sign In non activé** → Erreur d'authentification
3. **Mauvais package name** → Erreur de configuration
4. **google-services.json obsolète** → Erreur de clés

## 🎯 Solution

Le problème principal est le **SHA-1 fingerprint manquant**. Suivez le guide `FIX_SHA1_FINGERPRINT.md`.


