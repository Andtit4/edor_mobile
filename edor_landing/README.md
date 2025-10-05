# Edor Landing Page

Une landing page moderne et futuriste pour l'application mobile Edor, construite avec Vue 3 et GSAP.

## 🚀 Fonctionnalités

- **Design Futuriste** : Interface moderne avec des animations avancées
- **Animations GSAP** : Animations fluides et interactives
- **Architecture Propre** : Structure modulaire avec composables Vue 3
- **Responsive Design** : Optimisé pour tous les appareils
- **Performance** : Chargement rapide et optimisé
- **SEO Optimisé** : Meta tags et structure sémantique

## 🛠️ Technologies Utilisées

- **Vue 3** - Framework JavaScript progressif
- **GSAP** - Bibliothèque d'animations haute performance
- **Vite** - Build tool rapide et moderne
- **CSS3** - Styles avancés avec gradients et animations
- **JavaScript ES6+** - Syntaxe moderne

## 📁 Structure du Projet

```
src/
├── components/           # Composants Vue
│   ├── HeroSection.vue   # Section hero avec animations
│   ├── FeaturesSection.vue # Section des fonctionnalités
│   └── DownloadSection.vue # Section de téléchargement
├── composables/          # Composables Vue 3
│   ├── useGSAP.js       # Composable pour GSAP
│   ├── useTheme.js      # Gestion des thèmes
│   ├── useResponsive.js # Gestion responsive
│   └── useScrollTrigger.js # ScrollTrigger GSAP
├── assets/              # Assets statiques
│   └── main.css         # Styles globaux
├── App.vue              # Composant principal
└── main.js              # Point d'entrée
```

## 🎨 Sections de la Landing Page

### 1. Hero Section
- **Animations d'entrée** : Orbes flottants, particules, texte animé
- **Mockup d'application** : Aperçu de l'interface mobile
- **Call-to-Action** : Boutons de téléchargement et découverte
- **Statistiques** : Métriques clés de l'application

### 2. Features Section
- **Grille de fonctionnalités** : 6 fonctionnalités principales
- **Animations au scroll** : Apparition progressive des cartes
- **Démo interactive** : Aperçu des étapes d'utilisation
- **Design moderne** : Cartes avec gradients et effets

### 3. Download Section
- **Boutons de téléchargement** : App Store et Google Play
- **Code QR** : Téléchargement mobile rapide
- **Stack de téléphones** : Aperçu multi-écrans
- **Statistiques** : Métriques de téléchargement

## 🎭 Animations GSAP

### Types d'Animations
- **Text Reveal** : Apparition progressive du texte
- **Stagger Animation** : Animations en cascade
- **Parallax Effect** : Effet de parallaxe au scroll
- **Floating Animation** : Éléments flottants
- **Morphing Animation** : Transformation d'éléments
- **Particle Animation** : Système de particules

### Configuration
```javascript
// Exemple d'utilisation
const { createTimeline, textReveal, staggerAnimation } = useGSAP()

// Animation de texte
textReveal(element, {
  y: 50,
  duration: 1,
  ease: "power3.out"
})

// Animation en cascade
staggerAnimation(elements, {
  from: { opacity: 0, y: 60 },
  to: { opacity: 1, y: 0 }
}, {
  stagger: 0.15
})
```

## 🎨 Design System

### Couleurs
- **Primary** : #8B5CF6 (Violet)
- **Secondary** : #06B6D4 (Cyan)
- **Accent** : #10B981 (Vert)
- **Warning** : #F59E0B (Orange)
- **Error** : #EF4444 (Rouge)

### Gradients
- **Primary** : linear-gradient(135deg, #8B5CF6, #7C3AED)
- **Secondary** : linear-gradient(135deg, #06B6D4, #0891B2)
- **Hero** : linear-gradient(135deg, #8B5CF6, #7C3AED, #06B6D4)

### Typographie
- **Font Family** : Inter
- **Weights** : 300, 400, 500, 600, 700, 800, 900
- **Responsive** : Tailles adaptatives selon l'écran

## 📱 Responsive Design

### Breakpoints
- **Mobile** : < 768px
- **Tablet** : 768px - 1024px
- **Desktop** : > 1024px
- **Large Desktop** : > 1440px

### Adaptations
- **Navigation** : Menu hamburger sur mobile
- **Grilles** : Colonnes adaptatives
- **Typographie** : Tailles de police responsives
- **Animations** : Optimisées pour mobile

## 🚀 Installation et Développement

### Prérequis
- Node.js 20.19.0 ou supérieur
- npm ou yarn

### Installation
```bash
# Cloner le projet
git clone [repository-url]
cd edor_landing

# Installer les dépendances
npm install

# Démarrer le serveur de développement
npm run dev

# Build pour la production
npm run build

# Prévisualiser le build
npm run preview
```

### Scripts Disponibles
- `npm run dev` - Serveur de développement
- `npm run build` - Build de production
- `npm run preview` - Prévisualisation du build

## 🔧 Configuration

### Variables d'Environnement
Créer un fichier `.env` pour les variables d'environnement :
```env
VITE_APP_TITLE=Edor
VITE_APP_DESCRIPTION=Plateforme de services
VITE_API_URL=https://api.edor.app
```

### Configuration Vite
Le fichier `vite.config.js` contient la configuration du build tool.

## 📊 Performance

### Optimisations
- **Lazy Loading** : Chargement différé des composants
- **Code Splitting** : Division du code en chunks
- **Image Optimization** : Images optimisées
- **CSS Purging** : Suppression du CSS inutilisé

### Métriques
- **Lighthouse Score** : 95+ sur tous les critères
- **First Contentful Paint** : < 1.5s
- **Largest Contentful Paint** : < 2.5s
- **Cumulative Layout Shift** : < 0.1

## 🎯 SEO

### Meta Tags
- **Title** : Optimisé pour chaque page
- **Description** : Descriptions uniques et attrayantes
- **Open Graph** : Partage social optimisé
- **Twitter Cards** : Cartes Twitter personnalisées

### Structure Sémantique
- **HTML5** : Balises sémantiques appropriées
- **Schema.org** : Données structurées
- **Sitemap** : Plan du site XML
- **Robots.txt** : Instructions pour les crawlers

## 🚀 Déploiement

### Options de Déploiement
- **Vercel** : Déploiement automatique
- **Netlify** : Déploiement continu
- **GitHub Pages** : Hébergement gratuit
- **AWS S3** : Stockage cloud

### Configuration de Production
```bash
# Build optimisé
npm run build

# Les fichiers sont générés dans dist/
# Déployer le contenu du dossier dist/
```

## 🤝 Contribution

### Guidelines
1. Fork le projet
2. Créer une branche feature
3. Commiter les changements
4. Pousser vers la branche
5. Ouvrir une Pull Request

### Standards de Code
- **ESLint** : Linting JavaScript
- **Prettier** : Formatage du code
- **Conventional Commits** : Messages de commit standardisés

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 📞 Support

Pour toute question ou support :
- **Email** : support@edor.app
- **Documentation** : [docs.edor.app](https://docs.edor.app)
- **Issues** : [GitHub Issues](https://github.com/edor/landing/issues)

---

**Développé avec ❤️ par l'équipe Edor**