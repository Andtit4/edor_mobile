#!/bin/bash

echo "🚀 Déploiement de l'API Edor avec PM2..."

# Vérifier que PM2 est installé
if ! command -v pm2 &> /dev/null; then
    echo "📦 Installation de PM2..."
    npm install -g pm2
fi

# Vérifier que le fichier .env existe
if [ ! -f ".env" ]; then
    echo "⚠️  Fichier .env non trouvé!"
    echo "📋 Créez un fichier .env avec vos configurations"
    exit 1
fi

# Créer le dossier logs
mkdir -p logs

# Arrêter l'API si elle tourne déjà
echo "🛑 Arrêt de l'API existante..."
pm2 stop edor-api 2>/dev/null || true
pm2 delete edor-api 2>/dev/null || true

# Installer les dépendances
echo "📦 Installation des dépendances..."
npm install

# Compiler l'API
echo "🔨 Compilation de l'API..."
npm run build

# Vérifier que la compilation a réussi
if [ ! -f "dist/main.js" ]; then
    echo "❌ Erreur: dist/main.js non trouvé après compilation"
    exit 1
fi

# Démarrer l'API avec PM2
echo "🚀 Démarrage de l'API avec PM2..."
pm2 start ecosystem.config.js --env production

# Sauvegarder la configuration PM2
pm2 save

# Configurer PM2 pour démarrer au boot
pm2 startup

echo "✅ API déployée avec succès!"
echo "📊 Statut:"
pm2 status

echo "📋 Commandes utiles:"
echo "  - Voir les logs: pm2 logs edor-api"
echo "  - Redémarrer: pm2 restart edor-api"
echo "  - Arrêter: pm2 stop edor-api"
echo "  - Statut: pm2 status"
echo "  - Monitoring: pm2 monit"

