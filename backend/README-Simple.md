# 🚀 API Edor - Démarrage Simple

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
