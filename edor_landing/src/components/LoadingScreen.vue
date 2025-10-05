<template>
  <div class="loading-screen" v-if="isLoading" ref="loadingRef">
    <div class="loading-container">
      <!-- Animated Logo -->
      <div class="loading-logo" ref="logoRef">
        <div class="logo-icon">🔧</div>
        <div class="logo-text">Edor</div>
      </div>
      
      <!-- Loading Dots -->
      <div class="loading-dots" ref="dotsRef">
        <div class="loading-dot" v-for="i in 3" :key="i" :class="`dot-${i}`"></div>
      </div>
      
      <!-- Progress Bar -->
      <div class="progress-container" ref="progressRef">
        <div class="progress-bar" ref="progressBarRef"></div>
        <div class="progress-text" ref="progressTextRef">0%</div>
      </div>
      
      <!-- Floating Particles -->
      <div class="loading-particles" ref="particlesRef">
        <div 
          v-for="i in 20" 
          :key="i"
          class="particle"
          :style="{ 
            left: Math.random() * 100 + '%', 
            top: Math.random() * 100 + '%',
            animationDelay: Math.random() * 2 + 's'
          }"
        ></div>
      </div>
      
      <!-- Morphing Shapes -->
      <div class="loading-shapes" ref="shapesRef">
        <div class="shape shape-1" ref="shape1Ref"></div>
        <div class="shape shape-2" ref="shape2Ref"></div>
        <div class="shape shape-3" ref="shape3Ref"></div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { gsap } from 'gsap'
import { useAdvancedAnimations } from '../composables/useAdvancedAnimations'

const { 
  morphingAnimation, 
  breathingAnimation, 
  loadingDots, 
  colorPulse,
  rotate3D 
} = useAdvancedAnimations()

// Props
const props = defineProps({
  isLoading: {
    type: Boolean,
    default: true
  }
})

// Template refs
const loadingRef = ref(null)
const logoRef = ref(null)
const dotsRef = ref(null)
const progressRef = ref(null)
const progressBarRef = ref(null)
const progressTextRef = ref(null)
const particlesRef = ref(null)
const shapesRef = ref(null)
const shape1Ref = ref(null)
const shape2Ref = ref(null)
const shape3Ref = ref(null)

// Progress state
const progress = ref(0)

// Loading animation
const startLoadingAnimation = () => {
  // Logo animation
  if (logoRef.value) {
    gsap.to(logoRef.value, {
      scale: 1.1,
      duration: 2,
      ease: "power2.inOut",
      repeat: -1,
      yoyo: true
    })
  }
  
  // Dots animation
  const dots = dotsRef.value?.querySelectorAll('.loading-dot')
  if (dots) {
    gsap.to(dots, {
      scale: 1.5,
      opacity: 1,
      duration: 0.3,
      ease: "power2.inOut",
      stagger: 0.2,
      repeat: -1,
      yoyo: true
    })
  }
  
  // Progress animation
  let progressInterval = setInterval(() => {
    progress.value += Math.random() * 10 + 5 // Plus rapide et plus prévisible
    if (progress.value >= 100) {
      progress.value = 100
      clearInterval(progressInterval)
      
      // Update final progress
      if (progressBarRef.value) {
        gsap.to(progressBarRef.value, {
          width: '100%',
          duration: 0.3,
          ease: "power2.out"
        })
      }
      
      if (progressTextRef.value) {
        progressTextRef.value.textContent = '100%'
      }
      
      // Hide loading screen after a short delay
      setTimeout(() => {
        if (loadingRef.value) {
          gsap.to(loadingRef.value, {
            opacity: 0,
            scale: 0.9,
            duration: 0.5,
            ease: "power2.inOut",
            onComplete: () => {
              // Emit loaded event
              emit('loaded')
            }
          })
        }
      }, 800)
    } else {
      // Update progress bar and text
      if (progressBarRef.value) {
        gsap.to(progressBarRef.value, {
          width: `${progress.value}%`,
          duration: 0.3,
          ease: "power2.out"
        })
      }
      
      if (progressTextRef.value) {
        progressTextRef.value.textContent = `${Math.round(progress.value)}%`
      }
    }
  }, 150)
  
  // Morphing shapes - simplified animations
  if (shape1Ref.value) {
    gsap.to(shape1Ref.value, {
      borderRadius: '20%',
      scale: 1.2,
      rotation: 180,
      duration: 3,
      ease: "power2.inOut",
      repeat: -1,
      yoyo: true
    })
  }
  
  if (shape2Ref.value) {
    gsap.to(shape2Ref.value, {
      borderRadius: '50%',
      scale: 1.1,
      rotation: -180,
      duration: 4,
      ease: "power2.inOut",
      repeat: -1,
      yoyo: true
    })
  }
  
  if (shape3Ref.value) {
    gsap.to(shape3Ref.value, {
      borderRadius: '0%',
      scale: 1.3,
      rotation: 90,
      duration: 5,
      ease: "power2.inOut",
      repeat: -1,
      yoyo: true
    })
  }
}

// Emit events
const emit = defineEmits(['loaded'])

onMounted(() => {
  startLoadingAnimation()
})
</script>

<style scoped>
.loading-screen {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, #F97316 0%, #8B5CF6 30%, #7C3AED 70%, #1E1B4B 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
  overflow: hidden;
}

.loading-container {
  text-align: center;
  position: relative;
  z-index: 2;
}

.loading-logo {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  margin-bottom: 3rem;
}

.logo-icon {
  font-size: 4rem;
  filter: drop-shadow(0 0 20px rgba(255, 255, 255, 0.3));
}

.logo-text {
  font-family: 'Space Grotesk', sans-serif;
  font-size: 2.5rem;
  font-weight: 800;
  color: white;
  letter-spacing: -0.02em;
  text-shadow: 0 0 30px rgba(255, 255, 255, 0.5);
}

.loading-dots {
  display: flex;
  justify-content: center;
  gap: 0.5rem;
  margin-bottom: 2rem;
}

.loading-dot {
  width: 12px;
  height: 12px;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 50%;
  opacity: 0.3;
}

.progress-container {
  width: 300px;
  margin: 0 auto;
  position: relative;
}

.progress-bar {
  width: 0%;
  height: 4px;
  background: linear-gradient(90deg, #F97316, #8B5CF6, #7C3AED);
  border-radius: 2px;
  box-shadow: 0 0 10px rgba(139, 92, 246, 0.5);
  transition: width 0.3s ease;
}

.progress-text {
  position: absolute;
  top: -2rem;
  right: 0;
  font-family: 'Inter', sans-serif;
  font-size: 0.875rem;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.8);
  letter-spacing: -0.01em;
}

.loading-particles {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 1;
  pointer-events: none;
}

.particle {
  position: absolute;
  width: 2px;
  height: 2px;
  background: rgba(255, 255, 255, 0.6);
  border-radius: 50%;
  animation: particleFloat 4s ease-in-out infinite;
}

@keyframes particleFloat {
  0%, 100% { 
    opacity: 0.3; 
    transform: translateY(0px) scale(1); 
  }
  50% { 
    opacity: 1; 
    transform: translateY(-20px) scale(1.5); 
  }
}

.loading-shapes {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 1;
  pointer-events: none;
}

.shape {
  position: absolute;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.1), rgba(139, 92, 246, 0.1));
  border: 1px solid rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
}

.shape-1 {
  width: 100px;
  height: 100px;
  top: 20%;
  left: 10%;
  border-radius: 50%;
}

.shape-2 {
  width: 80px;
  height: 80px;
  top: 60%;
  right: 15%;
  border-radius: 20%;
}

.shape-3 {
  width: 60px;
  height: 60px;
  bottom: 30%;
  left: 20%;
  border-radius: 0%;
}

/* Responsive Design */
@media (max-width: 768px) {
  .logo-icon {
    font-size: 3rem;
  }
  
  .logo-text {
    font-size: 2rem;
  }
  
  .progress-container {
    width: 250px;
  }
  
  .shape-1 {
    width: 80px;
    height: 80px;
  }
  
  .shape-2 {
    width: 60px;
    height: 60px;
  }
  
  .shape-3 {
    width: 40px;
    height: 40px;
  }
}
</style>
