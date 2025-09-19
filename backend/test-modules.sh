#!/bin/bash

echo "🔍 Test des modules installés dans le conteneur..."

# Démarrer le conteneur en mode test
echo "🚀 Démarrage du conteneur de test..."
docker-compose up -d

# Attendre que le conteneur soit prêt
echo "⏳ Attente du démarrage..."
sleep 15

# Tester les modules
echo "📋 Vérification des modules installés:"
docker-compose exec api npm list mysql2
docker-compose exec api npm list typeorm
docker-compose exec api npm list @nestjs/typeorm

# Tester la connexion à la base de données
echo "🔗 Test de la connexion à la base de données:"
docker-compose exec api node -e "
const mysql = require('mysql2');
console.log('✅ Module mysql2 chargé avec succès');
console.log('📊 Version mysql2:', require('mysql2/package.json').version);
"

# Vérifier la santé de l'API
echo "🏥 Test de santé de l'API:"
curl -f http://localhost:8090/health && echo "✅ API en bonne santé" || echo "❌ API non accessible"

# Arrêter le conteneur de test
echo "🛑 Arrêt du conteneur de test..."
docker-compose down

echo "✅ Test terminé"

