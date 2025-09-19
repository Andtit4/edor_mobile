#!/bin/bash

echo "🔧 Configuration du fichier .env..."

# Vérifier si .env existe déjà
if [ -f ".env" ]; then
    echo "⚠️  Le fichier .env existe déjà"
    read -p "Voulez-vous le remplacer? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Configuration annulée"
        exit 1
    fi
fi

# Créer le fichier .env
cat > .env << 'EOF'
# Configuration de l'API Edor
NODE_ENV=production
PORT=8090
BASE_URL=http://localhost:8090

# Configuration de la base de données
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=your_username
DB_PASSWORD=your_password
DB_NAME=edor_db

# Configuration JWT
JWT_SECRET=your_jwt_secret_key_here
JWT_EXPIRES_IN=24h

# Configuration email
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your_email@gmail.com
EMAIL_PASS=your_app_password

# Configuration upload
UPLOAD_PATH=./uploads
MAX_FILE_SIZE=5242880
EOF

echo "✅ Fichier .env créé!"
echo "📋 Modifiez le fichier .env avec vos vraies configurations"
echo "📋 Puis lancez: ./run.sh"

