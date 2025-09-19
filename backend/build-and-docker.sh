#!/bin/bash

# Script pour compiler localement puis créer l'image Docker

echo "🔨 Compilation locale de l'API..."

# Vérifier que nous sommes dans le bon répertoire
if [ ! -f "package.json" ]; then
    echo "❌ Erreur: package.json non trouvé. Exécutez ce script depuis le dossier backend/"
    exit 1
fi

# Installer les dépendances si nécessaire
if [ ! -d "node_modules" ]; then
    echo "📦 Installation des dépendances..."
    npm install
fi

# Compiler l'API
echo "🔨 Compilation TypeScript..."
npm run build

# Vérifier que la compilation a réussi
if [ ! -f "dist/main.js" ]; then
    echo "❌ Erreur: dist/main.js non trouvé après compilation"
    echo "📋 Contenu du dossier dist:"
    ls -la dist/ 2>/dev/null || echo "Dossier dist n'existe pas"
    exit 1
fi

echo "✅ Compilation réussie!"

# Créer l'image Docker
echo "🐳 Création de l'image Docker..."
docker build -f Dockerfile.copy -t edor-api .

if [ $? -eq 0 ]; then
    echo "✅ Image Docker créée avec succès!"
    echo "🚀 Pour démarrer l'API:"
    echo "   docker run -p 8090:8090 edor-api"
    echo "   ou"
    echo "   docker-compose up -d"
else
    echo "❌ Erreur lors de la création de l'image Docker"
    exit 1
fi
