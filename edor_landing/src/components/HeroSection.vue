<template>
  <section id="hero-section" class="hero-section" ref="heroRef">
    <!-- Background Elements -->
    <div class="hero-background">
      <div class="gradient-orb orb-1" ref="orb1"></div>
      <div class="gradient-orb orb-2" ref="orb2"></div>
      <div class="gradient-orb orb-3" ref="orb3"></div>
      
      <!-- Circular Network -->
      <div class="circular-network" ref="circularNetworkRef">
        <div class="center-stats">
          <div class="main-number" ref="mainNumberRef">20k+</div>
          <div class="main-label" ref="mainLabelRef">Prestataires</div>
        </div>
        
        <!-- Concentric Rings -->
        <div class="ring ring-1" ref="ring1Ref">
          <div 
            v-for="(profile, index) in profiles" 
            :key="index"
            class="profile-item"
            :class="`profile-${index + 1}`"
            :style="{ 
              transform: `rotate(${index * (360 / profiles.length)}deg) translateX(120px) rotate(-${index * (360 / profiles.length)}deg)`,
              animationDelay: `${index * 0.1}s`
            }"
          >
            <div class="profile-avatar" :style="{ background: profile.gradient }">
              <span class="profile-emoji">{{ profile.emoji }}</span>
            </div>
            <div class="profile-aura" :style="{ background: profile.aura }"></div>
          </div>
        </div>
        
        <div class="ring ring-2" ref="ring2Ref">
          <div 
            v-for="(service, index) in services" 
            :key="index"
            class="service-item"
            :class="`service-${index + 1}`"
            :style="{ 
              transform: `rotate(${index * (360 / services.length)}deg) translateX(200px) rotate(-${index * (360 / services.length)}deg)`,
              animationDelay: `${index * 0.15}s`
            }"
          >
            <div class="service-icon" :style="{ background: service.gradient }">
              <span class="service-emoji">{{ service.emoji }}</span>
            </div>
            <div class="service-glow" :style="{ background: service.glow }"></div>
          </div>
        </div>
        
        <div class="ring ring-3" ref="ring3Ref">
          <div 
            v-for="(feature, index) in features" 
            :key="index"
            class="feature-item"
            :class="`feature-${index + 1}`"
            :style="{ 
              transform: `rotate(${index * (360 / features.length)}deg) translateX(280px) rotate(-${index * (360 / features.length)}deg)`,
              animationDelay: `${index * 0.2}s`
            }"
          >
            <div class="feature-badge" :style="{ background: feature.gradient }">
              <span class="feature-emoji">{{ feature.emoji }}</span>
            </div>
            <div class="feature-pulse" :style="{ background: feature.pulse }"></div>
          </div>
        </div>
      </div>
      
      <!-- Floating Elements -->
      <div class="floating-elements" ref="floatingElementsRef">
        <div 
          v-for="i in 20" 
          :key="i"
          class="floating-dot"
          :style="{ 
            left: Math.random() * 100 + '%', 
            top: Math.random() * 100 + '%',
            animationDelay: Math.random() * 5 + 's',
            animationDuration: (3 + Math.random() * 4) + 's'
          }"
        ></div>
      </div>
      
      <!-- Neural Network Connections -->
      <div class="neural-network" ref="neuralNetworkRef">
        <div 
          v-for="i in 15" 
          :key="i"
          class="neural-connection"
          :style="{ 
            left: Math.random() * 100 + '%', 
            top: Math.random() * 100 + '%',
            transform: `rotate(${Math.random() * 360}deg)`,
            animationDelay: Math.random() * 3 + 's'
          }"
        ></div>
      </div>
      
      <!-- Morphing Shapes -->
      <div class="morphing-shapes" ref="morphingShapesRef">
        <div class="morph-shape shape-1" ref="morphShape1"></div>
        <div class="morph-shape shape-2" ref="morphShape2"></div>
        <div class="morph-shape shape-3" ref="morphShape3"></div>
      </div>
      
      <!-- Glitch Text Effect -->
      <div class="glitch-text" ref="glitchTextRef">
        <span class="glitch-line">EDOR</span>
        <span class="glitch-line">EDOR</span>
        <span class="glitch-line">EDOR</span>
      </div>
      
      <!-- Particle System -->
      <div class="particle-system" ref="particleSystemRef"></div>
      
      <!-- Interactive Elements -->
      <div class="interactive-elements">
        <div class="magnetic-button" ref="magneticButtonRef">
          <span>Découvrir</span>
        </div>
        <div class="tilt-card" ref="tiltCardRef">
          <div class="card-content">
            <h3>Innovation</h3>
            <p>Technologie de pointe</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Main Content -->
    <div class="hero-content">
      <div class="container">
        <div class="hero-grid">
          <!-- Left Column - Text Content -->
          <div class="hero-text" ref="textRef">
            <div class="badge" ref="badgeRef">
              <span class="badge-icon">🚀</span>
              <span>Nouvelle génération de services</span>
            </div>
            
            <h1 class="hero-title font-display" ref="titleRef">
              <span class="title-line" ref="titleLine1">Débloquez les meilleurs</span>
              <br>
              <span class="gradient-text title-line" ref="gradientTextRef">Prestataires</span>
              <br>
              <span class="title-line" ref="titleLine2">que vous pensiez</span>
              <br>
              <span class="highlight-text title-line" ref="highlightTextRef">inaccessibles</span>
              <br>
              <span class="title-line" ref="titleLine3">- maintenant à</span>
              <br>
              <span class="cta-text title-line" ref="ctaTextRef">un clic de distance</span>!
            </h1>
            
            <p class="hero-description" ref="descriptionRef">
              Edor révolutionne la façon dont vous trouvez et engagez des prestataires de services. 
              Connectez-vous avec des professionnels qualifiés pour tous vos besoins.
            </p>
            
            <div class="hero-actions" ref="actionsRef">
              <button class="btn btn-primary btn-large" @click="scrollToDownload">
                <span>Commencer un projet</span>
                <svg class="btn-icon" viewBox="0 0 24 24" fill="none">
                  <path d="M5 12H19M19 12L12 5M19 12L12 19" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </button>
              
              <div class="highlight-bubble" ref="highlightBubbleRef">
                <span class="bubble-text">Jean</span>
              </div>
            </div>
            
            <div class="hero-stats" ref="statsRef">
              <div class="stat-item">
                <div class="stat-number">20K+</div>
                <div class="stat-label">Prestataires</div>
              </div>
              <div class="stat-item">
                <div class="stat-number">50K+</div>
                <div class="stat-label">Services</div>
              </div>
              <div class="stat-item">
                <div class="stat-number">4.9★</div>
                <div class="stat-label">Note moyenne</div>
              </div>
            </div>
          </div>
          
          <!-- Right Column - Circular Network Visual -->
          <div class="hero-visual" ref="visualRef">
            <!-- The circular network is now in the background -->
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useGSAP } from '../composables/useGSAP'
import { useAdvancedAnimations } from '../composables/useAdvancedAnimations'
import { useParallaxAnimations } from '../composables/useParallaxAnimations'
import { useParticleSystem } from '../composables/useParticleSystem'
import { useSmoothScroll } from '../composables/useSmoothScroll'
import { useTheme } from '../composables/useTheme'

const { createTimeline, floatingAnimation, particleAnimation, textReveal } = useGSAP()
const { 
  typewriterEffect, 
  morphingAnimation, 
  connectedParticles, 
  glitchEffect, 
  liquidAnimation, 
  breathingAnimation, 
  waveAnimation, 
  rotate3D, 
  colorPulse, 
  textBreakdown, 
  movingGradient,
  mouseFollower 
} = useAdvancedAnimations()

const {
  createParallax,
  revealOnScroll,
  staggerReveal,
  magneticHover,
  tiltEffect,
  floatingAnimation: parallaxFloating,
  rotationAnimation,
  scalePulse,
  colorTransition
} = useParallaxAnimations()

const {
  initParticleSystem,
  createMouseParticles,
  createExplosion,
  createFireworks
} = useParticleSystem()

const {
  createParallaxLayers,
  createSectionTransitions
} = useSmoothScroll()

const { colors, gradients, shadows } = useTheme()

// Template refs
const heroRef = ref(null)
const orb1 = ref(null)
const orb2 = ref(null)
const orb3 = ref(null)
const circularNetworkRef = ref(null)
const mainNumberRef = ref(null)
const mainLabelRef = ref(null)
const ring1Ref = ref(null)
const ring2Ref = ref(null)
const ring3Ref = ref(null)
const floatingElementsRef = ref(null)
const neuralNetworkRef = ref(null)
const morphingShapesRef = ref(null)
const morphShape1 = ref(null)
const morphShape2 = ref(null)
const morphShape3 = ref(null)
const glitchTextRef = ref(null)
const particleSystemRef = ref(null)
const magneticButtonRef = ref(null)
const tiltCardRef = ref(null)
const textRef = ref(null)
const badgeRef = ref(null)
const titleRef = ref(null)
const titleLine1 = ref(null)
const titleLine2 = ref(null)
const titleLine3 = ref(null)
const gradientTextRef = ref(null)
const highlightTextRef = ref(null)
const ctaTextRef = ref(null)
const descriptionRef = ref(null)
const actionsRef = ref(null)
const highlightBubbleRef = ref(null)
const statsRef = ref(null)
const visualRef = ref(null)

// Data for circular network
const profiles = ref([
  { emoji: '👨‍🔧', gradient: 'linear-gradient(135deg, #8B5CF6, #7C3AED)', aura: 'rgba(139, 92, 246, 0.3)' },
  { emoji: '👩‍💻', gradient: 'linear-gradient(135deg, #06B6D4, #0891B2)', aura: 'rgba(6, 182, 212, 0.3)' },
  { emoji: '👨‍🎨', gradient: 'linear-gradient(135deg, #10B981, #059669)', aura: 'rgba(16, 185, 129, 0.3)' },
  { emoji: '👩‍🔬', gradient: 'linear-gradient(135deg, #F59E0B, #D97706)', aura: 'rgba(245, 158, 11, 0.3)' },
  { emoji: '👨‍💼', gradient: 'linear-gradient(135deg, #EF4444, #DC2626)', aura: 'rgba(239, 68, 68, 0.3)' },
  { emoji: '👩‍🏫', gradient: 'linear-gradient(135deg, #6366F1, #4F46E5)', aura: 'rgba(99, 102, 241, 0.3)' }
])

const services = ref([
  { emoji: '🔧', gradient: 'linear-gradient(135deg, #8B5CF6, #7C3AED)', glow: 'rgba(139, 92, 246, 0.4)' },
  { emoji: '⚡', gradient: 'linear-gradient(135deg, #06B6D4, #0891B2)', glow: 'rgba(6, 182, 212, 0.4)' },
  { emoji: '🎨', gradient: 'linear-gradient(135deg, #10B981, #059669)', glow: 'rgba(16, 185, 129, 0.4)' },
  { emoji: '💬', gradient: 'linear-gradient(135deg, #F59E0B, #D97706)', glow: 'rgba(245, 158, 11, 0.4)' },
  { emoji: '👤', gradient: 'linear-gradient(135deg, #EF4444, #DC2626)', glow: 'rgba(239, 68, 68, 0.4)' }
])

const features = ref([
  { emoji: '⭐', gradient: 'linear-gradient(135deg, #8B5CF6, #7C3AED)', pulse: 'rgba(139, 92, 246, 0.2)' },
  { emoji: '💰', gradient: 'linear-gradient(135deg, #06B6D4, #0891B2)', pulse: 'rgba(6, 182, 212, 0.2)' },
  { emoji: '🛡️', gradient: 'linear-gradient(135deg, #10B981, #059669)', pulse: 'rgba(16, 185, 129, 0.2)' },
  { emoji: '📱', gradient: 'linear-gradient(135deg, #F59E0B, #D97706)', pulse: 'rgba(245, 158, 11, 0.2)' }
])

const scrollToDownload = () => {
  document.getElementById('download-section')?.scrollIntoView({ 
    behavior: 'smooth' 
  })
}

const scrollToFeatures = () => {
  document.getElementById('features-section')?.scrollIntoView({ 
    behavior: 'smooth' 
  })
}

onMounted(() => {
  const tl = createTimeline()
  
  // Background orbs animation
  tl.fromTo(orb1.value, 
    { scale: 0, opacity: 0 },
    { scale: 1, opacity: 0.6, duration: 2, ease: "power3.out" }
  )
  .fromTo(orb2.value, 
    { scale: 0, opacity: 0 },
    { scale: 1, opacity: 0.4, duration: 2, ease: "power3.out" },
    "-=1.5"
  )
  .fromTo(orb3.value, 
    { scale: 0, opacity: 0 },
    { scale: 1, opacity: 0.3, duration: 2, ease: "power3.out" },
    "-=1.5"
  )
  
  // Circular network animation
  tl.fromTo(circularNetworkRef.value,
    { opacity: 0, scale: 0.8 },
    { opacity: 1, scale: 1, duration: 1.5, ease: "power3.out" },
    "-=1"
  )
  .fromTo(mainNumberRef.value,
    { opacity: 0, scale: 0.5 },
    { opacity: 1, scale: 1, duration: 1, ease: "back.out(1.7)" },
    "-=1"
  )
  .fromTo(mainLabelRef.value,
    { opacity: 0, y: 20 },
    { opacity: 1, y: 0, duration: 0.8, ease: "power3.out" },
    "-=0.5"
  )
  
  // Rings animation
  tl.fromTo(ring1Ref.value,
    { opacity: 0, rotation: -180 },
    { opacity: 1, rotation: 0, duration: 2, ease: "power3.out" },
    "-=1.5"
  )
  .fromTo(ring2.value,
    { opacity: 0, rotation: 180 },
    { opacity: 1, rotation: 0, duration: 2, ease: "power3.out" },
    "-=1.5"
  )
  .fromTo(ring3.value,
    { opacity: 0, rotation: -90 },
    { opacity: 1, rotation: 0, duration: 2, ease: "power3.out" },
    "-=1.5"
  )
  
  // Text animations with advanced effects
  tl.fromTo(badgeRef.value,
    { opacity: 0, y: 30 },
    { opacity: 1, y: 0, duration: 1, ease: "power3.out" },
    "-=1"
  )
  
  // Animate title lines with typewriter effect
  const titleLines = [titleLine1.value, gradientTextRef.value, titleLine2.value, highlightTextRef.value, titleLine3.value, ctaTextRef.value]
  titleLines.forEach((line, index) => {
    if (line) {
      tl.fromTo(line,
        { opacity: 0, y: 50, rotationX: 90 },
        { opacity: 1, y: 0, rotationX: 0, duration: 0.8, ease: "back.out(1.7)" },
        `-=${0.8 - (index * 0.1)}`
      )
    }
  })
  .fromTo(descriptionRef.value,
    { opacity: 0, y: 30 },
    { opacity: 1, y: 0, duration: 1, ease: "power3.out" },
    "-=0.4"
  )
  .fromTo(actionsRef.value,
    { opacity: 0, y: 30 },
    { opacity: 1, y: 0, duration: 1, ease: "power3.out" },
    "-=0.2"
  )
  .fromTo(highlightBubbleRef.value,
    { opacity: 0, scale: 0, rotation: 180 },
    { opacity: 1, scale: 1, rotation: 0, duration: 0.8, ease: "back.out(1.7)" },
    "-=0.1"
  )
  .fromTo(statsRef.value,
    { opacity: 0, y: 30 },
    { opacity: 1, y: 0, duration: 1, ease: "power3.out" },
    "-=0.2"
  )
  
  // Floating elements animation
  const floatingDots = floatingElementsRef.value?.querySelectorAll('.floating-dot')
  if (floatingDots) {
    floatingDots.forEach((dot, index) => {
      floatingAnimation(dot, { 
        y: -20, 
        rotation: Math.random() * 360, 
        duration: 3 + Math.random() * 2 
      })
    })
  }
  
  // Continuous rotation for rings
  gsap.to(ring1Ref.value, {
    rotation: 360,
    duration: 20,
    ease: "none",
    repeat: -1
  })
  
  gsap.to(ring2.value, {
    rotation: -360,
    duration: 25,
    ease: "none",
    repeat: -1
  })
  
  gsap.to(ring3.value, {
    rotation: 360,
    duration: 30,
    ease: "none",
    repeat: -1
  })
  
  // Advanced animations
  setTimeout(() => {
    // Morphing shapes animation
    if (morphShape1.value) {
      morphingAnimation(morphShape1.value, [
        { borderRadius: '50%', scale: 1 },
        { borderRadius: '20%', scale: 1.2 },
        { borderRadius: '0%', scale: 0.8 }
      ], { duration: 4 })
    }
    
    if (morphShape2.value) {
      morphingAnimation(morphShape2.value, [
        { borderRadius: '0%', scale: 1 },
        { borderRadius: '50%', scale: 1.1 },
        { borderRadius: '30%', scale: 0.9 }
      ], { duration: 5 })
    }
    
    if (morphShape3.value) {
      morphingAnimation(morphShape3.value, [
        { borderRadius: '30%', scale: 1 },
        { borderRadius: '0%', scale: 1.3 },
        { borderRadius: '50%', scale: 0.7 }
      ], { duration: 6 })
    }
    
    // Glitch effect for glitch text
    if (glitchTextRef.value) {
      glitchEffect(glitchTextRef.value, { repeatDelay: 4 })
    }
    
    // Neural network connections
    const neuralConnections = neuralNetworkRef.value?.querySelectorAll('.neural-connection')
    if (neuralConnections) {
      connectedParticles(neuralConnections, { duration: 3 })
    }
    
    // Breathing animation for main number
    if (mainNumberRef.value) {
      breathingAnimation(mainNumberRef.value, { duration: 2 })
    }
    
    // Liquid animation for highlight bubble
    if (highlightBubbleRef.value) {
      liquidAnimation(highlightBubbleRef.value, { duration: 3 })
    }
    
    // Color pulse for gradient text
    if (gradientTextRef.value) {
      colorPulse(gradientTextRef.value, [
        'rgba(249, 115, 22, 0.8)',
        'rgba(251, 191, 36, 0.8)',
        'rgba(139, 92, 246, 0.8)',
        'rgba(124, 58, 237, 0.8)'
      ], { duration: 2 })
    }
    
    // Mouse follower for floating dots
    const floatingDots = floatingElementsRef.value?.querySelectorAll('.floating-dot')
    if (floatingDots) {
      mouseFollower(floatingDots, {})
    }
    
    // Moving gradient for background
    if (heroRef.value) {
      movingGradient(heroRef.value, [
        '#F97316',
        '#8B5CF6',
        '#7C3AED',
        '#1E1B4B'
      ], { duration: 8 })
    }
    
    // Initialize particle system
    if (particleSystemRef.value) {
      initParticleSystem(particleSystemRef.value, {
        particleCount: 30,
        colors: ['#8B5CF6', '#06B6D4', '#10B981', '#F59E0B', '#EF4444'],
        types: ['circle', 'star', 'square']
      })
    }
    
    // Magnetic hover effect for button
    if (magneticButtonRef.value) {
      magneticHover(magneticButtonRef.value, { strength: 0.5, range: 100 })
    }
    
    // Tilt effect for card
    if (tiltCardRef.value) {
      tiltEffect(tiltCardRef.value, { maxTilt: 20, perspective: 1000 })
    }
    
    // Mouse particles for hero section
    if (heroRef.value) {
      createMouseParticles(heroRef.value, {
        count: 5,
        colors: ['#8B5CF6', '#06B6D4', '#10B981'],
        speed: 3
      })
    }
    
    // Advanced parallax layers with different speeds
    const parallaxLayers = [
      { element: orb1.value, speed: 0.2 },
      { element: orb2.value, speed: 0.4 },
      { element: orb3.value, speed: 0.6 },
      { element: circularNetworkRef.value, speed: 0.3 },
      { element: morphShape1.value, speed: 0.5 },
      { element: morphShape2.value, speed: 0.7 },
      { element: morphShape3.value, speed: 0.9 }
    ].filter(layer => layer.element)

    createParallaxLayers(parallaxLayers, {
      baseSpeed: 0.3,
      speedVariation: 0.2,
      direction: 'both'
    })
    
    // Floating animations for shapes
    if (morphShape1.value) {
      parallaxFloating(morphShape1.value, { amplitude: 30, duration: 4 })
    }
    if (morphShape2.value) {
      parallaxFloating(morphShape2.value, { amplitude: 25, duration: 5 })
    }
    if (morphShape3.value) {
      parallaxFloating(morphShape3.value, { amplitude: 20, duration: 6 })
    }
    
    // Scale pulse for main number
    if (mainNumberRef.value) {
      scalePulse(mainNumberRef.value, { scale: 1.1, duration: 2 })
    }
    
    // Color transition for gradient text
    if (gradientTextRef.value) {
      colorTransition(gradientTextRef.value, [
        'rgba(249, 115, 22, 0.8)',
        'rgba(251, 191, 36, 0.8)',
        'rgba(139, 92, 246, 0.8)',
        'rgba(124, 58, 237, 0.8)'
      ], { duration: 3 })
    }
    
    // Create fireworks on click
    if (heroRef.value) {
      heroRef.value.addEventListener('click', (e) => {
        createFireworks(e.clientX, e.clientY, {
          count: 2,
          colors: ['#8B5CF6', '#06B6D4', '#10B981', '#F59E0B']
        })
      })
    }
  }, 2000)
})
</script>

<style scoped>
.hero-section {
  position: relative;
  min-height: 100vh;
  display: flex;
  align-items: center;
  overflow: hidden;
  background: linear-gradient(135deg, #F97316 0%, #8B5CF6 30%, #7C3AED 70%, #1E1B4B 100%);
}

.hero-background {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 1;
}

.gradient-orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(60px);
  opacity: 0.6;
}

.orb-1 {
  width: 400px;
  height: 400px;
  background: linear-gradient(135deg, #8B5CF6, #7C3AED);
  top: -200px;
  right: -200px;
}

.orb-2 {
  width: 300px;
  height: 300px;
  background: linear-gradient(135deg, #06B6D4, #0891B2);
  bottom: -150px;
  left: -150px;
}

.orb-3 {
  width: 200px;
  height: 200px;
  background: linear-gradient(135deg, #10B981, #059669);
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.particles {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
}

.particle {
  position: absolute;
  width: 2px;
  height: 2px;
  background: #8B5CF6;
  border-radius: 50%;
  animation: float 6s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0px) rotate(0deg); opacity: 0.7; }
  50% { transform: translateY(-20px) rotate(180deg); opacity: 1; }
}

/* Circular Network Styles */
.circular-network {
  position: absolute;
  top: 50%;
  right: 10%;
  transform: translateY(-50%);
  width: 600px;
  height: 600px;
  z-index: 2;
}

.center-stats {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  text-align: center;
  z-index: 10;
}

.main-number {
  font-size: 4rem;
  font-weight: 900;
  color: white;
  line-height: 1;
  margin-bottom: 0.5rem;
  text-shadow: 0 0 20px rgba(255, 255, 255, 0.5);
}

.main-label {
  font-size: 1.25rem;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.9);
  text-shadow: 0 0 10px rgba(255, 255, 255, 0.3);
}

.ring {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 100%;
  height: 100%;
}

.ring-1 {
  width: 240px;
  height: 240px;
}

.ring-2 {
  width: 400px;
  height: 400px;
}

.ring-3 {
  width: 560px;
  height: 560px;
}

.profile-item, .service-item, .feature-item {
  position: absolute;
  top: 50%;
  left: 50%;
  transform-origin: center;
}

.profile-avatar, .service-icon, .feature-badge {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  z-index: 3;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
  border: 3px solid rgba(255, 255, 255, 0.2);
}

.service-icon, .feature-badge {
  width: 40px;
  height: 40px;
  border-radius: 12px;
}

.profile-emoji, .service-emoji, .feature-emoji {
  font-size: 1.5rem;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
}

.service-emoji, .feature-emoji {
  font-size: 1.25rem;
}

.profile-aura, .service-glow, .feature-pulse {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  border-radius: 50%;
  z-index: 1;
  animation: pulse 2s ease-in-out infinite;
}

.profile-aura {
  width: 80px;
  height: 80px;
  filter: blur(10px);
}

.service-glow {
  width: 60px;
  height: 60px;
  border-radius: 12px;
  filter: blur(8px);
}

.feature-pulse {
  width: 50px;
  height: 50px;
  border-radius: 12px;
  filter: blur(6px);
}

@keyframes pulse {
  0%, 100% { 
    opacity: 0.3; 
    transform: translate(-50%, -50%) scale(1); 
  }
  50% { 
    opacity: 0.8; 
    transform: translate(-50%, -50%) scale(1.2); 
  }
}

.floating-elements {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 1;
}

.floating-dot {
  position: absolute;
  width: 3px;
  height: 3px;
  background: rgba(255, 255, 255, 0.6);
  border-radius: 50%;
  animation: float 6s ease-in-out infinite;
}

/* Neural Network Styles */
.neural-network {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 1;
  pointer-events: none;
}

.neural-connection {
  position: absolute;
  width: 2px;
  height: 100px;
  background: linear-gradient(180deg, transparent, rgba(139, 92, 246, 0.3), transparent);
  animation: neuralPulse 3s ease-in-out infinite;
}

@keyframes neuralPulse {
  0%, 100% { 
    opacity: 0.3; 
    transform: scaleY(1); 
  }
  50% { 
    opacity: 0.8; 
    transform: scaleY(1.5); 
  }
}

/* Morphing Shapes */
.morphing-shapes {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 1;
  pointer-events: none;
}

.morph-shape {
  position: absolute;
  background: linear-gradient(135deg, rgba(139, 92, 246, 0.1), rgba(6, 182, 212, 0.1));
  border: 1px solid rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
}

.shape-1 {
  width: 200px;
  height: 200px;
  top: 10%;
  left: 5%;
  border-radius: 50%;
}

.shape-2 {
  width: 150px;
  height: 150px;
  top: 60%;
  right: 10%;
  border-radius: 20%;
}

.shape-3 {
  width: 100px;
  height: 100px;
  bottom: 20%;
  left: 20%;
  border-radius: 0%;
}

/* Glitch Text Effect */
.glitch-text {
  position: absolute;
  top: 20%;
  left: 10%;
  z-index: 1;
  pointer-events: none;
}

.glitch-line {
  position: absolute;
  font-family: 'Space Grotesk', monospace;
  font-size: 2rem;
  font-weight: 900;
  color: rgba(255, 255, 255, 0.1);
  text-shadow: 0 0 10px rgba(139, 92, 246, 0.3);
  transform: translateZ(0);
}

.glitch-line:nth-child(1) {
  color: rgba(249, 115, 22, 0.2);
  transform: translate(-2px, -2px);
}

.glitch-line:nth-child(2) {
  color: rgba(139, 92, 246, 0.2);
  transform: translate(2px, 2px);
}

.glitch-line:nth-child(3) {
  color: rgba(6, 182, 212, 0.2);
  transform: translate(-1px, 1px);
}

/* Title Line Animations */
.title-line {
  display: inline-block;
  transform-origin: center;
}

/* Particle System */
.particle-system {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 1;
  pointer-events: none;
  overflow: hidden;
}

/* Interactive Elements */
.interactive-elements {
  position: absolute;
  top: 20%;
  left: 5%;
  z-index: 3;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.magnetic-button {
  padding: 1rem 2rem;
  background: linear-gradient(135deg, #8B5CF6, #7C3AED);
  color: white;
  border-radius: 50px;
  font-family: 'Inter', sans-serif;
  font-weight: 600;
  font-size: 1rem;
  cursor: pointer;
  box-shadow: 0 10px 25px rgba(139, 92, 246, 0.3);
  border: 2px solid rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
  user-select: none;
}

.magnetic-button:hover {
  box-shadow: 0 15px 35px rgba(139, 92, 246, 0.4);
  transform: translateY(-2px);
}

.tilt-card {
  width: 200px;
  height: 120px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 16px;
  backdrop-filter: blur(20px);
  padding: 1.5rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.tilt-card:hover {
  background: rgba(255, 255, 255, 0.15);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
}

.card-content h3 {
  font-family: 'Space Grotesk', sans-serif;
  font-size: 1.25rem;
  font-weight: 700;
  color: white;
  margin-bottom: 0.5rem;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.card-content p {
  font-family: 'Inter', sans-serif;
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.8);
  line-height: 1.4;
}

.hero-content {
  position: relative;
  z-index: 2;
  width: 100%;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

.hero-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
  align-items: center;
}

.hero-text {
  color: white;
}

.badge {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  background: rgba(139, 92, 246, 0.1);
  border: 1px solid rgba(139, 92, 246, 0.3);
  border-radius: 50px;
  font-size: 0.875rem;
  font-weight: 500;
  margin-bottom: 2rem;
}

.badge-icon {
  font-size: 1rem;
}

.hero-title {
  font-size: 3.5rem;
  font-weight: 800;
  line-height: 1.1;
  margin-bottom: 1.5rem;
  letter-spacing: -0.02em;
  color: white;
}

.gradient-text {
  background: linear-gradient(135deg, #F97316, #FBBF24);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-shadow: 0 0 30px rgba(249, 115, 22, 0.5);
}

.highlight-text {
  background: linear-gradient(135deg, #8B5CF6, #7C3AED);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-shadow: 0 0 30px rgba(139, 92, 246, 0.5);
}

.cta-text {
  background: linear-gradient(135deg, #10B981, #059669);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-shadow: 0 0 30px rgba(16, 185, 129, 0.5);
}

.hero-description {
  font-size: 1.25rem;
  line-height: 1.6;
  color: #94A3B8;
  margin-bottom: 2.5rem;
  max-width: 500px;
}

.hero-actions {
  display: flex;
  gap: 1rem;
  margin-bottom: 3rem;
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

.btn-large {
  padding: 1.25rem 2.5rem;
  font-size: 1.125rem;
  font-weight: 700;
}

.highlight-bubble {
  position: absolute;
  top: -10px;
  right: -20px;
  background: linear-gradient(135deg, #8B5CF6, #7C3AED);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-size: 0.875rem;
  font-weight: 600;
  box-shadow: 0 8px 25px rgba(139, 92, 246, 0.4);
  border: 2px solid rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
  animation: float 3s ease-in-out infinite;
}

.bubble-text {
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.btn-secondary {
  background: rgba(255, 255, 255, 0.1);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
}

.btn-secondary:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
}

.btn-icon {
  width: 20px;
  height: 20px;
}

.hero-stats {
  display: flex;
  gap: 2rem;
}

.stat-item {
  text-align: center;
}

.stat-number {
  font-size: 2rem;
  font-weight: 800;
  color: #8B5CF6;
  margin-bottom: 0.25rem;
}

.stat-label {
  font-size: 0.875rem;
  color: #94A3B8;
  font-weight: 500;
}

.hero-visual {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
}

.phone-mockup {
  position: relative;
  width: 300px;
  height: 600px;
  background: #1E293B;
  border-radius: 40px;
  padding: 20px;
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.5);
  border: 2px solid #334155;
}

.phone-screen {
  width: 100%;
  height: 100%;
  background: white;
  border-radius: 30px;
  overflow: hidden;
  position: relative;
}

.app-interface {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.app-header {
  background: #8B5CF6;
  color: white;
  padding: 1rem;
}

.status-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.75rem;
  margin-bottom: 0.5rem;
}

.status-icons {
  display: flex;
  gap: 0.25rem;
}

.app-title {
  font-size: 1.25rem;
  font-weight: 700;
  text-align: center;
}

.app-content {
  flex: 1;
  padding: 1rem;
  background: #F8FAFC;
}

.search-bar {
  margin-bottom: 1rem;
}

.search-bar input {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #E2E8F0;
  border-radius: 8px;
  font-size: 0.875rem;
}

.service-cards {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.service-card {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.service-icon {
  font-size: 1.5rem;
}

.service-info h4 {
  font-size: 0.875rem;
  font-weight: 600;
  margin: 0 0 0.25rem 0;
}

.service-info p {
  font-size: 0.75rem;
  color: #64748B;
  margin: 0;
}

.service-rating {
  font-size: 0.75rem;
  color: #F59E0B;
  margin-left: auto;
}

.floating-element {
  position: absolute;
  z-index: 3;
}

.element-1 {
  top: 10%;
  right: 10%;
}

.element-2 {
  bottom: 20%;
  left: 5%;
}

.element-3 {
  top: 60%;
  right: 5%;
}

.floating-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  padding: 0.75rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: white;
  font-size: 0.875rem;
  font-weight: 500;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
}

.card-icon {
  font-size: 1.25rem;
}

/* Responsive Design */
@media (max-width: 1024px) {
  .hero-grid {
    grid-template-columns: 1fr;
    gap: 3rem;
    text-align: center;
  }
  
  .hero-title {
    font-size: 2.5rem;
  }
  
  .circular-network {
    right: 5%;
    width: 400px;
    height: 400px;
  }
  
  .ring-1 {
    width: 160px;
    height: 160px;
  }
  
  .ring-2 {
    width: 260px;
    height: 260px;
  }
  
  .ring-3 {
    width: 360px;
    height: 360px;
  }
  
  .main-number {
    font-size: 3rem;
  }
}

@media (max-width: 768px) {
  .hero-title {
    font-size: 2rem;
  }
  
  .hero-description {
    font-size: 1rem;
  }
  
  .hero-actions {
    flex-direction: column;
    align-items: center;
  }
  
  .hero-stats {
    justify-content: center;
  }
  
  .circular-network {
    right: 2%;
    width: 300px;
    height: 300px;
  }
  
  .ring-1 {
    width: 120px;
    height: 120px;
  }
  
  .ring-2 {
    width: 200px;
    height: 200px;
  }
  
  .ring-3 {
    width: 280px;
    height: 280px;
  }
  
  .main-number {
    font-size: 2.5rem;
  }
  
  .profile-avatar, .service-icon, .feature-badge {
    width: 35px;
    height: 35px;
  }
  
  .service-icon, .feature-badge {
    width: 30px;
    height: 30px;
  }
  
  .profile-emoji, .service-emoji, .feature-emoji {
    font-size: 1.25rem;
  }
  
  .service-emoji, .feature-emoji {
    font-size: 1rem;
  }
}

@media (max-width: 480px) {
  .circular-network {
    display: none;
  }
  
  .hero-title {
    font-size: 1.75rem;
  }
  
  .highlight-bubble {
    position: static;
    margin-top: 1rem;
    align-self: center;
  }
  
  .interactive-elements {
    display: none;
  }
  
  .glitch-text {
    display: none;
  }
  
  .morphing-shapes {
    display: none;
  }
}
</style>
