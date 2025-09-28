#!/bin/bash

echo "🔧 Installation de PM2 et configuration de l'API Edor..."

# Mettre à jour le système
echo "📦 Mise à jour du système..."
sudo apt update

# Installer Node.js si pas déjà installé
if ! command -v node &> /dev/null; then
    echo "📦 Installation de Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Installer PM2 globalement
echo "📦 Installation de PM2..."
sudo npm install -g pm2

# Installer les dépendances du projet
echo "📦 Installation des dépendances du projet..."
npm install

# Créer le dossier logs
mkdir -p logs

# Vérifier que le fichier .env existe
if [ ! -f ".env" ]; then
    echo "⚠️  Fichier .env non trouvé!"
    echo "📋 Créez un fichier .env avec vos configurations"
    echo "📋 Vous pouvez utiliser: ./setup-env.sh"
    exit 1
fi

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
echo "🔧 Configuration du démarrage automatique..."
pm2 startup

echo "✅ Installation terminée!"
echo "📊 Statut de l'API:"
pm2 status

echo "📋 Commandes utiles:"
echo "  - Gérer l'API: ./pm2-manage.sh {start|stop|restart|status|logs}"
echo "  - Monitoring: pm2 monit"
echo "  - Logs en temps réel: pm2 logs edor-api"







