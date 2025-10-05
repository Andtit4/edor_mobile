<template>
  <section class="partners-section" ref="partnersRef">
    <div class="container">
      <div class="partners-content">
        <div class="partners-header" ref="headerRef">
          <h3 class="partners-title">Ils nous font confiance</h3>
          <p class="partners-subtitle">Rejoignez des milliers d'entreprises qui utilisent Edor</p>
        </div>
        
        <div class="partners-logos" ref="logosRef">
          <div 
            v-for="(partner, index) in partners" 
            :key="index"
            class="partner-logo"
            :class="`partner-${index + 1}`"
            :ref="el => partnerRefs[index] = el"
          >
            <div class="logo-container">
              <div class="logo-icon" :style="{ background: partner.gradient }">
                <span class="logo-emoji">{{ partner.emoji }}</span>
              </div>
              <div class="logo-text">{{ partner.name }}</div>
            </div>
            <div class="logo-glow" :style="{ background: partner.glow }"></div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useGSAP } from '../composables/useGSAP'

const { staggerAnimation, textReveal } = useGSAP()

// Template refs
const partnersRef = ref(null)
const headerRef = ref(null)
const logosRef = ref(null)
const partnerRefs = ref([])

// Partners data
const partners = ref([
  { 
    name: 'Dreamure', 
    emoji: 'D', 
    gradient: 'linear-gradient(135deg, #8B5CF6, #7C3AED)',
    glow: 'rgba(139, 92, 246, 0.2)'
  },
  { 
    name: 'SWITCH.WIN', 
    emoji: 'S', 
    gradient: 'linear-gradient(135deg, #06B6D4, #0891B2)',
    glow: 'rgba(6, 182, 212, 0.2)'
  },
  { 
    name: 'Glow Sphere', 
    emoji: '🌐', 
    gradient: 'linear-gradient(135deg, #10B981, #059669)',
    glow: 'rgba(16, 185, 129, 0.2)'
  },
  { 
    name: 'PinSpace', 
    emoji: '📍', 
    gradient: 'linear-gradient(135deg, #F59E0B, #D97706)',
    glow: 'rgba(245, 158, 11, 0.2)'
  },
  { 
    name: 'Visionix', 
    emoji: 'V', 
    gradient: 'linear-gradient(135deg, #EF4444, #DC2626)',
    glow: 'rgba(239, 68, 68, 0.2)'
  }
])

onMounted(() => {
  // Header animation
  textReveal(headerRef.value, {
    y: 30,
    duration: 1,
    ease: "power3.out"
  })

  // Partners logos animation
  if (partnerRefs.value.length > 0) {
    staggerAnimation(partnerRefs.value, {
      from: { opacity: 0, y: 40, scale: 0.8 },
      to: { opacity: 1, y: 0, scale: 1 }
    }, {
      stagger: 0.1,
      start: "top 80%"
    })
  }
})
</script>

<style scoped>
.partners-section {
  padding: 4rem 0;
  background: linear-gradient(135deg, #1E1B4B 0%, #312E81 50%, #1E293B 100%);
  position: relative;
  overflow: hidden;
}

.partners-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grid" width="20" height="20" patternUnits="userSpaceOnUse"><path d="M 20 0 L 0 0 0 20" fill="none" stroke="%23334155" stroke-width="0.5"/></pattern></defs><rect width="100" height="100" fill="url(%23grid)"/></svg>');
  opacity: 0.1;
  z-index: 1;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  position: relative;
  z-index: 2;
}

.partners-content {
  text-align: center;
}

.partners-header {
  margin-bottom: 3rem;
}

.partners-title {
  font-size: 2rem;
  font-weight: 700;
  color: white;
  margin-bottom: 0.5rem;
  text-shadow: 0 0 20px rgba(255, 255, 255, 0.3);
}

.partners-subtitle {
  font-size: 1.125rem;
  color: rgba(255, 255, 255, 0.7);
  font-weight: 400;
}

.partners-logos {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 3rem;
  flex-wrap: wrap;
}

.partner-logo {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.75rem;
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 16px;
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
  cursor: pointer;
}

.partner-logo:hover {
  transform: translateY(-5px);
  background: rgba(255, 255, 255, 0.1);
  border-color: rgba(255, 255, 255, 0.2);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
}

.logo-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.75rem;
  position: relative;
  z-index: 2;
}

.logo-icon {
  width: 50px;
  height: 50px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
  border: 2px solid rgba(255, 255, 255, 0.2);
}

.logo-emoji {
  font-size: 1.5rem;
  font-weight: 700;
  color: white;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.logo-text {
  font-size: 1rem;
  font-weight: 600;
  color: white;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.logo-glow {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 80px;
  height: 80px;
  border-radius: 16px;
  filter: blur(15px);
  z-index: 1;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.partner-logo:hover .logo-glow {
  opacity: 0.6;
}

/* Responsive Design */
@media (max-width: 1024px) {
  .partners-logos {
    gap: 2rem;
  }
  
  .partner-logo {
    padding: 1.25rem;
  }
  
  .logo-icon {
    width: 45px;
    height: 45px;
  }
  
  .logo-emoji {
    font-size: 1.25rem;
  }
}

@media (max-width: 768px) {
  .partners-section {
    padding: 3rem 0;
  }
  
  .partners-title {
    font-size: 1.5rem;
  }
  
  .partners-subtitle {
    font-size: 1rem;
  }
  
  .partners-logos {
    gap: 1.5rem;
  }
  
  .partner-logo {
    padding: 1rem;
  }
  
  .logo-icon {
    width: 40px;
    height: 40px;
  }
  
  .logo-emoji {
    font-size: 1.125rem;
  }
  
  .logo-text {
    font-size: 0.875rem;
  }
}

@media (max-width: 480px) {
  .partners-logos {
    gap: 1rem;
  }
  
  .partner-logo {
    padding: 0.75rem;
  }
  
  .logo-icon {
    width: 35px;
    height: 35px;
  }
  
  .logo-emoji {
    font-size: 1rem;
  }
  
  .logo-text {
    font-size: 0.75rem;
  }
}
</style>

