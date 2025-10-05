# Correction du problème des catégories prestataires

## Problème identifié

Lors de l'inscription d'un prestataire via Google Auth, le backend créait automatiquement un prestataire avec la catégorie "Général" au lieu d'utiliser la catégorie sélectionnée par l'utilisateur.

## Cause du problème

1. **DTO incomplet** : Le `SocialAuthDto` ne contenait pas les champs pour les données prestataire (category, location, description, etc.)
2. **Service d'auth** : Le service d'authentification sociale utilisait des valeurs par défaut au lieu des données fournies
3. **Approche en deux étapes** : Le frontend tentait de faire une inscription sociale puis une mise à jour du profil, mais l'endpoint de mise à jour n'existait pas

## Solutions appliquées

### 1. Mise à jour du DTO SocialAuthDto

**Fichier** : `backend/src/auth/dto/social-auth.dto.ts`

Ajout des champs optionnels pour tous les utilisateurs et spécifiques aux prestataires :

```typescript
// Champs optionnels pour tous les utilisateurs
@IsOptional()
@IsString()
address?: string;

@IsOptional()
@IsString()
city?: string;

@IsOptional()
@IsString()
postalCode?: string;

@IsOptional()
@IsString()
bio?: string;

@IsOptional()
@IsArray()
@IsString({ each: true })
skills?: string[];

@IsOptional()
@IsArray()
@IsString({ each: true })
categories?: string[];

// Champs spécifiques aux prestataires
@IsOptional()
@IsString()
category?: string;

@IsOptional()
@IsString()
location?: string;

@IsOptional()
@IsString()
description?: string;

@IsOptional()
@IsNumber()
pricePerHour?: number;

@IsOptional()
@IsArray()
@IsString({ each: true })
portfolio?: string[];
```

### 2. Mise à jour du service d'authentification

**Fichier** : `backend/src/auth/auth.service.ts`

- Extraction des nouvelles données du DTO
- Utilisation des données fournies au lieu des valeurs par défaut
- Correction des erreurs TypeScript en utilisant `new Entity()` au lieu de `repository.create()`

```typescript
// Utiliser les données fournies ou des valeurs par défaut
newPrestataire.category = category || 'Général';
newPrestataire.location = location || 'Non spécifié';
newPrestataire.description = description || 'Prestataire de services';
newPrestataire.pricePerHour = pricePerHour || 0;
newPrestataire.skills = skills || [];
newPrestataire.categories = categories || [];
newPrestataire.portfolio = portfolio || [];
```

### 3. Simplification du service Google Auth frontend

**Fichier** : `lib/core/services/simple_google_auth_service.dart`

- Suppression de l'approche en deux étapes
- Envoi de toutes les données en une seule requête
- Mapping automatique de `description` vers `bio`

```dart
// Préparer les données à envoyer
final requestData = {
  ...googleData,
  'role': role.name,
};

// Ajouter les données supplémentaires si elles existent
if (additionalData != null) {
  requestData.addAll(additionalData.map((key, value) {
    // Mapper description vers bio pour la cohérence
    if (key == 'description') {
      return MapEntry('bio', value);
    }
    return MapEntry(key, value);
  }));
}
```

## Script de mise à jour des données existantes

**Fichier** : `backend/update-existing-prestataires.js`

Script pour mettre à jour les prestataires existants qui ont "Général" comme catégorie :

```bash
cd backend
node update-existing-prestataires.js
```

## Test de la correction

1. **Inscription prestataire via Google** :
   - Sélectionner le rôle "prestataire"
   - Choisir une catégorie (ex: "menage")
   - Remplir les informations
   - Vérifier que la catégorie est correctement sauvegardée

2. **Vérification en base** :
   ```sql
   SELECT id, name, category, location FROM prestataires WHERE category != 'Général';
   ```

## Résultat attendu

- ✅ Les nouveaux prestataires ont la bonne catégorie
- ✅ Les données de localisation sont correctement sauvegardées
- ✅ Les compétences et la description sont préservées
- ✅ Plus d'erreur 400 Bad Request lors de l'inscription sociale
- ✅ Cohérence entre le frontend et le backend

## Notes importantes

- Les prestataires existants avec "Général" peuvent être mis à jour via le script
- Le mapping `description` → `bio` est automatique
- Tous les champs sont optionnels pour maintenir la compatibilité
- La validation côté backend est maintenue avec les décorateurs `@IsOptional()`




