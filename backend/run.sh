#!/bin/bash

echo "🚀 Démarrage de l'API Edor..."

# Démarrer l'API
docker-compose up -d

echo "✅ API démarrée sur http://localhost:8090"
echo "📋 Pour voir les logs: docker-compose logs -f"
echo "📋 Pour arrêter: docker-compose down"
