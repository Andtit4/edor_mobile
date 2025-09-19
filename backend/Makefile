# Makefile pour gérer l'API Edor avec Docker

.PHONY: help build up down restart logs status clean dev prod

# Aide
help:
	@echo "🚀 Commandes disponibles pour l'API Edor:"
	@echo ""
	@echo "  make build     - Construire l'image Docker"
	@echo "  make up        - Démarrer l'API (production)"
	@echo "  make dev       - Démarrer l'API (développement)"
	@echo "  make prod      - Démarrer l'API (production avancée)"
	@echo "  make down      - Arrêter l'API"
	@echo "  make restart   - Redémarrer l'API"
	@echo "  make logs      - Voir les logs"
	@echo "  make status    - Voir le statut"
	@echo "  make clean     - Nettoyer les conteneurs et images"
	@echo "  make health    - Vérifier la santé de l'API"
	@echo ""

# Construire l'image
build:
	@echo "🔨 Construction de l'image Docker..."
	docker-compose build

# Démarrer en production
up:
	@echo "🚀 Démarrage de l'API en production..."
	docker-compose up -d
	@echo "✅ API démarrée sur http://localhost:8090"

# Démarrer en développement
dev:
	@echo "🚀 Démarrage de l'API en développement..."
	docker-compose -f docker-compose.dev.yml up -d
	@echo "✅ API démarrée sur http://localhost:8090"

# Démarrer en production avancée
prod:
	@echo "🚀 Démarrage de l'API en production avancée..."
	docker-compose -f docker-compose.prod.yml up -d
	@echo "✅ API démarrée sur http://localhost:8090"

# Arrêter
down:
	@echo "🛑 Arrêt de l'API..."
	docker-compose down

# Redémarrer
restart:
	@echo "🔄 Redémarrage de l'API..."
	docker-compose restart

# Voir les logs
logs:
	@echo "📋 Logs de l'API:"
	docker-compose logs -f

# Voir le statut
status:
	@echo "📊 Statut des conteneurs:"
	docker-compose ps
	@echo ""
	@echo "🔍 Santé de l'API:"
	@curl -s http://localhost:8090/health 2>/dev/null || echo "❌ API non accessible"

# Vérifier la santé
health:
	@echo "🔍 Vérification de la santé de l'API..."
	@curl -f http://localhost:8090/health && echo "✅ API en bonne santé" || echo "❌ API non accessible"

# Nettoyer
clean:
	@echo "🧹 Nettoyage des conteneurs et images..."
	docker-compose down
	docker rmi edor-api 2>/dev/null || true
	docker system prune -f
	@echo "✅ Nettoyage terminé"
