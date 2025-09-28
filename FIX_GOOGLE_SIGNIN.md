# 🔧 Solution définitive pour Google Sign In

## 🚨 Problème identifié

L'erreur `ApiException: 10` (DEVELOPER_ERROR) persiste car la configuration Google Sign In n'est pas correcte.

## ✅ Solution étape par étape

### 1. Aller dans Firebase Console
- Ouvrir [Firebase Console](https://console.firebase.google.com)
- Sélectionner le projet `edor-mobile`

### 2. Ajouter une application web
1. Cliquer sur l'icône **Web** (`</>`) dans la page d'accueil
2. Nom de l'application : `edor-web`
3. **IMPORTANT** : Cocher "Also set up Firebase Hosting" 
4. Cliquer sur "Register app"

### 3. Copier la configuration web
Vous obtiendrez un code comme :
```javascript
const firebaseConfig = {
  apiKey: "AIzaSy...",
  authDomain: "edor-mobile.firebaseapp.com",
  projectId: "edor-mobile",
  storageBucket: "edor-mobile.firebasestorage.app",
  messagingSenderId: "205344853554",
  appId: "1:205344853554:web:xxxxxxxxx"
};
```

### 4. Mettre à jour firebase_options.dart
Remplacer la section `web` dans `lib/firebase_options.dart` :

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'VOTRE_API_KEY_WEB',
  appId: 'VOTRE_APP_ID_WEB',
  messagingSenderId: '205344853554',
  projectId: 'edor-mobile',
  authDomain: 'edor-mobile.firebaseapp.com',
  storageBucket: 'edor-mobile.firebasestorage.app',
);
```

### 5. Mettre à jour google-services.json
Ajouter le client web dans `android/app/google-services.json` :

```json
{
  "client_id": "VOTRE_CLIENT_ID_WEB",
  "client_type": 1
}
```

### 6. Mettre à jour strings.xml
```xml
<string name="default_web_client_id">VOTRE_CLIENT_ID_WEB</string>
```

### 7. Redémarrer l'application
```bash
flutter clean
flutter pub get
flutter run
```

## 🔍 Alternative : Configuration manuelle

Si vous ne pouvez pas ajouter un client web, utilisez cette configuration :

### Dans `lib/core/services/simple_google_auth_service.dart` :
```dart
static final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
  clientId: '205344853554-p0qffu3icdbo0lk4kpeses6df6g1lusu.apps.googleusercontent.com',
);
```

### Dans `android/app/src/main/res/values/strings.xml` :
```xml
<string name="default_web_client_id">205344853554-p0qffu3icdbo0lk4kpeses6df6g1lusu.apps.googleusercontent.com</string>
```

## 🧪 Test

Après ces étapes, l'authentification Google devrait fonctionner sans l'erreur `ApiException: 10`.

## 📋 Vérification

1. ✅ Client web ajouté dans Firebase Console
2. ✅ Configuration mise à jour dans firebase_options.dart
3. ✅ Client web ajouté dans google-services.json
4. ✅ default_web_client_id mis à jour dans strings.xml
5. ✅ Application redémarrée


