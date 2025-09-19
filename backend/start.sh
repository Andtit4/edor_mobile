#!/bin/bash

# Script simple pour démarrer l'API Edor

echo "🚀 Démarrage de l'API Edor..."

# Vérifier que Docker est installé
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose n'est pas installé"
    exit 1
fi

# Arrêter les conteneurs existants
echo "🛑 Arrêt des conteneurs existants..."
docker-compose down 2>/dev/null || true

# Construire et démarrer
echo "🔨 Construction et démarrage de l'API..."
docker-compose up -d --build

# Attendre que l'API soit prête
echo "⏳ Attente du démarrage..."
sleep 10

# Vérifier la santé
echo "🔍 Vérification de la santé..."
if curl -f http://localhost:8090/health > /dev/null 2>&1; then
    echo "✅ API démarrée avec succès sur http://localhost:8090"
    echo "📊 Statut:"
    curl -s http://localhost:8090/health | jq . 2>/dev/null || curl -s http://localhost:8090/health
else
    echo "❌ L'API n'est pas accessible"
    echo "📋 Logs:"
    docker-compose logs --tail=20
fi

echo ""
echo "📋 Commandes utiles:"
echo "  - Voir les logs: docker-compose logs -f"
echo "  - Arrêter: docker-compose down"
echo "  - Redémarrer: docker-compose restart"
