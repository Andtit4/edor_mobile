#!/bin/bash

# Script de gestion PM2 pour l'API Edor

case "$1" in
    start)
        echo "🚀 Démarrage de l'API..."
        pm2 start ecosystem.config.js --env production
        ;;
    stop)
        echo "🛑 Arrêt de l'API..."
        pm2 stop edor-api
        ;;
    restart)
        echo "🔄 Redémarrage de l'API..."
        pm2 restart edor-api
        ;;
    reload)
        echo "🔄 Rechargement de l'API..."
        pm2 reload edor-api
        ;;
    delete)
        echo "🗑️ Suppression de l'API..."
        pm2 delete edor-api
        ;;
    status)
        echo "📊 Statut de l'API:"
        pm2 status
        ;;
    logs)
        echo "📋 Logs de l'API:"
        pm2 logs edor-api
        ;;
    monit)
        echo "📊 Monitoring de l'API:"
        pm2 monit
        ;;
    build)
        echo "🔨 Compilation de l'API..."
        npm run build
        pm2 reload edor-api
        ;;
    install)
        echo "📦 Installation des dépendances..."
        npm install
        ;;
    setup)
        echo "🔧 Configuration initiale..."
        if [ ! -f ".env" ]; then
            echo "⚠️  Créez un fichier .env avec vos configurations"
            exit 1
        fi
        npm install
        npm run build
        pm2 start ecosystem.config.js --env production
        pm2 save
        pm2 startup
        ;;
    *)
        echo "🚀 Gestionnaire PM2 pour l'API Edor"
        echo ""
        echo "Usage: $0 {start|stop|restart|reload|delete|status|logs|monit|build|install|setup}"
        echo ""
        echo "Commandes:"
        echo "  start    - Démarrer l'API"
        echo "  stop     - Arrêter l'API"
        echo "  restart  - Redémarrer l'API"
        echo "  reload   - Recharger l'API (sans interruption)"
        echo "  delete   - Supprimer l'API de PM2"
        echo "  status   - Voir le statut"
        echo "  logs     - Voir les logs"
        echo "  monit    - Monitoring en temps réel"
        echo "  build    - Compiler et recharger"
        echo "  install  - Installer les dépendances"
        echo "  setup    - Configuration initiale complète"
        ;;
esac







