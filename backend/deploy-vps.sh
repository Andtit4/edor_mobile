#!/bin/bash

# Script de déploiement pour VPS
echo "🚀 Déploiement de l'API sur VPS..."

# Arrêter les conteneurs existants
echo "🛑 Arrêt des conteneurs existants..."
docker-compose down

# Supprimer l'image existante
echo "🗑️ Suppression de l'ancienne image..."
docker rmi edor-api 2>/dev/null || true

# Construire la nouvelle image
echo "🔨 Construction de la nouvelle image..."
docker build -f Dockerfile.simple -t edor-api .

# Vérifier que l'image a été construite
if [ $? -eq 0 ]; then
    echo "✅ Image construite avec succès!"
else
    echo "❌ Erreur lors de la construction de l'image"
    exit 1
fi

# Démarrer le conteneur
echo "🚀 Démarrage du conteneur..."
docker-compose up -d

# Attendre que le conteneur démarre
echo "⏳ Attente du démarrage du conteneur..."
sleep 15

# Vérifier la santé de l'API
echo "🔍 Vérification de la santé de l'API..."
if curl -f http://localhost:8090/health > /dev/null 2>&1; then
    echo "✅ API déployée avec succès sur http://localhost:8090"
    echo "📊 Statut de l'API:"
    curl -s http://localhost:8090/health | jq . 2>/dev/null || curl -s http://localhost:8090/health
else
    echo "❌ L'API n'est pas accessible"
    echo "📋 Logs du conteneur:"
    docker-compose logs --tail=20
fi

echo "📋 Commandes utiles:"
echo "  - Voir les logs: docker-compose logs -f"
echo "  - Arrêter: docker-compose down"
echo "  - Redémarrer: docker-compose restart"
echo "  - Statut: docker-compose ps"
