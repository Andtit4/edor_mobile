#!/bin/bash

echo "🚀 Démarrage de l'API Edor..."

# Vérifier que le fichier .env existe
if [ ! -f ".env" ]; then
    echo "⚠️  Fichier .env non trouvé!"
    echo "📋 Créez un fichier .env avec vos configurations"
    echo "📋 Vous pouvez copier .env.example et le modifier"
    exit 1
fi

echo "✅ Fichier .env trouvé"

# Construire l'image avec tous les modules
echo "🔨 Construction de l'image avec tous les modules..."
docker-compose build

# Démarrer l'API
echo "🚀 Démarrage de l'API..."
docker-compose up -d

# Attendre que l'API soit prête
echo "⏳ Attente du démarrage..."
sleep 10

# Vérifier la santé de l'API
echo "🔍 Vérification de la santé de l'API..."
if curl -f http://localhost:8090/health > /dev/null 2>&1; then
    echo "✅ API démarrée avec succès sur http://localhost:8090"
    echo "📊 Modules installés:"
    docker-compose exec api npm list mysql2 typeorm @nestjs/typeorm 2>/dev/null || echo "Modules en cours de chargement..."
else
    echo "❌ L'API n'est pas accessible"
    echo "📋 Logs:"
    docker-compose logs --tail=20
fi

echo "📋 Commandes utiles:"
echo "  - Voir les logs: docker-compose logs -f"
echo "  - Arrêter: docker-compose down"
echo "  - Tester les modules: ./test-modules.sh"
