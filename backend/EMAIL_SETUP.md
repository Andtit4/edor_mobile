# Configuration Email pour Edor

## Variables d'environnement requises

Ajoutez ces variables à votre fichier `.env` :

```env
# Email Configuration
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USER=your-email@gmail.com
MAIL_PASS=your-app-password
MAIL_FROM=noreply@edor.com
```

## Configuration Gmail

### 1. Activer l'authentification à 2 facteurs
- Allez dans votre compte Google
- Sécurité > Authentification à 2 facteurs
- Activez l'authentification à 2 facteurs

### 2. Générer un mot de passe d'application
- Allez dans Sécurité > Mots de passe des applications
- Sélectionnez "Autre" et donnez un nom (ex: "Edor App")
- Copiez le mot de passe généré
- Utilisez ce mot de passe dans `MAIL_PASS`

### 3. Configuration alternative (autres fournisseurs)

#### Outlook/Hotmail
```env
MAIL_HOST=smtp-mail.outlook.com
MAIL_PORT=587
```

#### Yahoo
```env
MAIL_HOST=smtp.mail.yahoo.com
MAIL_PORT=587
```

#### Serveur SMTP personnalisé
```env
MAIL_HOST=your-smtp-server.com
MAIL_PORT=587
MAIL_USER=your-username
MAIL_PASS=your-password
```

## Test de l'email

Pour tester l'envoi d'emails, vous pouvez utiliser l'endpoint de test (à ajouter si nécessaire) :

```typescript
// Dans EmailController
@Post('test')
async testEmail() {
  await this.emailService.sendTestEmail();
  return { message: 'Email de test envoyé' };
}
```

## Template d'email

Le template de bienvenue se trouve dans `backend/templates/welcome.hbs`

Variables disponibles dans le template :
- `fullName` : Nom complet de l'utilisateur
- `firstName` : Prénom
- `lastName` : Nom de famille
- `role` : Rôle (client ou prestataire de services)
- `email` : Adresse email

## Dépannage

### Erreur d'authentification
- Vérifiez que l'authentification à 2 facteurs est activée
- Utilisez un mot de passe d'application, pas votre mot de passe normal
- Vérifiez que les variables d'environnement sont correctement définies

### Erreur de connexion
- Vérifiez que le port 587 est ouvert
- Certains réseaux bloquent SMTP, testez depuis un autre réseau
- Vérifiez les paramètres de sécurité de votre compte email
