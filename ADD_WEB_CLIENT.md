# 🔥 Ajouter un client web dans Firebase Console

## 🚨 Problème identifié

L'erreur `ApiException: 10` est causée par l'absence d'un vrai client web dans votre configuration Firebase.

## ✅ Solution : Ajouter un client web

### 1. Aller dans Firebase Console
- Ouvrir [Firebase Console](https://console.firebase.google.com)
- Sélectionner le projet `edor-mobile`

### 2. Ajouter une application web
1. Cliquer sur l'icône **Web** (`</>`) dans la page d'accueil du projet
2. Nom de l'application : `edor-web`
3. **IMPORTANT** : Cocher "Also set up Firebase Hosting" 
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

### 4. Télécharger le nouveau google-services.json
1. Aller dans **Project Settings** (icône ⚙️)
2. Onglet **General**
3. Section **Your apps**
4. Cliquer sur l'icône Android
5. Télécharger le nouveau `google-services.json`
6. Remplacer le fichier dans `android/app/`

### 5. Vérifier la configuration
Le nouveau `google-services.json` devrait contenir :
```json
{
  "oauth_client": [
    {
      "client_id": "205344853554-p0qffu3icdbo0lk4kpeses6df6g1lusu.apps.googleusercontent.com",
      "client_type": 3
    },
    {
      "client_id": "NOUVEAU_CLIENT_ID_WEB",
      "client_type": 1
    }
  ]
}
```

### 6. Mettre à jour strings.xml
```xml
<string name="default_web_client_id">NOUVEAU_CLIENT_ID_WEB</string>
```

### 7. Redémarrer l'application
```bash
flutter clean
flutter pub get
flutter run
```

## 🔍 Alternative : Configuration manuelle

Si vous ne pouvez pas ajouter un client web, utilisez cette configuration dans `simple_google_auth_service.dart` :

```dart
static final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
  clientId: '205344853554-p0qffu3icdbo0lk4kpeses6df6g1lusu.apps.googleusercontent.com',
);
```

## 🧪 Test

Après ces étapes, l'authentification Google devrait fonctionner sans l'erreur `ApiException: 10`.
