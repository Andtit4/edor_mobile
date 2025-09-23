# 🚀 Déploiement PM2 - API Edor

## Installation rapide

### 1. Installation complète
```bash
chmod +x install-pm2.sh
./install-pm2.sh
```

### 2. Configuration manuelle
```bash
# Installer PM2
sudo npm install -g pm2

# Installer les dépendances
npm install

# Compiler l'API
npm run build

# Démarrer avec PM2
pm2 start ecosystem.config.js --env production

# Sauvegarder la configuration
pm2 save

# Configurer le démarrage automatique
pm2 startup
```

## Gestion de l'API

### Scripts de gestion
```bash
# Rendre le script exécutable
chmod +x pm2-manage.sh

# Démarrer l'API
./pm2-manage.sh start

# Arrêter l'API
./pm2-manage.sh stop

# Redémarrer l'API
./pm2-manage.sh restart

# Voir le statut
./pm2-manage.sh status

# Voir les logs
./pm2-manage.sh logs

# Monitoring en temps réel
./pm2-manage.sh monit
```

### Commandes NPM
```bash
# Démarrer avec PM2
npm run pm2:start

# Arrêter
npm run pm2:stop

# Redémarrer
npm run pm2:restart

# Voir le statut
npm run pm2:status

# Voir les logs
npm run pm2:logs

# Déploiement (build + reload)
npm run deploy
```

## Commandes PM2 directes

### Gestion de base
```bash
# Démarrer l'API
pm2 start ecosystem.config.js --env production

# Arrêter l'API
pm2 stop edor-api

# Redémarrer l'API
pm2 restart edor-api

# Recharger l'API (sans interruption)
pm2 reload edor-api

# Supprimer l'API
pm2 delete edor-api
```

### Monitoring et logs
```bash
# Voir le statut
pm2 status

# Voir les logs
pm2 logs edor-api

# Logs en temps réel
pm2 logs edor-api --follow

# Monitoring en temps réel
pm2 monit

# Informations détaillées
pm2 show edor-api
```

### Sauvegarde et restauration
```bash
# Sauvegarder la configuration
pm2 save

# Restaurer la configuration
pm2 resurrect

# Vider la configuration
pm2 kill
```

## Configuration

### Fichier ecosystem.config.js
- **Port** : 8090
- **Environnement** : production
- **Logs** : ./logs/
- **Redémarrage automatique** : activé
- **Limite mémoire** : 1GB

### Variables d'environnement
Le fichier `.env` est automatiquement chargé par PM2.

## Avantages de PM2 vs Docker

✅ **Plus simple** : Pas besoin de Docker
✅ **Plus léger** : Moins de ressources
✅ **Monitoring intégré** : PM2 monit
✅ **Logs centralisés** : Gestion des logs
✅ **Redémarrage automatique** : En cas de crash
✅ **Démarrage au boot** : Persistance
✅ **Déploiement facile** : npm run deploy

## Dépannage

### L'API ne démarre pas
```bash
# Voir les logs d'erreur
pm2 logs edor-api --err

# Redémarrer en mode debug
pm2 restart edor-api --update-env
```

### Problème de mémoire
```bash
# Voir l'utilisation mémoire
pm2 monit

# Redémarrer si nécessaire
pm2 restart edor-api
```

### Problème de port
```bash
# Vérifier que le port est libre
netstat -tulpn | grep :8090

# Tuer le processus qui utilise le port
sudo kill -9 <PID>
```



