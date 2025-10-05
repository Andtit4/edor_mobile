# Page d'Inscription Prestataire - Documentation

## Vue d'ensemble

Cette implémentation ajoute une page d'inscription spécialisée pour les prestataires avec sélection du type de prestation et intégration complète avec l'API backend.

## Architecture

### 1. Entités (Domain Layer)

#### `ServiceCategory`
- **Fichier**: `lib/domain/entities/service_category.dart`
- **Description**: Entité représentant une catégorie de service
- **Propriétés**:
  - `id`: Identifiant unique
  - `name`: Nom de la catégorie (ex: "Plomberie", "Électricité")
  - `description`: Description de la catégorie
  - `icon`: Nom de l'icône Material Design
  - `image`: URL de l'image
  - `isActive`: Statut actif/inactif
  - `prestataireCount`: Nombre de prestataires dans cette catégorie
  - `createdAt`: Date de création

### 2. Repository (Data Layer)

#### `ServiceCategoriesRepository`
- **Interface**: `lib/domain/repositories/service_categories_repository.dart`
- **Implémentation**: `lib/data/repositories/service_categories_repository.dart`
- **Méthodes**:
  - `getCategories()`: Récupère toutes les catégories
  - `getCategoryById(String id)`: Récupère une catégorie par ID

#### Sources de données
- **Locale**: `lib/data/datasources/local/service_categories_local_data_source.dart`
  - Cache avec SharedPreferences
  - Expiration après 24h
- **Distante**: `lib/data/datasources/remote/service_categories_remote_data_source.dart`
  - Utilise les données mock pour l'instant
  - Prêt pour l'intégration API backend

### 3. Provider (Presentation Layer)

#### `ServiceCategoriesProvider`
- **Fichier**: `lib/presentation/providers/service_categories_provider.dart`
- **État**: `ServiceCategoriesState`
- **Fonctionnalités**:
  - Chargement des catégories
  - Sélection de catégorie
  - Recherche de catégories
  - Gestion des erreurs

### 4. Interface Utilisateur

#### `PrestataireRegistrationScreen`
- **Fichier**: `lib/presentation/screens/auth/prestataire_registration_screen.dart`
- **Fonctionnalités**:
  - Sélection du type de prestation (grille interactive)
  - Saisie de la localisation
  - Description des services
  - Tarif horaire optionnel
  - Gestion des compétences (ajout/suppression)
  - Validation complète des champs
  - Animations fluides

## Flux d'Inscription

### 1. Inscription Standard
```
RegisterScreen → Sélection "Prestataire" → PrestataireRegistrationScreen
```

### 2. Données Transmises
- Email, mot de passe, prénom, nom, téléphone (depuis RegisterScreen)
- Catégorie sélectionnée
- Localisation
- Description des services
- Tarif horaire
- Compétences

### 3. Validation
- **Catégorie**: Obligatoire
- **Localisation**: Obligatoire
- **Description**: Obligatoire, minimum 20 caractères
- **Tarif**: Optionnel, doit être un nombre positif

## Intégration API Backend

### Structure Backend Analysée

#### Entité Prestataire
```typescript
// backend/src/entities/prestataire.entity.ts
{
  category: string;        // ✅ Géré
  location: string;        // ✅ Géré
  description: string;     // ✅ Géré
  pricePerHour: number;    // ✅ Géré
  skills: string[];        // ✅ Géré
  categories: string[];    // ✅ Géré (pour multi-catégories)
}
```

#### DTO de Création
```typescript
// backend/src/prestataires/dto/create-prestataire.dto.ts
{
  category: string;        // ✅ Mappé depuis ServiceCategory.name
  location: string;        // ✅ Champ localisation
  description: string;     // ✅ Champ description
  pricePerHour?: number;   // ✅ Champ tarif horaire
  skills?: string[];       // ✅ Liste des compétences
}
```

### Endpoints API Utilisés

#### Inscription Prestataire
- **URL**: `POST /prestataires`
- **Body**: `CreatePrestataireDto`
- **Réponse**: Prestataire créé avec token

#### Récupération des Catégories (Futur)
- **URL**: `GET /categories` (à implémenter côté backend)
- **Réponse**: Liste des catégories disponibles

## Types de Prestations Disponibles

1. **Bricolage** - Petits travaux de réparation
2. **Ménage** - Nettoyage et entretien domestique
3. **Jardinage** - Entretien d'espaces verts
4. **Cuisine** - Préparation de repas et service traiteur
5. **Transport** - Services de transport et livraison
6. **Électricité** - Installation et réparation électrique
7. **Plomberie** - Installation et réparation de plomberie
8. **Beauté** - Services de coiffure et soins esthétiques

## Navigation

### Routes Ajoutées
- **Path**: `/prestataire-register`
- **Name**: `prestataireRegister`
- **Paramètres**: Données utilisateur via `extra`

### Flux de Navigation
```
RegisterScreen → PrestataireRegistrationScreen → HomeScreen (après inscription)
```

## Fonctionnalités Avancées

### 1. Interface Utilisateur
- **Grille de catégories**: Sélection visuelle avec icônes
- **Animations**: Transitions fluides et feedback visuel
- **Validation en temps réel**: Messages d'erreur contextuels
- **Gestion des compétences**: Ajout/suppression dynamique

### 2. Gestion d'État
- **Cache local**: Persistance des catégories
- **Gestion d'erreurs**: Messages utilisateur appropriés
- **Loading states**: Indicateurs de chargement

### 3. Validation
- **Côté client**: Validation des champs obligatoires
- **Côté serveur**: Validation via DTOs backend
- **Messages d'erreur**: Feedback utilisateur clair

## Tests et Validation

### Points de Test
1. **Sélection de catégorie**: Vérifier la sélection/désélection
2. **Validation des champs**: Tester les règles de validation
3. **Ajout de compétences**: Vérifier l'ajout/suppression
4. **Navigation**: Tester le flux d'inscription
5. **Intégration API**: Vérifier l'envoi des données

### Données de Test
```json
{
  "email": "prestataire@test.com",
  "password": "password123",
  "firstName": "Jean",
  "lastName": "Dupont",
  "phone": "0123456789",
  "role": "prestataire",
  "category": "Plomberie",
  "location": "Paris, France",
  "description": "Plombier expérimenté avec 10 ans d'expérience...",
  "pricePerHour": 35.0,
  "skills": ["Réparation", "Installation", "Dépannage"]
}
```

## Prochaines Étapes

### 1. Backend
- [ ] Implémenter l'endpoint `GET /categories`
- [ ] Ajouter la validation des catégories
- [ ] Tester l'inscription des prestataires

### 2. Frontend
- [ ] Ajouter des tests unitaires
- [ ] Implémenter la recherche de catégories
- [ ] Ajouter la gestion des images de profil

### 3. Améliorations
- [ ] Support multi-catégories
- [ ] Géolocalisation automatique
- [ ] Upload de portfolio
- [ ] Système de vérification

## Utilisation

### Pour les Développeurs
1. L'utilisateur sélectionne "Prestataire" sur l'écran d'inscription
2. Il est redirigé vers `PrestataireRegistrationScreen`
3. Il remplit les informations spécifiques aux prestataires
4. Les données sont envoyées à l'API backend
5. L'utilisateur est connecté et redirigé vers l'accueil

### Pour les Utilisateurs
1. Créer un compte → Sélectionner "Prestataire"
2. Choisir son domaine d'expertise
3. Remplir sa localisation et description
4. Optionnellement ajouter un tarif et des compétences
5. Valider l'inscription

## Support

Pour toute question ou problème :
- Vérifier les logs de l'application
- Consulter la documentation de l'API backend
- Tester avec les données de test fournies




