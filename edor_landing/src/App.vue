<template>
  <div id="app" class="app">
    <!-- Loading Screen -->
    <SimpleLoadingScreen 
      :isLoading="isLoading" 
      @loaded="handleLoadingComplete" 
    />
    
    <!-- Navigation Header -->
    <header class="app-header" ref="headerRef">
      <nav class="nav-container">
        <div class="nav-brand">
          <div class="brand-logo">
            <span class="logo-icon">🔧</span>
            <span class="logo-text">Edor</span>
          </div>
        </div>
        
        <div class="nav-menu" ref="navMenuRef">
          <a href="#features-section" class="nav-link">Votre Équipe</a>
          <a href="#download-section" class="nav-link">Solutions</a>
          <a href="#" class="nav-link">Blog</a>
          <a href="#" class="nav-link">Tarifs</a>
          <a href="#" class="nav-link nav-login">Se connecter</a>
          <button class="btn btn-primary nav-cta" @click="scrollToDownload">
            Rejoindre maintenant
          </button>
        </div>
        
        <button class="mobile-menu-btn" @click="toggleMobileMenu" ref="mobileMenuBtnRef">
          <span class="hamburger-line"></span>
          <span class="hamburger-line"></span>
          <span class="hamburger-line"></span>
        </button>
      </nav>
    </header>

    <!-- Main Content -->
    <main class="app-main">
      <SmoothScrollWrapper 
        :show-velocity="true"
        :snap-points="[
          { selector: '#hero-section' },
          { selector: '#features-section' },
          { selector: '#download-section' },
          { selector: '#partners-section' }
        ]"
      >
        <!-- Hero Section -->
        <HeroSection id="hero-section" />
        
        <!-- Features Section -->
        <FeaturesSection id="features-section" />
        
        <!-- Download Section -->
        <DownloadSection id="download-section" />
        
        <!-- Partners Section -->
        <PartnersSection id="partners-section" />
      </SmoothScrollWrapper>
    </main>

    <!-- Footer -->
    <footer class="app-footer" ref="footerRef">
      <div class="footer-container">
        <div class="footer-content">
          <div class="footer-brand">
            <div class="brand-logo">
              <span class="logo-icon">🔧</span>
              <span class="logo-text">Edor</span>
            </div>
            <p class="footer-description">
              La plateforme de référence pour connecter clients et prestataires de services.
            </p>
          </div>
          
          <div class="footer-links">
            <div class="footer-column">
              <h4 class="footer-title">Produit</h4>
              <a href="#" class="footer-link">Fonctionnalités</a>
              <a href="#" class="footer-link">Tarifs</a>
              <a href="#" class="footer-link">API</a>
            </div>
            
            <div class="footer-column">
              <h4 class="footer-title">Support</h4>
              <a href="#" class="footer-link">Centre d'aide</a>
              <a href="#" class="footer-link">Contact</a>
              <a href="#" class="footer-link">Statut</a>
            </div>
            
            <div class="footer-column">
              <h4 class="footer-title">Légal</h4>
              <a href="#" class="footer-link">Conditions</a>
              <a href="#" class="footer-link">Confidentialité</a>
              <a href="#" class="footer-link">Cookies</a>
            </div>
          </div>
        </div>
        
        <div class="footer-bottom">
          <div class="footer-copyright">
            © 2024 Edor. Tous droits réservés.
          </div>
          <div class="footer-social">
            <a href="#" class="social-link">
              <svg viewBox="0 0 24 24" fill="currentColor">
                <path d="M24 4.557c-.883.392-1.832.656-2.828.775 1.017-.609 1.798-1.574 2.165-2.724-.951.564-2.005.974-3.127 1.195-.897-.957-2.178-1.555-3.594-1.555-3.179 0-5.515 2.966-4.797 6.045-4.091-.205-7.719-2.165-10.148-5.144-1.29 2.213-.669 5.108 1.523 6.574-.806-.026-1.566-.247-2.229-.616-.054 2.281 1.581 4.415 3.949 4.89-.693.188-1.452.232-2.224.084.626 1.956 2.444 3.379 4.6 3.419-2.07 1.623-4.678 2.348-7.29 2.04 2.179 1.397 4.768 2.212 7.548 2.212 9.142 0 14.307-7.721 13.995-14.646.962-.695 1.797-1.562 2.457-2.549z"/>
              </svg>
            </a>
            <a href="#" class="social-link">
              <svg viewBox="0 0 24 24" fill="currentColor">
                <path d="M22.46 6c-.77.35-1.6.58-2.46.69.88-.53 1.56-1.37 1.88-2.38-.83.5-1.75.85-2.72 1.05C18.37 4.5 17.26 4 16 4c-2.35 0-4.27 1.92-4.27 4.29 0 .34.04.67.11.98C8.28 9.09 5.11 7.38 3 4.79c-.37.63-.58 1.37-.58 2.15 0 1.49.75 2.81 1.91 3.56-.71 0-1.37-.2-1.95-.5v.03c0 2.08 1.48 3.82 3.44 4.21a4.22 4.22 0 0 1-1.93.07 4.28 4.28 0 0 0 4 2.98 8.521 8.521 0 0 1-5.33 1.84c-.34 0-.68-.02-1.02-.06C3.44 20.29 5.7 21 8.12 21 16 21 20.33 14.46 20.33 8.79c0-.19 0-.37-.01-.56.84-.6 1.56-1.36 2.14-2.23z"/>
              </svg>
            </a>
            <a href="#" class="social-link">
              <svg viewBox="0 0 24 24" fill="currentColor">
                <path d="M12.017 0C5.396 0 .029 5.367.029 11.987c0 5.079 3.158 9.417 7.618 11.174-.105-.949-.199-2.403.041-3.439.219-.937 1.406-5.957 1.406-5.957s-.359-.72-.359-1.781c0-1.663.967-2.911 2.168-2.911 1.024 0 1.518.769 1.518 1.688 0 1.029-.653 2.567-.992 3.992-.285 1.193.6 2.165 1.775 2.165 2.128 0 3.768-2.245 3.768-5.487 0-2.861-2.063-4.869-5.008-4.869-3.41 0-5.409 2.562-5.409 5.199 0 1.033.394 2.143.889 2.741.099.12.112.225.085.345-.09.375-.293 1.199-.334 1.363-.053.225-.172.271-.402.165-1.495-.69-2.433-2.878-2.433-4.646 0-3.776 2.748-7.252 7.92-7.252 4.158 0 7.392 2.967 7.392 6.923 0 4.135-2.607 7.462-6.233 7.462-1.214 0-2.357-.629-2.746-1.378l-.748 2.853c-.271 1.043-1.002 2.35-1.492 3.146C9.57 23.812 10.763 24.009 12.017 24.009c6.624 0 11.99-5.367 11.99-11.988C24.007 5.367 18.641.001.012.001z"/>
              </svg>
            </a>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useGSAP } from './composables/useGSAP'
import { useResponsive } from './composables/useResponsive'
import HeroSection from './components/HeroSection.vue'
import FeaturesSection from './components/FeaturesSection.vue'
import DownloadSection from './components/DownloadSection.vue'
import PartnersSection from './components/PartnersSection.vue'
import SimpleLoadingScreen from './components/SimpleLoadingScreen.vue'
import SmoothScrollWrapper from './components/SmoothScrollWrapper.vue'

const { createTimeline, textReveal } = useGSAP()
const { isMobile } = useResponsive()

// Loading state
const isLoading = ref(true)

// Auto-hide loading after 3 seconds as fallback
setTimeout(() => {
  if (isLoading.value) {
    isLoading.value = false
  }
}, 3000)

// Template refs
const headerRef = ref(null)
const navMenuRef = ref(null)
const mobileMenuBtnRef = ref(null)
const footerRef = ref(null)

const isMobileMenuOpen = ref(false)

const toggleMobileMenu = () => {
  isMobileMenuOpen.value = !isMobileMenuOpen.value
}

const scrollToDownload = () => {
  document.getElementById('download-section')?.scrollIntoView({ 
    behavior: 'smooth' 
  })
}

const handleLoadingComplete = () => {
  isLoading.value = false
}

onMounted(() => {
  // Header animation
  textReveal(headerRef.value, {
    y: -50,
    duration: 1,
    ease: "power3.out"
  })

  // Footer animation
  textReveal(footerRef.value, {
    y: 50,
    duration: 1,
    ease: "power3.out",
    start: "top 80%"
  })

  // Smooth scrolling for navigation links
  const navLinks = document.querySelectorAll('.nav-link')
  navLinks.forEach(link => {
    link.addEventListener('click', (e) => {
      e.preventDefault()
      const targetId = link.getAttribute('href')
      if (targetId.startsWith('#')) {
        const targetElement = document.querySelector(targetId)
        if (targetElement) {
          targetElement.scrollIntoView({ behavior: 'smooth' })
        }
      }
    })
  })
})
</script>

<style scoped>
.app {
  min-height: 100vh;
  background: #FFFFFF;
}

.app-header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  background: rgba(30, 27, 75, 0.95);
  backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease;
}

.nav-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 80px;
}

.nav-brand {
  display: flex;
  align-items: center;
}

.brand-logo {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-family: 'Space Grotesk', 'Inter', sans-serif;
  font-size: 1.5rem;
  font-weight: 800;
  color: white;
  text-decoration: none;
  letter-spacing: -0.02em;
}

.logo-icon {
  font-size: 2rem;
}

.logo-text {
  background: linear-gradient(135deg, #F97316, #FBBF24);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.nav-menu {
  display: flex;
  align-items: center;
  gap: 2rem;
}

.nav-link {
  color: rgba(255, 255, 255, 0.8);
  text-decoration: none;
  font-family: 'Inter', sans-serif;
  font-weight: 500;
  font-size: 0.95rem;
  letter-spacing: -0.01em;
  transition: all 0.3s ease;
  position: relative;
}

.nav-link:hover {
  color: white;
}

.nav-login {
  color: rgba(255, 255, 255, 0.6);
}

.nav-link::after {
  content: '';
  position: absolute;
  bottom: -5px;
  left: 0;
  width: 0;
  height: 2px;
  background: linear-gradient(135deg, #F97316, #FBBF24);
  transition: width 0.3s ease;
}

.nav-link:hover::after {
  width: 100%;
}

.nav-cta {
  padding: 0.75rem 1.5rem;
  background: linear-gradient(135deg, #8B5CF6, #7C3AED);
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.nav-cta:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 25px rgba(139, 92, 246, 0.3);
}

.mobile-menu-btn {
  display: none;
  flex-direction: column;
  gap: 4px;
  background: none;
  border: none;
  cursor: pointer;
  padding: 0.5rem;
}

.hamburger-line {
  width: 25px;
  height: 3px;
  background: #1E293B;
  border-radius: 2px;
  transition: all 0.3s ease;
}

.app-main {
  margin-top: 80px;
}

.app-footer {
  background: #1E293B;
  color: white;
  padding: 4rem 0 2rem;
}

.footer-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

.footer-content {
  display: grid;
  grid-template-columns: 1fr 2fr;
  gap: 4rem;
  margin-bottom: 3rem;
}

.footer-brand {
  max-width: 300px;
}

.footer-description {
  color: #94A3B8;
  line-height: 1.6;
  margin-top: 1rem;
}

.footer-links {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2rem;
}

.footer-column {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.footer-title {
  font-size: 1.125rem;
  font-weight: 600;
  color: white;
  margin-bottom: 0.5rem;
}

.footer-link {
  color: #94A3B8;
  text-decoration: none;
  transition: color 0.3s ease;
}

.footer-link:hover {
  color: #8B5CF6;
}

.footer-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 2rem;
  border-top: 1px solid #334155;
}

.footer-copyright {
  color: #94A3B8;
  font-size: 0.875rem;
}

.footer-social {
  display: flex;
  gap: 1rem;
}

.social-link {
  width: 40px;
  height: 40px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #94A3B8;
  transition: all 0.3s ease;
}

.social-link:hover {
  background: #8B5CF6;
  color: white;
  transform: translateY(-2px);
}

.social-link svg {
  width: 20px;
  height: 20px;
}

/* Responsive Design */
@media (max-width: 768px) {
  .nav-menu {
    display: none;
  }
  
  .mobile-menu-btn {
    display: flex;
  }
  
  .footer-content {
    grid-template-columns: 1fr;
    gap: 2rem;
  }
  
  .footer-links {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }
  
  .footer-bottom {
    flex-direction: column;
    gap: 1rem;
    text-align: center;
  }
}

@media (max-width: 480px) {
  .nav-container {
    padding: 0 1rem;
  }
  
  .footer-container {
    padding: 0 1rem;
  }
}
</style>