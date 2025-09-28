# EDOR - Application de Mise en Relation

Une application mobile Flutter pour la mise en relation entre clients et prestataires de petits services au Togo.

## 🚀 Fonctionnalités

### MVP (Version actuelle)
- ✅ Authentification (Connexion / Inscription)
- ✅ Navigation par catégories de services
- ✅ Recherche de prestataires
- ✅ Profils détaillés des prestataires
- ✅ Système de réservation
- ✅ Messagerie intégrée
- ✅ Gestion du profil utilisateur
- ✅ Mode sombre/clair
- ✅ Interface responsive et accessible

### Données Mock
L'application utilise actuellement des données simulées stockées dans des fichiers JSON locaux pour permettre le développement et les tests sans backend.

## 🏗️ Architecture

Le projet suit les principes de **Clean Architecture** avec la structure suivante :

```
lib/
├── core/               # Utilitaires partagés
│   ├── errors/        # Gestion des erreurs
│   ├── network/       # Configuration réseau
│   ├── theme/         # Thèmes et styles
│   └── utils/         # Utilitaires généraux
├── data/              # Couche de données
│   ├── datasources/   # Sources de données (local/remote)
│   ├── models/        # Modèles de données
│   ├── repositories_impl/ # Implémentations des repositories
│   └── mock_data/     # Données fictives JSON
├── domain/            # Logique métier
│   ├── entities/      # Entités métier
│   ├── repositories/  # Interfaces des repositories
│   └── usecases/      # Cas d'usage
├── presentation/      # Interface utilisateur
│   ├── providers/     # Providers Riverpod
│   ├── router/        # Configuration des routes
│   ├── screens/       # Écrans de l'application
│   └── widgets/       # Widgets réutilisables
└── main.dart          # Point d'entrée
```

## 🛠️ Stack Technique

### Framework et Langage
- **Flutter 3.28.0** - Framework UI multiplateforme
- **Dart 3.7.2** - Langage de programmation

### Packages Principaux
- `flutter_riverpod` - State management
- `go_router` - Navigation et routing
- `freezed` - Modèles immutables
- `json_serializable` - Sérialisation JSON
- `fpdart` - Programmation fonctionnelle
- `cached_network_image` - Gestion des images
- `shared_preferences` - Stockage local
- `google_fonts` - Polices personnalisées
- `lottie` - Animations

### Outils de Développement
- `build_runner` - Génération de code
- `flutter_lints` - Règles de linting
- `mocktail` - Tests unitaires

## 🚀 Installation et Lancement

### Prérequis
- Flutter SDK 3.28.0 ou supérieur
- Dart SDK 3.7.2 ou supérieur
- Android Studio / VS Code
- Émulateur Android ou appareil physique

### Installation

1. **Cloner le repository**
   ```bash
   git clone <repository-url>
   cd edor
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Générer les fichiers de code**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Lancer l'application**
   ```bash
   flutter run
   ```

### Commandes Utiles

```bash
# Installer les dépendances
flutter pub get

# Générer le code (freezed, json_serializable)
dart run build_runner build

# Générer en mode watch (développement)
dart run build_runner watch

# Lancer les tests
flutter test

# Analyser le code
flutter analyze

# Formatter le code
dart format .

# Nettoyer le projet
flutter clean
```

## 📱 Utilisation de l'Application

### Comptes de Démonstration

Pour tester l'application, utilisez ces identifiants :

**Client**
- Email: `jean.dupont@email.com`
- Mot de passe: `n'importe quoi` (pas de validation pour le MVP)

**Prestataire** (inscription)
- Créez un nouveau compte en sélectionnant "Prestataire"

### Navigation

1. **Splash Screen** - Écran de démarrage avec logo animé
2. **Authentification** - Connexion ou inscription
3. **Accueil** - Catégories et liste des prestataires
4. **Détail Prestataire** - Profil complet avec bouton de réservation
5. **Réservation** - Formulaire de demande de service
6. **Messages** - Conversations avec les prestataires
7. **Profil** - Gestion du compte utilisateur

## 🎨 Design System

### Couleurs Principales
- **Primary Blue**: `#1976D2`
- **Secondary Green**: `#2E7D32`
- **Accent Yellow**: `#F9A825`
- **Background Light**: `#F7F8FA`

### Typographie
- **Police**: Inter (via Google Fonts)
- **Tailles**: Respecte les guidelines Material Design 3

### Composants
- Cards arrondies (16dp border radius)
- Boutons avec états de chargement
- Animations subtiles et hero transitions
- Support du mode sombre

## 🧪 Tests

### Types de Tests
- **Tests Unitaires**: Logique métier et providers
- **Tests de Widgets**: Composants UI clés
- **Couverture**: Objectif 60%+ pour le MVP

### Lancer les Tests
```bash
# Tous les tests
flutter test

# Tests spécifiques
flutter test test/unit/
flutter test test/widget/

# Coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 📦 Build et Déploiement

### Android
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (recommandé pour Play Store)
flutter build appbundle --release
```

### iOS
```bash
# Debug
flutter build ios --debug

# Release
flutter build ios --release
```

## 🔧 Configuration CI/CD

Le projet inclut un workflow GitHub Actions pour :
- ✅ Installation des dépendances
- ✅ Génération du code
- ✅ Analyse statique (`flutter analyze`)
- ✅ Exécution des tests
- ✅ Build des artefacts

Voir `.github/workflows/flutter-ci.yml` pour les détails.

## 🌐 Internationalisation

L'application est prête pour l'internationalisation :
- **Langues supportées**: Français (par défaut), Anglais
- **Configuration**: `lib/l10n/` (à implémenter)
- **Dates**: Format localisé avec `intl`

## 🔮 Roadmap - Connexion Backend

### Endpoints Attendus

L'application est conçue pour être facilement connectée à un backend. Voici les endpoints attendus :

#### Authentification
- `POST /auth/login` - Connexion
- `POST /auth/register` - Inscription
- `POST /auth/logout` - Déconnexion
- `GET /auth/me` - Profil utilisateur actuel

#### Prestataires
- `GET /prestataires` - Liste des prestataires
- `GET /prestataires/:id` - Détail d'un prestataire
- `GET /prestataires/search?q=` - Recherche
- `GET /categories` - Liste des catégories

#### Messages
- `GET /conversations` - Conversations de l'utilisateur
- `GET /conversations/:id/messages` - Messages d'une conversation
- `POST /conversations/:id/messages` - Envoyer un message

#### Réservations
- `POST /reservations` - Créer une réservation
- `GET /reservations` - Réservations de l'utilisateur
- `PUT /reservations/:id` - Modifier une réservation

### Migration vers le Backend

1. Remplacer `LocalDataSourceImpl` par `RemoteDataSourceImpl`
2. Utiliser `dio` pour les appels HTTP
3. Mettre à jour les repositories pour utiliser les vraies API
4. Ajouter la gestion des tokens d'authentification
5. Implémenter la gestion hors ligne

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👥 Contribution

1. Fork the project
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📞 Support

Pour toute question ou support, contactez l'équipe de développement.

---

**EDOR** - Votre partenaire services 🚀