# Utiliser Node.js 18 comme image de base
FROM node:18-alpine

# Installer curl pour le healthcheck
RUN apk add --no-cache curl

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers package.json et package-lock.json
COPY package*.json ./

# Installer TOUTES les dépendances (y compris devDependencies pour la compilation)
RUN npm ci

# Copier le code source
COPY . .

# Compiler TypeScript avec la commande build
RUN npm run build

# Supprimer les devDependencies après la compilation
RUN npm prune --production

# Exposer le port 8090
EXPOSE 8090

# Créer un utilisateur non-root pour la sécurité
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nestjs -u 1001

# Créer le dossier uploads
RUN mkdir -p uploads/profiles uploads/service-requests

# Changer la propriété des fichiers
RUN chown -R nestjs:nodejs /app
USER nestjs

# Commande pour démarrer l'application
CMD ["node", "dist/main.js"]
