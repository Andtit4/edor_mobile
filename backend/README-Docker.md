# 🐳 Déploiement Docker de l'API Edor

## 📋 Prérequis

- Docker installé sur votre VPS
- Docker Compose installé
- Port 8090 disponible

## 🚀 Déploiement rapide

### Option 1: Script automatique
```bash
chmod +x deploy-vps.sh
./deploy-vps.sh
```

### Option 2: Commandes manuelles
```bash
# Construire l'image
docker build -f Dockerfile.simple -t edor-api .

# Démarrer avec docker-compose
docker-compose up -d

# Vérifier le statut
docker-compose ps
```

## 🔍 Vérification

### Vérifier que l'API fonctionne
```bash
curl http://localhost:8090/health
```

### Voir les logs
```bash
docker-compose logs -f
```

### Arrêter l'API
```bash
docker-compose down
```

## 📁 Structure des fichiers

```
backend/
├── Dockerfile              # Dockerfile principal
├── Dockerfile.simple       # Dockerfile simplifié (recommandé)
├── docker-compose.yml      # Configuration Docker Compose
├── deploy-vps.sh          # Script de déploiement
└── uploads/               # Dossier des fichiers uploadés
    ├── profiles/          # Photos de profil
    └── service-requests/  # Photos des demandes
```

## 🔧 Configuration

L'API sera accessible sur `http://votre-vps-ip:8090`

### Variables d'environnement
- `PORT=8090` - Port de l'API
- `NODE_ENV=production` - Environnement de production
- `BASE_URL=http://localhost:8090` - URL de base

## 🐛 Dépannage

### Problème "nest not found"
- Utilisez `Dockerfile.simple` qui compile directement avec `npx tsc`
- Évite les problèmes de dépendances NestJS

### L'API ne démarre pas
```bash
# Voir les logs détaillés
docker-compose logs --tail=50

# Redémarrer le conteneur
docker-compose restart
```

### Port déjà utilisé
```bash
# Vérifier les ports utilisés
netstat -tulpn | grep :8090

# Arrêter le processus qui utilise le port
sudo kill -9 <PID>
```

## 📊 Monitoring

### Vérifier la santé de l'API
```bash
curl -s http://localhost:8090/health | jq .
```

### Voir l'utilisation des ressources
```bash
docker stats
```
