# Configuration Email pour Edor

## ⚠️ Configuration requise

Pour activer l'envoi d'emails de bienvenue, vous devez configurer les variables d'environnement suivantes dans votre fichier `.env` :

```env
# Email Configuration
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USER=your-email@gmail.com
MAIL_PASS=your-app-password
MAIL_FROM=noreply@edor.com
```

## 📧 Configuration Gmail (Recommandée)

### 1. Activer l'authentification à 2 facteurs
- Allez dans votre compte Google
- Sécurité > Authentification à 2 facteurs
- Activez l'authentification à 2 facteurs

### 2. Générer un mot de passe d'application
- Allez dans Sécurité > Mots de passe des applications
- Sélectionnez "Autre" et donnez un nom (ex: "Edor App")
- Copiez le mot de passe généré
- Utilisez ce mot de passe dans `MAIL_PASS`

### 3. Exemple de configuration
```env
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USER=monemail@gmail.com
MAIL_PASS=abcd efgh ijkl mnop
MAIL_FROM=noreply@edor.com
```

## 🔧 Configuration alternative

### Outlook/Hotmail
```env
MAIL_HOST=smtp-mail.outlook.com
MAIL_PORT=587
MAIL_USER=monemail@outlook.com
MAIL_PASS=mon-mot-de-passe
```

### Yahoo
```env
MAIL_HOST=smtp.mail.yahoo.com
MAIL_PORT=587
MAIL_USER=monemail@yahoo.com
MAIL_PASS=mon-mot-de-passe
```

## 🧪 Test de l'email

Une fois configuré, vous pouvez tester l'envoi d'emails :

1. **Inscription d'un nouvel utilisateur** - Un email de bienvenue sera automatiquement envoyé
2. **Création d'une demande de service** - Un email de confirmation sera envoyé au client
3. **Proposition de prix par un prestataire** - Un email de notification sera envoyé au client
4. **Acceptation d'une offre par un client** - Un email de notification sera envoyé au prestataire
5. **Clôture d'un projet par un client** - Un email de feedback sera envoyé au prestataire
6. **Endpoint de test** - `POST /email/test` (nécessite une authentification)

## 📝 Fonctionnalités

- ✅ **Email de bienvenue automatique** lors de l'inscription
- ✅ **Email de confirmation** lors de la création d'une demande de service
- ✅ **Email de notification** quand un prestataire fait une proposition de prix
- ✅ **Email de notification** quand un client accepte une offre de prestataire
- ✅ **Email de feedback** quand un client clôture un projet avec sa note et ses remarques
- ✅ **Templates personnalisés** selon le rôle (client/prestataire)
- ✅ **Gestion d'erreurs** - Les opérations ne échouent pas si l'email ne peut pas être envoyé
- ✅ **Configuration flexible** via variables d'environnement

## 🚨 Dépannage

### Erreur "Missing credentials for PLAIN"
- Vérifiez que `MAIL_USER` et `MAIL_PASS` sont définis dans votre `.env`
- Redémarrez le serveur après avoir modifié le `.env`

### Erreur d'authentification Gmail
- Utilisez un mot de passe d'application, pas votre mot de passe normal
- Vérifiez que l'authentification à 2 facteurs est activée

### Erreur de connexion
- Vérifiez que le port 587 est ouvert
- Certains réseaux bloquent SMTP, testez depuis un autre réseau

## 📋 Statut actuel

**Sans configuration** : 
- L'inscription fonctionne, mais aucun email de bienvenue n'est envoyé (message dans les logs)
- La création de demande fonctionne, mais aucun email de confirmation n'est envoyé (message dans les logs)
- Les propositions de prix fonctionnent, mais aucun email de notification n'est envoyé (message dans les logs)
- Les acceptations d'offres fonctionnent, mais aucun email de notification n'est envoyé (message dans les logs)
- Les clôtures de projets fonctionnent, mais aucun email de feedback n'est envoyé (message dans les logs)

**Avec configuration** : 
- L'inscription envoie automatiquement un email de bienvenue personnalisé
- La création de demande envoie automatiquement un email de confirmation avec les détails
- Les propositions de prix envoient automatiquement un email de notification au client
- Les acceptations d'offres envoient automatiquement un email de notification au prestataire
- Les clôtures de projets envoient automatiquement un email de feedback au prestataire
