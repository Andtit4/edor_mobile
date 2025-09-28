# 🔥 Configuration Client Web Firebase

## 🚨 Problème identifié

L'erreur `ApiException: 10` (DEVELOPER_ERROR) est causée par l'absence d'un client web dans votre configuration Firebase.

## ✅ Solution : Ajouter un client web

### 1. Aller dans Firebase Console
- Ouvrir [Firebase Console](https://console.firebase.google.com)
- Sélectionner le projet `edor-mobile`

### 2. Ajouter une application web
1. Cliquer sur l'icône **Web** (`</>`) dans la page d'accueil du projet
2. Nom de l'application : `edor-web`
3. Cocher "Also set up Firebase Hosting" (optionnel)
4. Cliquer sur "Register app"

### 3. Copier la configuration
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

### 5. Mettre à jour strings.xml
Ajouter le client ID web dans `android/app/src/main/res/values/strings.xml` :

```xml
<string name="default_web_client_id">VOTRE_CLIENT_ID_WEB</string>
```

### 6. Redémarrer l'application
```bash
flutter clean
flutter pub get
flutter run
```

## 🔍 Vérification

Après ces étapes, l'authentification Google devrait fonctionner sans l'erreur `ApiException: 10`.

## 📋 Alternative temporaire

Si vous ne pouvez pas ajouter un client web maintenant, l'application devrait quand même fonctionner avec la configuration actuelle, mais vous pourriez avoir des limitations.


