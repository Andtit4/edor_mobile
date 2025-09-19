#!/bin/bash

echo "🔄 Redémarrage de l'API Edor..."

# Arrêter et redémarrer
docker-compose down
docker-compose up -d

echo "✅ API redémarrée sur http://localhost:8090"
