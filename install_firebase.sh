#!/bin/bash

echo "🔵 Installation des dépendances Firebase..."

# Vérifier si Flutter est installé
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter n'est pas installé. Veuillez installer Flutter d'abord."
    exit 1
fi

# Installer les dépendances Firebase
echo "📦 Installation des packages Firebase..."
flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add firebase_analytics

echo "✅ Dépendances Firebase installées !"

# Vérifier l'installation
echo "🔍 Vérification de l'installation..."
flutter pub get

echo "🎉 Configuration Firebase terminée !"
echo ""
echo "📋 Prochaines étapes :"
echo "1. Créer un projet Firebase sur https://console.firebase.google.com"
echo "2. Configurer l'authentification Google dans Firebase Console"
echo "3. Télécharger google-services.json pour Android"
echo "4. Télécharger GoogleService-Info.plist pour iOS"
echo "5. Exécuter: flutterfire configure"

