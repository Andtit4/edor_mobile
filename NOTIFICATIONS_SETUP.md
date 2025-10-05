# 🔔 Système de Notifications Push - Guide d'Installation

## 📋 Vue d'ensemble

Ce système de notifications push utilise **Firebase Cloud Messaging (FCM)** pour envoyer des notifications en temps réel aux utilisateurs, même quand l'application est fermée.

### ✨ Fonctionnalités

- ✅ **Notifications en arrière-plan** : Fonctionne même quand l'app est fermée
- ✅ **Matching par catégorie** : Notifie automatiquement les prestataires de la bonne catégorie
- ✅ **Notifications contextuelles** : Différents types selon l'action (nouvelle demande, acceptation, etc.)
- ✅ **Interface utilisateur** : Page dédiée aux notifications avec badges
- ✅ **Gestion des états** : Marquer comme lu, supprimer, etc.

## 🚀 Installation

### 1. Dépendances ajoutées

```yaml
# pubspec.yaml
dependencies:
  firebase_messaging: ^15.1.3
  flutter_local_notifications: ^17.2.2
```

### 2. Permissions Android

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

<!-- Services Firebase -->
<service
    android:name="io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingService"
    android:exported="false">
    <intent-filter>
        <action android:name="com.google.firebase.MESSAGING_EVENT" />
    </intent-filter>
</service>
```

### 3. Permissions iOS

```xml
<!-- ios/Runner/Info.plist -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>Cette application a besoin d'accéder à votre localisation pour détecter automatiquement votre ville et quartier lors de l'inscription.</string>
```

## 🏗️ Architecture

### Services principaux

1. **`FirebaseNotificationService`** : Gestion des notifications FCM
2. **`ServiceRequestNotificationService`** : Logique métier des notifications
3. **`IntegratedServiceRequestService`** : Service intégré pour les demandes
4. **`NotificationProvider`** : État Riverpod des notifications

### Flux de notifications

```
Client crée demande → Backend → FCM → Prestataires (catégorie) → Notification push
```

## 📱 Utilisation

### 1. Initialisation

```dart
// main.dart
await FirebaseNotificationService().initialize();
```

### 2. Configuration pour prestataire

```dart
// Quand un prestataire se connecte
await ref.read(notificationProvider.notifier).setupPrestataireNotifications(user);
```

### 3. Créer une demande avec notifications

```dart
final serviceRequestService = ref.read(integratedServiceRequestServiceProvider);

await serviceRequestService.createServiceRequestWithNotifications(
  title: 'Nettoyage de maison',
  description: 'Besoin d\'un nettoyage complet',
  category: 'menage',
  location: 'Paris, 15ème',
  client: currentUser,
);
```

### 4. Accepter un service

```dart
await serviceRequestService.acceptServiceRequestWithNotification(
  serviceRequestId: 'req_123',
  prestataire: currentUser,
  clientId: 'client_456',
  serviceTitle: 'Nettoyage de maison',
);
```

## 🎯 Types de notifications

### Pour les prestataires
- **`new_service_request`** : Nouvelle demande dans leur catégorie
- **`service_cancelled`** : Client a annulé une demande

### Pour les clients
- **`service_accepted`** : Prestataire a accepté leur demande
- **`service_started`** : Prestataire a commencé le service
- **`service_completed`** : Service terminé

## 🔧 Configuration Backend

### Endpoints requis

```javascript
// Backend API endpoints
POST /notifications/register-token
POST /notifications/send-to-category
POST /notifications/send-to-user
POST /service-requests
POST /service-requests/:id/accept
POST /service-requests/:id/complete
POST /service-requests/:id/cancel
POST /service-requests/:id/start
```

### Structure des données

```json
{
  "type": "new_service_request",
  "serviceRequestId": "req_123",
  "category": "menage",
  "title": "Nouvelle demande de service",
  "body": "Jean Dupont a publié une nouvelle demande: Nettoyage de maison",
  "data": {
    "clientName": "Jean Dupont",
    "location": "Paris, 15ème",
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
```

## 🧪 Test des notifications

### 1. Test via l'interface

```dart
// Dans NotificationsScreen
await ref.read(notificationProvider.notifier).sendNotificationToCategory(
  category: 'menage',
  title: 'Test de notification',
  body: 'Ceci est un test',
  data: {'type': 'test'},
);
```

### 2. Test via Firebase Console

1. Aller sur [Firebase Console](https://console.firebase.google.com)
2. Sélectionner le projet
3. Aller dans "Messaging"
4. Créer une nouvelle campagne
5. Cibler par topic : `category_menage`

## 📊 Monitoring

### Logs de debug

```dart
// Les logs sont automatiquement affichés
🔔 Initialisation du service de notifications Firebase...
🔔 Token FCM obtenu: abc123...
✅ Service de notifications Firebase initialisé avec succès
🔔 Message reçu en foreground: Nouvelle demande de service
```

### Vérification des tokens

```dart
final notificationState = ref.watch(notificationProvider);
print('Token FCM: ${notificationState.fcmToken}');
print('Topics abonnés: ${notificationState.subscribedTopics}');
```

## 🚨 Dépannage

### Problèmes courants

1. **Notifications ne s'affichent pas**
   - Vérifier les permissions Android/iOS
   - Vérifier que Firebase est correctement configuré
   - Vérifier les logs de debug

2. **Token FCM non généré**
   - Vérifier la connexion internet
   - Vérifier la configuration Firebase
   - Redémarrer l'application

3. **Notifications en arrière-plan ne fonctionnent pas**
   - Vérifier le service Firebase dans AndroidManifest.xml
   - Vérifier que l'app n'est pas en mode économie d'énergie

### Commandes de debug

```bash
# Vérifier les logs
flutter logs

# Nettoyer et reconstruire
flutter clean
flutter pub get
flutter run
```

## 🔐 Sécurité

### Bonnes pratiques

1. **Validation des tokens** : Vérifier les tokens FCM côté backend
2. **Rate limiting** : Limiter le nombre de notifications par utilisateur
3. **Authentification** : Vérifier l'authentification avant d'envoyer des notifications
4. **Données sensibles** : Ne pas inclure d'informations sensibles dans les notifications

## 📈 Performance

### Optimisations

1. **Batching** : Grouper les notifications similaires
2. **Caching** : Mettre en cache les tokens FCM
3. **Retry logic** : Implémenter une logique de retry pour les échecs
4. **Analytics** : Tracker les taux de livraison et d'ouverture

## 🎉 Résultat final

Avec ce système, quand un client crée une demande de service :

1. ✅ La demande est créée sur le backend
2. ✅ Tous les prestataires de la catégorie reçoivent une notification push
3. ✅ La notification s'affiche même si l'app est fermée
4. ✅ En cliquant sur la notification, l'utilisateur est redirigé vers la demande
5. ✅ Le système gère tous les états (acceptation, completion, annulation)

**Le système est maintenant prêt à être utilisé !** 🚀




