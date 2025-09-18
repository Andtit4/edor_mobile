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
2. **Endpoint de test** - `POST /email/test` (nécessite une authentification)

## 📝 Fonctionnalités

- ✅ **Email de bienvenue automatique** lors de l'inscription
- ✅ **Templates personnalisés** selon le rôle (client/prestataire)
- ✅ **Gestion d'erreurs** - L'inscription ne échoue pas si l'email ne peut pas être envoyé
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

**Sans configuration** : L'inscription fonctionne, mais aucun email n'est envoyé (message dans les logs)

**Avec configuration** : L'inscription envoie automatiquement un email de bienvenue personnalisé
