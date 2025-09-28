# 🔧 SOLUTION DÉFINITIVE : Ajouter le SHA-1 Fingerprint

## 🚨 PROBLÈME IDENTIFIÉ

L'erreur `ApiException: 10` (DEVELOPER_ERROR) est causée par l'absence du **SHA-1 fingerprint** dans Firebase Console.

## ✅ SOLUTION ÉTAPE PAR ÉTAPE

### 1. Aller dans Firebase Console
- Ouvrir [Firebase Console](https://console.firebase.google.com)
- Sélectionner le projet `edor-mobile`

### 2. Ajouter le SHA-1 Fingerprint
1. Aller dans **Project Settings** (icône ⚙️ en haut à gauche)
2. Onglet **General**
3. Section **Your apps**
4. Cliquer sur l'icône Android de votre app
5. Section **SHA certificate fingerprints**
6. Cliquer sur **Add fingerprint**
7. Ajouter ce SHA-1 : `40:88:5A:7C:A4:F8:02:5B:C3:C5:B5:D7:81:3B:5A:B0:A7:AD:51:DA`
8. Cliquer sur **Save**

### 3. Télécharger le nouveau google-services.json
1. Toujours dans **Project Settings** → **General**
2. Section **Your apps** → icône Android
3. Cliquer sur **Download google-services.json**
4. Remplacer le fichier dans `android/app/google-services.json`

### 4. Redémarrer l'application
```bash
flutter clean
flutter pub get
flutter run
```

## 🔍 Vérification

Après ces étapes :
- ✅ SHA-1 fingerprint ajouté dans Firebase Console
- ✅ Nouveau google-services.json téléchargé
- ✅ Application redémarrée

L'authentification Google devrait fonctionner !

## 📋 Informations importantes

- **Package name** : `com.example.edor`
- **SHA-1 fingerprint** : `40:88:5A:7C:A4:F8:02:5B:C3:C5:B5:D7:81:3B:5A:B0:A7:AD:51:DA`
- **Project ID** : `edor-mobile`

## 🚨 IMPORTANT

Le SHA-1 fingerprint est **OBLIGATOIRE** pour que Google Sign In fonctionne sur Android. Sans cela, vous aurez toujours l'erreur `ApiException: 10`.


