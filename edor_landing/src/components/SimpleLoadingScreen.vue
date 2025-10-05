<template>
  <div class="loading-screen" v-if="isLoading" ref="loadingRef">
    <div class="loading-container">
      <!-- Animated Logo -->
      <div class="loading-logo" ref="logoRef">
        <div class="logo-icon">🔧</div>
        <div class="logo-text">Edor</div>
      </div>
      
      <!-- Loading Dots -->
      <div class="loading-dots">
        <div class="loading-dot dot-1"></div>
        <div class="loading-dot dot-2"></div>
        <div class="loading-dot dot-3"></div>
      </div>
      
      <!-- Progress Bar -->
      <div class="progress-container">
        <div class="progress-bar" ref="progressBarRef"></div>
        <div class="progress-text" ref="progressTextRef">0%</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { gsap } from 'gsap'

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
const progressBarRef = ref(null)
const progressTextRef = ref(null)

// Progress state
const progress = ref(0)

// Emit events
const emit = defineEmits(['loaded'])

onMounted(() => {
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
  
  // Progress animation
  let progressInterval = setInterval(() => {
    progress.value += Math.random() * 15 + 10
    
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
              emit('loaded')
            }
          })
        }
      }, 500)
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
  }, 100)
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
  animation: dotPulse 1.4s ease-in-out infinite both;
}

.dot-1 {
  animation-delay: -0.32s;
}

.dot-2 {
  animation-delay: -0.16s;
}

.dot-3 {
  animation-delay: 0s;
}

@keyframes dotPulse {
  0%, 80%, 100% {
    transform: scale(0);
    opacity: 0.3;
  }
  40% {
    transform: scale(1);
    opacity: 1;
  }
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
}
</style>





