<template>
  <div class="scroll-indicator" ref="indicatorRef">
    <!-- Scroll Progress Circle -->
    <div class="progress-circle" ref="progressCircleRef">
      <svg class="progress-ring" width="60" height="60">
        <circle
          class="progress-ring-circle"
          stroke="rgba(255, 255, 255, 0.2)"
          stroke-width="2"
          fill="transparent"
          r="28"
          cx="30"
          cy="30"
        />
        <circle
          class="progress-ring-fill"
          stroke="url(#gradient)"
          stroke-width="2"
          fill="transparent"
          r="28"
          cx="30"
          cy="30"
          :style="{ strokeDasharray: circumference, strokeDashoffset: strokeDashoffset }"
        />
        <defs>
          <linearGradient id="gradient" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style="stop-color:#F97316;stop-opacity:1" />
            <stop offset="50%" style="stop-color:#8B5CF6;stop-opacity:1" />
            <stop offset="100%" style="stop-color:#7C3AED;stop-opacity:1" />
          </linearGradient>
        </defs>
      </svg>
    </div>
    
    <!-- Scroll Direction Arrow -->
    <div class="direction-arrow" :class="{ 'up': scrollDirection === 'up' }" ref="arrowRef">
      <svg viewBox="0 0 24 24" fill="none">
        <path d="M12 5L12 19M12 19L5 12M12 19L19 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>
    </div>
    
    <!-- Scroll Velocity Bars -->
    <div class="velocity-bars" ref="velocityBarsRef">
      <div 
        v-for="i in 5" 
        :key="i"
        class="velocity-bar"
        :class="{ active: i <= velocityLevel }"
        :style="{ animationDelay: `${i * 0.1}s` }"
      ></div>
    </div>
    
    <!-- Scroll Hint Text -->
    <div class="scroll-hint" ref="hintRef">
      <span class="hint-text">{{ hintText }}</span>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, watch } from 'vue'
import { gsap } from 'gsap'

// Props
const props = defineProps({
  scrollProgress: {
    type: Number,
    default: 0
  },
  scrollDirection: {
    type: String,
    default: 'down'
  },
  scrollVelocity: {
    type: Number,
    default: 0
  },
  isScrolling: {
    type: Boolean,
    default: false
  }
})

// Template refs
const indicatorRef = ref(null)
const progressCircleRef = ref(null)
const arrowRef = ref(null)
const velocityBarsRef = ref(null)
const hintRef = ref(null)

// Computed properties
const circumference = computed(() => 2 * Math.PI * 28)
const strokeDashoffset = computed(() => circumference.value - (props.scrollProgress * circumference.value))
const velocityLevel = computed(() => Math.min(Math.floor(props.scrollVelocity * 10), 5))
const hintText = computed(() => {
  if (props.scrollProgress < 0.1) return 'Scroll down'
  if (props.scrollProgress > 0.9) return 'Scroll up'
  return props.scrollDirection === 'down' ? 'Keep scrolling' : 'Going up'
})

// Animation timeline
let animationTimeline = null

// Initialize animations
onMounted(() => {
  // Create animation timeline
  animationTimeline = gsap.timeline({ repeat: -1, yoyo: true })
  
  // Animate progress circle
  if (progressCircleRef.value) {
    gsap.to(progressCircleRef.value, {
      rotation: 360,
      duration: 20,
      ease: 'none',
      repeat: -1
    })
  }
  
  // Animate direction arrow
  if (arrowRef.value) {
    gsap.to(arrowRef.value, {
      y: -5,
      duration: 2,
      ease: 'power2.inOut',
      repeat: -1,
      yoyo: true
    })
  }
  
  // Animate velocity bars
  if (velocityBarsRef.value) {
    const bars = velocityBarsRef.value.querySelectorAll('.velocity-bar')
    bars.forEach((bar, index) => {
      gsap.to(bar, {
        scaleY: 1.2,
        duration: 0.5,
        ease: 'power2.inOut',
        repeat: -1,
        yoyo: true,
        delay: index * 0.1
      })
    })
  }
  
  // Animate hint text
  if (hintRef.value) {
    gsap.to(hintRef.value, {
      opacity: 0.7,
      duration: 3,
      ease: 'power2.inOut',
      repeat: -1,
      yoyo: true
    })
  }
})

// Watch scroll direction changes
watch(() => props.scrollDirection, (newDirection) => {
  if (arrowRef.value) {
    gsap.to(arrowRef.value, {
      rotation: newDirection === 'up' ? 180 : 0,
      duration: 0.5,
      ease: 'power2.out'
    })
  }
})

// Watch scroll velocity changes
watch(() => props.scrollVelocity, (newVelocity) => {
  if (velocityBarsRef.value) {
    const bars = velocityBarsRef.value.querySelectorAll('.velocity-bar')
    bars.forEach((bar, index) => {
      if (index < velocityLevel.value) {
        gsap.to(bar, {
          scaleY: 1 + (newVelocity * 0.1),
          duration: 0.1,
          ease: 'power2.out'
        })
      } else {
        gsap.to(bar, {
          scaleY: 0.5,
          duration: 0.1,
          ease: 'power2.out'
        })
      }
    })
  }
})

// Watch scrolling state
watch(() => props.isScrolling, (isScrolling) => {
  if (indicatorRef.value) {
    gsap.to(indicatorRef.value, {
      scale: isScrolling ? 1.1 : 1,
      duration: 0.3,
      ease: 'power2.out'
    })
  }
})

// Cleanup
onUnmounted(() => {
  if (animationTimeline) {
    animationTimeline.kill()
  }
})
</script>

<style scoped>
.scroll-indicator {
  position: fixed;
  right: 2rem;
  top: 50%;
  transform: translateY(-50%);
  width: 60px;
  height: 60px;
  z-index: 1000;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.progress-circle {
  position: relative;
  width: 60px;
  height: 60px;
}

.progress-ring {
  transform: rotate(-90deg);
  filter: drop-shadow(0 0 10px rgba(139, 92, 246, 0.3));
}

.progress-ring-circle {
  transition: stroke-dashoffset 0.1s ease;
}

.progress-ring-fill {
  transition: stroke-dashoffset 0.1s ease;
  filter: drop-shadow(0 0 5px rgba(139, 92, 246, 0.5));
}

.direction-arrow {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 20px;
  height: 20px;
  color: white;
  transition: all 0.3s ease;
}

.direction-arrow.up {
  transform: translate(-50%, -50%) rotate(180deg);
}

.velocity-bars {
  position: absolute;
  right: -30px;
  top: 50%;
  transform: translateY(-50%);
  display: flex;
  flex-direction: column;
  gap: 2px;
  height: 40px;
  justify-content: center;
}

.velocity-bar {
  width: 3px;
  height: 8px;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 2px;
  transition: all 0.1s ease;
  transform-origin: center;
}

.velocity-bar.active {
  background: linear-gradient(180deg, #F97316, #8B5CF6);
  box-shadow: 0 0 5px rgba(139, 92, 246, 0.5);
}

.scroll-hint {
  position: absolute;
  right: -120px;
  top: 50%;
  transform: translateY(-50%);
  background: rgba(0, 0, 0, 0.8);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-size: 0.75rem;
  font-weight: 500;
  white-space: nowrap;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.scroll-indicator:hover .scroll-hint {
  opacity: 1;
}

.hint-text {
  font-family: 'Inter', sans-serif;
  letter-spacing: -0.01em;
}

/* Responsive Design */
@media (max-width: 768px) {
  .scroll-indicator {
    right: 1rem;
    width: 50px;
    height: 50px;
  }
  
  .progress-circle {
    width: 50px;
    height: 50px;
  }
  
  .progress-ring {
    width: 50px;
    height: 50px;
  }
  
  .progress-ring-circle,
  .progress-ring-fill {
    r: 23;
    cx: 25;
    cy: 25;
  }
  
  .direction-arrow {
    width: 16px;
    height: 16px;
  }
  
  .velocity-bars {
    right: -25px;
    height: 30px;
  }
  
  .velocity-bar {
    width: 2px;
    height: 6px;
  }
  
  .scroll-hint {
    right: -100px;
    font-size: 0.7rem;
    padding: 0.4rem 0.8rem;
  }
}

@media (max-width: 480px) {
  .scroll-indicator {
    display: none;
  }
}
</style>





