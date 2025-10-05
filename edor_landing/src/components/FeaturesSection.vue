<template>
  <section id="features-section" class="features-section" ref="featuresRef">
    <div class="container">
      <!-- Section Header -->
      <div class="section-header" ref="headerRef">
        <div class="section-badge">
          <span class="badge-icon">✨</span>
          <span>Fonctionnalités</span>
        </div>
        <h2 class="section-title">
          Pourquoi choisir 
          <span class="gradient-text">Edor</span> ?
        </h2>
        <p class="section-description">
          Découvrez les fonctionnalités qui font d'Edor la plateforme de référence 
          pour connecter clients et prestataires de services.
        </p>
      </div>

      <!-- Features Grid -->
      <div class="features-grid" ref="gridRef">
        <div 
          v-for="(feature, index) in features" 
          :key="index"
          class="feature-card"
          :class="`feature-${index + 1}`"
          :ref="el => featureRefs[index] = el"
        >
          <div class="feature-icon">
            <div class="icon-wrapper" :style="{ background: feature.gradient }">
              <span class="icon">{{ feature.icon }}</span>
            </div>
          </div>
          
          <div class="feature-content">
            <h3 class="feature-title">{{ feature.title }}</h3>
            <p class="feature-description">{{ feature.description }}</p>
            
            <div class="feature-highlights">
              <div 
                v-for="highlight in feature.highlights" 
                :key="highlight"
                class="highlight-item"
              >
                <span class="highlight-icon">✓</span>
                <span>{{ highlight }}</span>
              </div>
            </div>
          </div>
          
          <div class="feature-visual">
            <div class="visual-element" :style="{ background: feature.gradient }">
              <div class="visual-content">
                <div 
                  v-for="i in 3" 
                  :key="i"
                  class="visual-dot"
                  :style="{ 
                    animationDelay: (i * 0.2) + 's',
                    background: feature.color 
                  }"
                ></div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Interactive Demo Section -->
      <div class="demo-section" ref="demoRef">
        <div class="demo-content">
          <div class="demo-text">
            <h3 class="demo-title">Voir Edor en action</h3>
            <p class="demo-description">
              Découvrez comment Edor simplifie la recherche et la réservation 
              de services en quelques étapes simples.
            </p>
            <button class="btn btn-primary" @click="playDemo">
              <span>Voir la démo</span>
              <svg class="btn-icon" viewBox="0 0 24 24" fill="none">
                <path d="M8 5V19L19 12L8 5Z" fill="currentColor"/>
              </svg>
            </button>
          </div>
          
          <div class="demo-visual" ref="demoVisualRef">
            <div class="demo-phone">
              <div class="demo-screen">
                <div class="demo-step" v-for="(step, index) in demoSteps" :key="index">
                  <div class="step-content">
                    <div class="step-icon">{{ step.icon }}</div>
                    <div class="step-text">{{ step.text }}</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useGSAP } from '../composables/useGSAP'
import { useParallaxAnimations } from '../composables/useParallaxAnimations'

const { staggerAnimation, textReveal, floatingAnimation } = useGSAP()
const { revealOnScroll, staggerReveal, magneticHover, tiltEffect } = useParallaxAnimations()

// Template refs
const featuresRef = ref(null)
const headerRef = ref(null)
const gridRef = ref(null)
const demoRef = ref(null)
const demoVisualRef = ref(null)
const featureRefs = ref([])

// Features data
const features = ref([
  {
    icon: '🔍',
    title: 'Recherche Intelligente',
    description: 'Trouvez le prestataire parfait grâce à notre algorithme de matching avancé.',
    gradient: 'linear-gradient(135deg, #8B5CF6, #7C3AED)',
    color: '#8B5CF6',
    highlights: [
      'Filtres avancés',
      'Géolocalisation précise',
      'Recommandations personnalisées'
    ]
  },
  {
    icon: '💬',
    title: 'Messagerie Intégrée',
    description: 'Communiquez directement avec les prestataires via notre système de chat sécurisé.',
    gradient: 'linear-gradient(135deg, #06B6D4, #0891B2)',
    color: '#06B6D4',
    highlights: [
      'Chat en temps réel',
      'Partage de fichiers',
      'Historique des conversations'
    ]
  },
  {
    icon: '⭐',
    title: 'Système d\'Avis',
    description: 'Consultez les avis authentiques et laissez votre propre évaluation.',
    gradient: 'linear-gradient(135deg, #10B981, #059669)',
    color: '#10B981',
    highlights: [
      'Avis vérifiés',
      'Photos des travaux',
      'Système de notation'
    ]
  },
  {
    icon: '💰',
    title: 'Paiement Sécurisé',
    description: 'Payez en toute sécurité avec notre système de paiement intégré.',
    gradient: 'linear-gradient(135deg, #F59E0B, #D97706)',
    color: '#F59E0B',
    highlights: [
      'Paiement en ligne',
      'Sécurité bancaire',
      'Remboursement garanti'
    ]
  },
  {
    icon: '📱',
    title: 'Application Mobile',
    description: 'Accédez à tous les services depuis votre smartphone, partout et à tout moment.',
    gradient: 'linear-gradient(135deg, #EF4444, #DC2626)',
    color: '#EF4444',
    highlights: [
      'Interface intuitive',
      'Notifications push',
      'Mode hors ligne'
    ]
  },
  {
    icon: '🛡️',
    title: 'Sécurité & Confiance',
    description: 'Tous nos prestataires sont vérifiés et assurés pour votre tranquillité.',
    gradient: 'linear-gradient(135deg, #6366F1, #4F46E5)',
    color: '#6366F1',
    highlights: [
      'Vérification d\'identité',
      'Assurance responsabilité',
      'Support 24/7'
    ]
  }
])

// Demo steps
const demoSteps = ref([
  { icon: '🔍', text: 'Rechercher un service' },
  { icon: '👤', text: 'Choisir un prestataire' },
  { icon: '💬', text: 'Discuter du projet' },
  { icon: '✅', text: 'Confirmer la réservation' }
])

const playDemo = () => {
  // Animation pour la démo
  const steps = demoVisualRef.value?.querySelectorAll('.demo-step')
  if (steps) {
    steps.forEach((step, index) => {
      setTimeout(() => {
        step.style.opacity = '1'
        step.style.transform = 'translateY(0)'
      }, index * 500)
    })
  }
}

onMounted(() => {
  // Header animation
  textReveal(headerRef.value, {
    y: 50,
    duration: 1,
    ease: "power3.out"
  })

  // Features grid animation with scroll trigger
  if (featureRefs.value.length > 0) {
    staggerReveal(featureRefs.value, {
      direction: 'up',
      distance: 60,
      duration: 0.8,
      stagger: 0.15
    })
  }

  // Add magnetic hover and tilt effects to feature cards
  setTimeout(() => {
    if (featureRefs.value.length > 0) {
      featureRefs.value.forEach((card, index) => {
        if (card) {
          // Add magnetic hover effect
          magneticHover(card, { strength: 0.2, range: 50 })
          
          // Add tilt effect
          tiltEffect(card, { maxTilt: 5, perspective: 1000 })
          
          // Add floating animation with delay
          setTimeout(() => {
            floatingAnimation(card, { y: -10, duration: 3 + index * 0.5 })
          }, index * 200)
        }
      })
    }
  }, 1000)

  // Demo section animation
  textReveal(demoRef.value, {
    y: 50,
    duration: 1,
    ease: "power3.out",
    start: "top 80%"
  })

  // Floating animation for demo visual
  if (demoVisualRef.value) {
    floatingAnimation(demoVisualRef.value, {
      y: -10,
      rotation: 2,
      duration: 4
    })
  }
})
</script>

<style scoped>
.features-section {
  padding: 6rem 0;
  background: linear-gradient(135deg, #F8FAFC 0%, #E2E8F0 100%);
  position: relative;
  overflow: hidden;
}

.features-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grid" width="10" height="10" patternUnits="userSpaceOnUse"><path d="M 10 0 L 0 0 0 10" fill="none" stroke="%23E2E8F0" stroke-width="0.5"/></pattern></defs><rect width="100" height="100" fill="url(%23grid)"/></svg>');
  opacity: 0.3;
  z-index: 1;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  position: relative;
  z-index: 2;
}

.section-header {
  text-align: center;
  margin-bottom: 4rem;
}

.section-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  background: rgba(139, 92, 246, 0.1);
  border: 1px solid rgba(139, 92, 246, 0.3);
  border-radius: 50px;
  font-size: 0.875rem;
  font-weight: 500;
  color: #8B5CF6;
  margin-bottom: 1rem;
}

.badge-icon {
  font-size: 1rem;
}

.section-title {
  font-size: 3rem;
  font-weight: 800;
  color: #1E293B;
  margin-bottom: 1rem;
  line-height: 1.2;
}

.gradient-text {
  background: linear-gradient(135deg, #8B5CF6, #06B6D4);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.section-description {
  font-size: 1.25rem;
  color: #64748B;
  max-width: 600px;
  margin: 0 auto;
  line-height: 1.6;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
  gap: 2rem;
  margin-bottom: 6rem;
}

.feature-card {
  background: white;
  border-radius: 20px;
  padding: 2rem;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.8);
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
}

.feature-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: var(--feature-gradient);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.feature-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
}

.feature-card:hover::before {
  opacity: 1;
}

.feature-icon {
  margin-bottom: 1.5rem;
}

.icon-wrapper {
  width: 60px;
  height: 60px;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

.icon {
  font-size: 1.5rem;
}

.feature-content {
  margin-bottom: 1.5rem;
}

.feature-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1E293B;
  margin-bottom: 0.75rem;
}

.feature-description {
  color: #64748B;
  line-height: 1.6;
  margin-bottom: 1rem;
}

.feature-highlights {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.highlight-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.875rem;
  color: #475569;
}

.highlight-icon {
  width: 16px;
  height: 16px;
  background: #10B981;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.75rem;
  font-weight: bold;
}

.feature-visual {
  position: absolute;
  top: 1rem;
  right: 1rem;
  opacity: 0.1;
}

.visual-element {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.visual-content {
  display: flex;
  gap: 2px;
}

.visual-dot {
  width: 4px;
  height: 4px;
  border-radius: 50%;
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 0.3; transform: scale(1); }
  50% { opacity: 1; transform: scale(1.2); }
}

.demo-section {
  background: white;
  border-radius: 24px;
  padding: 4rem 2rem;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.8);
}

.demo-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
  align-items: center;
}

.demo-text {
  color: #1E293B;
}

.demo-title {
  font-size: 2.5rem;
  font-weight: 800;
  margin-bottom: 1rem;
  line-height: 1.2;
}

.demo-description {
  font-size: 1.125rem;
  color: #64748B;
  line-height: 1.6;
  margin-bottom: 2rem;
}

.btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 1rem 2rem;
  border-radius: 12px;
  font-weight: 600;
  font-size: 1rem;
  transition: all 0.3s ease;
  border: none;
  cursor: pointer;
  text-decoration: none;
}

.btn-primary {
  background: linear-gradient(135deg, #8B5CF6, #7C3AED);
  color: white;
  box-shadow: 0 10px 25px rgba(139, 92, 246, 0.3);
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 15px 35px rgba(139, 92, 246, 0.4);
}

.btn-icon {
  width: 20px;
  height: 20px;
}

.demo-visual {
  display: flex;
  justify-content: center;
  align-items: center;
}

.demo-phone {
  width: 200px;
  height: 400px;
  background: #1E293B;
  border-radius: 30px;
  padding: 15px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
}

.demo-screen {
  width: 100%;
  height: 100%;
  background: white;
  border-radius: 20px;
  padding: 1rem;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 1rem;
}

.demo-step {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem;
  background: #F8FAFC;
  border-radius: 8px;
  opacity: 0;
  transform: translateY(20px);
  transition: all 0.5s ease;
}

.step-content {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.step-icon {
  font-size: 1.25rem;
}

.step-text {
  font-size: 0.875rem;
  font-weight: 500;
  color: #1E293B;
}

/* Responsive Design */
@media (max-width: 1024px) {
  .features-grid {
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  }
  
  .demo-content {
    grid-template-columns: 1fr;
    gap: 2rem;
    text-align: center;
  }
}

@media (max-width: 768px) {
  .features-section {
    padding: 4rem 0;
  }
  
  .section-title {
    font-size: 2rem;
  }
  
  .features-grid {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }
  
  .feature-card {
    padding: 1.5rem;
  }
  
  .demo-section {
    padding: 2rem 1rem;
  }
  
  .demo-title {
    font-size: 1.75rem;
  }
}
</style>
