# Configuration de l'application

## Fichier .env

Le fichier `.env` à la racine du projet contient la configuration de l'application :

```env
# Configuration de l'API
API_BASE_URL=http://localhost:3000

# Configuration de l'application
APP_NAME=Edor
APP_VERSION=1.0.0

# Configuration de l'environnement
ENVIRONMENT=development
```

## Utilisation

### 1. Modifier l'URL de l'API

Pour changer l'URL de l'API, modifiez simplement le fichier `.env` :

```env
# Pour un serveur de production
API_BASE_URL=https://api.edor.com

# Pour un serveur local différent
API_BASE_URL=http://192.168.1.100:3000
```

### 2. Utiliser la configuration dans le code

```dart
import 'package:edor/core/config/app_config.dart';

// Obtenir l'URL de base de l'API
String apiUrl = AppConfig.apiBaseUrl;

// Obtenir l'URL d'un endpoint spécifique
String authUrl = AppConfig.authEndpoint;
String uploadUrl = AppConfig.uploadEndpoint;

// Obtenir l'URL complète d'un endpoint
String loginUrl = AppConfig.getEndpointUrl('/auth/login');
```

### 3. Configuration par défaut

Si le fichier `.env` n'existe pas ou ne peut pas être lu, l'application utilise les valeurs par défaut :

- `API_BASE_URL`: `http://localhost:3000`
- `APP_NAME`: `Edor`
- `APP_VERSION`: `1.0.0`
- `ENVIRONMENT`: `development`

### 4. Configuration dynamique

Vous pouvez aussi modifier la configuration à l'exécution :

```dart
// Changer l'URL de l'API
AppConfig.setApiBaseUrl('https://api.edor.com');
```

## Endpoints disponibles

- `AppConfig.authEndpoint` - Authentification
- `AppConfig.uploadEndpoint` - Upload de fichiers
- `AppConfig.prestatairesEndpoint` - Prestataires
- `AppConfig.serviceRequestsEndpoint` - Demandes de service
- `AppConfig.negotiationsEndpoint` - Négociations
- `AppConfig.reviewsEndpoint` - Avis

