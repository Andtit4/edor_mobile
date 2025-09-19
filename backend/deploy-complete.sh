#!/bin/bash

# Script de déploiement complet pour VPS

echo "🚀 Déploiement complet de l'API Edor sur VPS..."

# Vérifier que nous sommes dans le bon répertoire
if [ ! -f "package.json" ]; then
    echo "❌ Erreur: package.json non trouvé. Exécutez ce script depuis le dossier backend/"
    exit 1
fi

# Arrêter les conteneurs existants
echo "🛑 Arrêt des conteneurs existants..."
docker-compose down 2>/dev/null || true

# Supprimer l'image existante
echo "🗑️ Suppression de l'ancienne image..."
docker rmi edor-api 2>/dev/null || true

# Compiler l'API localement
echo "🔨 Compilation de l'API..."
if [ ! -d "node_modules" ]; then
    echo "📦 Installation des dépendances..."
    npm install
fi

npm run build

# Vérifier que la compilation a réussi
if [ ! -f "dist/main.js" ]; then
    echo "❌ Erreur: dist/main.js non trouvé après compilation"
    echo "📋 Tentative de compilation alternative..."
    npx tsc
    if [ ! -f "dist/main.js" ]; then
        echo "❌ Échec de la compilation. Vérifiez les erreurs TypeScript."
        exit 1
    fi
fi

echo "✅ Compilation réussie!"

# Créer l'image Docker
echo "🐳 Création de l'image Docker..."
docker build -f Dockerfile.copy -t edor-api .

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de la création de l'image Docker"
    exit 1
fi

echo "✅ Image Docker créée avec succès!"

# Démarrer le conteneur
echo "🚀 Démarrage du conteneur..."
docker-compose up -d

# Attendre que le conteneur démarre
echo "⏳ Attente du démarrage du conteneur..."
sleep 10

# Vérifier la santé de l'API
echo "🔍 Vérification de la santé de l'API..."
for i in {1..5}; do
    if curl -f http://localhost:8090/health > /dev/null 2>&1; then
        echo "✅ API déployée avec succès sur http://localhost:8090"
        echo "📊 Statut de l'API:"
        curl -s http://localhost:8090/health | jq . 2>/dev/null || curl -s http://localhost:8090/health
        exit 0
    else
        echo "⏳ Tentative $i/5 - L'API n'est pas encore prête..."
        sleep 5
    fi
done

echo "❌ L'API n'est pas accessible après 5 tentatives"
echo "📋 Logs du conteneur:"
docker-compose logs --tail=20

echo "📋 Commandes utiles:"
echo "  - Voir les logs: docker-compose logs -f"
echo "  - Arrêter: docker-compose down"
echo "  - Redémarrer: docker-compose restart"
echo "  - Statut: docker-compose ps"
