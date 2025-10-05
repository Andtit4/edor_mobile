<template>
  <div class="smooth-scroll-wrapper" ref="scrollWrapperRef">
    <!-- Scroll Progress Bar -->
    <div class="scroll-progress" ref="progressBarRef"></div>
    
    <!-- Advanced Scroll Indicator -->
    <ScrollIndicator 
      :scroll-progress="scrollProgress"
      :scroll-direction="scrollDirection"
      :scroll-velocity="scrollVelocity"
      :is-scrolling="isScrolling"
    />
    
    <!-- Scroll Velocity Indicator -->
    <div class="velocity-indicator" v-if="showVelocity" ref="velocityRef">
      <div class="velocity-bar" :style="{ height: `${Math.min(scrollVelocity * 10, 100)}%` }"></div>
    </div>
    
    <!-- Main Content -->
    <div class="scroll-content" ref="scrollContentRef">
      <slot />
    </div>
    
    <!-- Scroll Snap Points -->
    <div class="scroll-snap-points" ref="snapPointsRef">
      <div 
        v-for="(point, index) in snapPoints" 
        :key="index"
        class="snap-point"
        :class="{ active: currentSnapPoint === index }"
        @click="snapToPoint(index)"
      ></div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch } from 'vue'
import { useSmoothScroll } from '../composables/useSmoothScroll'
import ScrollIndicator from './ScrollIndicator.vue'

// Props
const props = defineProps({
  showVelocity: {
    type: Boolean,
    default: false
  },
  snapPoints: {
    type: Array,
    default: () => []
  }
})

// Composables
const {
  scrollContainer,
  scrollContent,
  isScrolling,
  scrollDirection,
  scrollProgress,
  scrollVelocity,
  initSmoothScroll,
  createParallaxLayers,
  createSectionTransitions,
  createMomentumScroll,
  createScrollProgress,
  createScrollSnap,
  smoothScrollTo,
  cleanup
} = useSmoothScroll()

// Template refs
const scrollWrapperRef = ref(null)
const progressBarRef = ref(null)
const indicatorRef = ref(null)
const velocityRef = ref(null)
const scrollContentRef = ref(null)
const snapPointsRef = ref(null)

// State
const currentSnapPoint = ref(0)

// Initialize smooth scroll
onMounted(() => {
  // Set up smooth scroll container
  scrollContainer.value = scrollWrapperRef.value
  scrollContent.value = scrollContentRef.value

  // Initialize smooth scroll
  initSmoothScroll({
    smoothness: 0.08,
    momentum: 0.85,
    friction: 0.92,
    minVelocity: 0.05,
    maxVelocity: 30
  })

  // Create scroll progress bar
  if (progressBarRef.value) {
    createScrollProgress(progressBarRef.value, {
      position: 'top',
      height: '3px',
      color: 'linear-gradient(90deg, #F97316, #8B5CF6, #7C3AED)',
      zIndex: 1000
    })
  }

  // Create momentum scroll
  if (scrollWrapperRef.value) {
    createMomentumScroll(scrollWrapperRef.value, {
      momentum: 0.9,
      friction: 0.95,
      minVelocity: 0.1
    })
  }

  // Set up scroll snap if snap points are provided
  if (props.snapPoints.length > 0) {
    const sections = props.snapPoints.map(point => ({
      element: document.querySelector(point.selector)
    })).filter(section => section.element)

    if (sections.length > 0) {
      createScrollSnap(sections, {
        snapDuration: 1.2,
        snapEase: 'power3.inOut',
        snapDelay: 0.1
      })
    }
  }

  // Add scroll event listeners
  const handleScroll = () => {
    // Update snap point indicator
    if (props.snapPoints.length > 0) {
      const scrollY = window.scrollY
      const windowHeight = window.innerHeight
      
      props.snapPoints.forEach((point, index) => {
        const element = document.querySelector(point.selector)
        if (element) {
          const rect = element.getBoundingClientRect()
          if (rect.top <= windowHeight / 2 && rect.bottom >= windowHeight / 2) {
            currentSnapPoint.value = index
          }
        }
      })
    }
  }

  window.addEventListener('scroll', handleScroll, { passive: true })
  
  // Cleanup function
  const cleanupScroll = () => {
    window.removeEventListener('scroll', handleScroll)
  }

  onUnmounted(() => {
    cleanup()
    cleanupScroll()
  })
})

// Methods
const snapToPoint = (index) => {
  if (props.snapPoints[index]) {
    const element = document.querySelector(props.snapPoints[index].selector)
    if (element) {
      smoothScrollTo(element, {
        duration: 1.2,
        ease: 'power3.inOut',
        offset: -100
      })
    }
  }
}

// Watch scroll direction for indicator animation
watch(scrollDirection, (newDirection) => {
  if (indicatorRef.value) {
    gsap.to(indicatorRef.value, {
      rotation: newDirection === 'up' ? 180 : 0,
      duration: 0.3,
      ease: 'power2.out'
    })
  }
})

// Watch scroll velocity for velocity indicator
watch(scrollVelocity, (newVelocity) => {
  if (velocityRef.value && props.showVelocity) {
    gsap.to(velocityRef.value, {
      scaleY: Math.min(newVelocity * 0.1, 2),
      duration: 0.1,
      ease: 'power2.out'
    })
  }
})
</script>

<style scoped>
.smooth-scroll-wrapper {
  position: relative;
  height: 100vh;
  overflow: hidden;
  background: linear-gradient(135deg, #0F172A 0%, #1E293B 50%, #334155 100%);
}

.scroll-progress {
  position: fixed;
  top: 0;
  left: 0;
  width: 0%;
  height: 3px;
  background: linear-gradient(90deg, #F97316, #8B5CF6, #7C3AED);
  z-index: 1000;
  transition: width 0.1s ease;
  box-shadow: 0 0 10px rgba(139, 92, 246, 0.5);
}

.scroll-indicator {
  position: fixed;
  right: 2rem;
  top: 50%;
  transform: translateY(-50%);
  width: 50px;
  height: 50px;
  background: rgba(255, 255, 255, 0.1);
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  backdrop-filter: blur(10px);
  z-index: 999;
  transition: all 0.3s ease;
  cursor: pointer;
}

.scroll-indicator:hover {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.4);
  transform: translateY(-50%) scale(1.1);
}

.scroll-indicator.scrolling-up {
  transform: translateY(-50%) rotate(180deg);
}

.indicator-arrow {
  width: 20px;
  height: 20px;
  color: white;
}

.velocity-indicator {
  position: fixed;
  right: 1rem;
  top: 50%;
  transform: translateY(-50%);
  width: 4px;
  height: 100px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 2px;
  z-index: 998;
  overflow: hidden;
}

.velocity-bar {
  width: 100%;
  background: linear-gradient(180deg, #F97316, #8B5CF6);
  border-radius: 2px;
  transition: height 0.1s ease;
  box-shadow: 0 0 10px rgba(139, 92, 246, 0.5);
}

.scroll-content {
  height: 100%;
  overflow-y: auto;
  scroll-behavior: smooth;
  -webkit-overflow-scrolling: touch;
}

.scroll-snap-points {
  position: fixed;
  left: 2rem;
  top: 50%;
  transform: translateY(-50%);
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  z-index: 999;
}

.snap-point {
  width: 8px;
  height: 8px;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 2px solid transparent;
}

.snap-point:hover {
  background: rgba(255, 255, 255, 0.6);
  transform: scale(1.2);
}

.snap-point.active {
  background: #8B5CF6;
  border-color: rgba(255, 255, 255, 0.5);
  box-shadow: 0 0 10px rgba(139, 92, 246, 0.5);
}

/* Custom scrollbar */
.scroll-content::-webkit-scrollbar {
  width: 8px;
}

.scroll-content::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
}

.scroll-content::-webkit-scrollbar-thumb {
  background: linear-gradient(180deg, #8B5CF6, #7C3AED);
  border-radius: 4px;
  box-shadow: 0 0 10px rgba(139, 92, 246, 0.3);
}

.scroll-content::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(180deg, #7C3AED, #6D28D9);
}

/* Responsive Design */
@media (max-width: 768px) {
  .scroll-indicator {
    right: 1rem;
    width: 40px;
    height: 40px;
  }
  
  .indicator-arrow {
    width: 16px;
    height: 16px;
  }
  
  .scroll-snap-points {
    left: 1rem;
  }
  
  .snap-point {
    width: 6px;
    height: 6px;
  }
  
  .velocity-indicator {
    right: 0.5rem;
    width: 3px;
    height: 80px;
  }
}

@media (max-width: 480px) {
  .scroll-indicator,
  .scroll-snap-points,
  .velocity-indicator {
    display: none;
  }
}
</style>
