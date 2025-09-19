#!/bin/bash

# Script pour construire et déployer l'API avec Docker

echo "🐳 Construction de l'image Docker pour l'API..."

# Construire l'image Docker
docker build -t edor-api .

echo "✅ Image Docker construite avec succès!"

echo "🚀 Démarrage du conteneur sur le port 8090..."

# Arrêter le conteneur existant s'il existe
docker-compose down

# Démarrer le conteneur
docker-compose up -d

echo "✅ API déployée sur http://localhost:8090"
echo "🔍 Vérification de la santé de l'API..."

# Attendre que l'API soit prête
sleep 10

# Vérifier la santé de l'API
curl -f http://localhost:8090/health || echo "❌ L'API n'est pas encore prête"

echo "📋 Commandes utiles:"
echo "  - Voir les logs: docker-compose logs -f"
echo "  - Arrêter: docker-compose down"
echo "  - Redémarrer: docker-compose restart"
