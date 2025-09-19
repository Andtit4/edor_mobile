# 🚀 API Edor - Démarrage Simple

## Configuration initiale

### 1. Créer le fichier .env
```bash
chmod +x setup-env.sh
./setup-env.sh
```

### 2. Modifier le fichier .env
Éditez le fichier `.env` avec vos vraies configurations (base de données, JWT, email, etc.)

## Commandes de base

### Démarrer l'API
```bash
docker-compose up -d
```

### Voir les logs
```bash
docker-compose logs -f
```

### Arrêter l'API
```bash
docker-compose down
```

### Redémarrer l'API
```bash
docker-compose restart
```

## Scripts automatiques

### Démarrer
```bash
chmod +x run.sh
./run.sh
```

### Arrêter
```bash
chmod +x stop.sh
./stop.sh
```

### Redémarrer
```bash
chmod +x restart.sh
./restart.sh
```

## Vérification

L'API sera accessible sur : `http://localhost:8090`

Test de santé : `curl http://localhost:8090/health`
