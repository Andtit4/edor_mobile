# 🧪 Test du flux d'authentification Google

## 📋 Étapes de test

### 1. Préparation
- ✅ SHA-1 fingerprint ajouté dans Firebase Console
- ✅ Nouveau google-services.json téléchargé
- ✅ Application redémarrée

### 2. Test du flux complet

1. **Lancer l'application**
   ```bash
   flutter run
   ```

2. **Aller sur la page d'inscription**
   - Cliquer sur "S'inscrire"
   - Sélectionner un rôle (Client ou Prestataire)

3. **Tester l'authentification Google**
   - Cliquer sur le bouton Google (icône G rouge)
   - Sélectionner un compte Google
   - Vérifier que le modal de sélection de rôle apparaît

4. **Sélectionner le rôle**
   - Choisir "Client" ou "Prestataire"
   - Cliquer sur "Confirmer"

5. **Vérifier la redirection**
   - L'utilisateur doit être automatiquement redirigé vers la page d'accueil
   - L'utilisateur doit être connecté (état authentifié)

## 🔍 Logs à surveiller

### Logs attendus :
```
🔵 === DÉBUT AUTHENTIFICATION GOOGLE SIMPLE5 ===
✅ Compte Google sélectionné: [email]
✅ Rôle sélectionné: [role]
🔵 Synchronisation avec le backend...
✅ Réponse backend reçue: {user: {...}, token: "..."}
🔵 Utilisateur créé: [email], Rôle: [role]
🔵 Sauvegarde de la session...
🔵 Mise à jour de l'état AuthProvider...
✅ Authentification Google Firebase réussie pour: [email]
🔵 RegisterScreen - AuthState changed: isAuthenticated=true
✅ RegisterScreen - User authenticated, redirecting to home
```

### Logs d'erreur possibles :
- `🔴 Erreur lors de l'authentification Google: PlatformException`
- `🔴 Échec de la synchronisation backend`
- `🔴 RegisterScreen - Error: [message]`

## 🎯 Résultat attendu

Après le test, vous devriez :
1. ✅ Être connecté avec votre compte Google
2. ✅ Être redirigé vers la page d'accueil
3. ✅ Voir vos informations de profil (nom, email, rôle)
4. ✅ Pouvoir vous reconnecter avec le même compte Google

## 🚨 Si ça ne marche pas

1. **Vérifier les logs** pour identifier l'étape qui échoue
2. **Vérifier Firebase Console** que le SHA-1 est bien ajouté
3. **Vérifier le backend** qu'il est en cours d'exécution
4. **Vérifier la connexion internet**

## 📱 Test de reconnexion

1. Se déconnecter de l'application
2. Aller sur la page de connexion
3. Cliquer sur le bouton Google
4. Sélectionner le même compte Google
5. Vérifier que la connexion se fait automatiquement


