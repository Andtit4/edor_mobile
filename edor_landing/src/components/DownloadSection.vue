<template>
  <section id="download-section" class="download-section" ref="downloadRef">
    <!-- Background Elements -->
    <div class="download-background">
      <div class="gradient-orb orb-1" ref="orb1"></div>
      <div class="gradient-orb orb-2" ref="orb2"></div>
      <div class="floating-shapes">
        <div 
          v-for="i in 8" 
          :key="i"
          class="floating-shape"
          :class="`shape-${i}`"
          :style="{ 
            left: Math.random() * 100 + '%', 
            top: Math.random() * 100 + '%',
            animationDelay: Math.random() * 3 + 's'
          }"
        ></div>
      </div>
    </div>

    <div class="container">
      <div class="download-content">
        <!-- Left Column - Text Content -->
        <div class="download-text" ref="textRef">
          <div class="download-badge" ref="badgeRef">
            <span class="badge-icon">📱</span>
            <span>Téléchargement</span>
          </div>
          
          <h2 class="download-title" ref="titleRef">
            Prêt à commencer ?
            <br>
            <span class="gradient-text" ref="gradientTextRef">Téléchargez Edor</span>
          </h2>
          
          <p class="download-description" ref="descriptionRef">
            Rejoignez des milliers d'utilisateurs qui font confiance à Edor 
            pour leurs besoins en services. Disponible sur iOS et Android.
          </p>
          
          <!-- Download Buttons -->
          <div class="download-buttons" ref="buttonsRef">
            <a 
              href="#" 
              class="download-btn app-store"
              @click="downloadApp('ios')"
            >
              <div class="btn-content">
                <div class="btn-icon">
                  <svg viewBox="0 0 24 24" fill="currentColor">
                    <path d="M18.71 19.5C17.88 20.74 17 21.95 15.66 21.97C14.32 22 13.89 21.18 12.37 21.18C10.84 21.18 10.37 21.95 9.1 22C7.79 22.05 6.8 20.68 5.96 19.47C4.25 17 2.94 12.45 4.7 9.39C5.57 7.87 7.13 6.91 8.82 6.88C10.1 6.86 11.32 7.75 12.11 7.75C12.89 7.75 14.37 6.68 15.92 6.84C16.57 6.87 18.39 7.1 19.56 8.82C19.47 8.88 17.39 10.1 17.41 12.63C17.44 15.65 20.06 16.66 20.09 16.67C20.06 16.74 19.67 18.11 18.71 19.5ZM13 3.5C13.73 2.67 14.94 2.04 15.94 2C16.07 3.17 15.6 4.35 14.9 5.19C14.21 6.04 13.07 6.7 11.95 6.61C11.8 5.46 12.36 4.26 13 3.5Z"/>
                  </svg>
                </div>
                <div class="btn-text">
                  <div class="btn-label">Télécharger sur</div>
                  <div class="btn-store">App Store</div>
                </div>
              </div>
            </a>
            
            <a 
              href="#" 
              class="download-btn google-play"
              @click="downloadApp('android')"
            >
              <div class="btn-content">
                <div class="btn-icon">
                  <svg viewBox="0 0 24 24" fill="currentColor">
                    <path d="M3,20.5V3.5C3,2.91 3.34,2.39 3.84,2.15L13.69,12L3.84,21.85C3.34,21.6 3,21.09 3,20.5M16.81,15.12L6.05,21.34L14.54,12.85L16.81,15.12M20.16,10.81C20.5,11.08 20.75,11.5 20.75,12C20.75,12.5 20.53,12.9 20.18,13.18L17.89,14.5L15.39,12L17.89,9.5L20.16,10.81M6.05,2.66L16.81,8.88L14.54,11.15L6.05,2.66Z"/>
                  </svg>
                </div>
                <div class="btn-text">
                  <div class="btn-label">Disponible sur</div>
                  <div class="btn-store">Google Play</div>
                </div>
              </div>
            </a>
          </div>
          
          <!-- QR Code -->
          <div class="qr-section" ref="qrRef">
            <div class="qr-container">
              <div class="qr-code">
                <div class="qr-grid">
                  <div 
                    v-for="i in 64" 
                    :key="i"
                    class="qr-dot"
                    :class="{ 'qr-dot-filled': Math.random() > 0.5 }"
                  ></div>
                </div>
              </div>
              <div class="qr-text">
                <div class="qr-label">Scanner pour télécharger</div>
                <div class="qr-subtitle">Disponible sur mobile</div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Right Column - Visual Content -->
        <div class="download-visual" ref="visualRef">
          <div class="phone-stack" ref="phoneStackRef">
            <!-- Phone 1 -->
            <div class="phone phone-1" ref="phone1Ref">
              <div class="phone-screen">
                <div class="app-preview">
                  <div class="preview-header">
                    <div class="preview-title">Edor</div>
                    <div class="preview-subtitle">Services à domicile</div>
                  </div>
                  <div class="preview-content">
                    <div class="preview-card" v-for="i in 3" :key="i">
                      <div class="card-icon">🔧</div>
                      <div class="card-info">
                        <div class="card-title">Plomberie</div>
                        <div class="card-rating">⭐ 4.8</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- Phone 2 -->
            <div class="phone phone-2" ref="phone2Ref">
              <div class="phone-screen">
                <div class="app-preview">
                  <div class="preview-header">
                    <div class="preview-title">Messages</div>
                  </div>
                  <div class="preview-content">
                    <div class="message-bubble" v-for="i in 2" :key="i">
                      <div class="bubble-content">
                        <div class="bubble-text">Bonjour ! Je suis disponible</div>
                        <div class="bubble-time">14:30</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- Phone 3 -->
            <div class="phone phone-3" ref="phone3Ref">
              <div class="phone-screen">
                <div class="app-preview">
                  <div class="preview-header">
                    <div class="preview-title">Profil</div>
                  </div>
                  <div class="preview-content">
                    <div class="profile-preview">
                      <div class="profile-avatar">👤</div>
                      <div class="profile-info">
                        <div class="profile-name">Jean Dupont</div>
                        <div class="profile-rating">⭐ 4.9 (127 avis)</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Floating Elements -->
          <div class="floating-elements">
            <div class="floating-element element-1" ref="float1">
              <div class="floating-card">
                <div class="card-icon">📱</div>
                <div class="card-text">App Mobile</div>
              </div>
            </div>
            
            <div class="floating-element element-2" ref="float2">
              <div class="floating-card">
                <div class="card-icon">⚡</div>
                <div class="card-text">Rapide</div>
              </div>
            </div>
            
            <div class="floating-element element-3" ref="float3">
              <div class="floating-card">
                <div class="card-icon">🔒</div>
                <div class="card-text">Sécurisé</div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Stats Section -->
      <div class="download-stats" ref="statsRef">
        <div class="stat-item" v-for="stat in stats" :key="stat.label">
          <div class="stat-number">{{ stat.number }}</div>
          <div class="stat-label">{{ stat.label }}</div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useGSAP } from '../composables/useGSAP'

const { createTimeline, floatingAnimation, staggerAnimation, textReveal } = useGSAP()

// Template refs
const downloadRef = ref(null)
const orb1 = ref(null)
const orb2 = ref(null)
const textRef = ref(null)
const badgeRef = ref(null)
const titleRef = ref(null)
const gradientTextRef = ref(null)
const descriptionRef = ref(null)
const buttonsRef = ref(null)
const qrRef = ref(null)
const visualRef = ref(null)
const phoneStackRef = ref(null)
const phone1Ref = ref(null)
const phone2Ref = ref(null)
const phone3Ref = ref(null)
const float1 = ref(null)
const float2 = ref(null)
const float3 = ref(null)
const statsRef = ref(null)

// Stats data
const stats = ref([
  { number: '100K+', label: 'Téléchargements' },
  { number: '4.8★', label: 'Note moyenne' },
  { number: '50+', label: 'Pays' },
  { number: '24/7', label: 'Support' }
])

const downloadApp = (platform) => {
  // Simulation du téléchargement
  console.log(`Téléchargement pour ${platform}`)
  // Ici vous pouvez ajouter la logique de téléchargement réelle
}

onMounted(() => {
  const tl = createTimeline()
  
  // Background orbs animation
  tl.fromTo(orb1.value, 
    { scale: 0, opacity: 0 },
    { scale: 1, opacity: 0.4, duration: 2, ease: "power3.out" }
  )
  .fromTo(orb2.value, 
    { scale: 0, opacity: 0 },
    { scale: 1, opacity: 0.3, duration: 2, ease: "power3.out" },
    "-=1.5"
  )
  
  // Text animations
  tl.fromTo(badgeRef.value,
    { opacity: 0, y: 30 },
    { opacity: 1, y: 0, duration: 1, ease: "power3.out" },
    "-=1"
  )
  .fromTo(titleRef.value,
    { opacity: 0, y: 50 },
    { opacity: 1, y: 0, duration: 1.2, ease: "power3.out" },
    "-=0.8"
  )
  .fromTo(gradientTextRef.value,
    { opacity: 0, scale: 0.8 },
    { opacity: 1, scale: 1, duration: 1, ease: "back.out(1.7)" },
    "-=0.6"
  )
  .fromTo(descriptionRef.value,
    { opacity: 0, y: 30 },
    { opacity: 1, y: 0, duration: 1, ease: "power3.out" },
    "-=0.4"
  )
  .fromTo(buttonsRef.value,
    { opacity: 0, y: 30 },
    { opacity: 1, y: 0, duration: 1, ease: "power3.out" },
    "-=0.2"
  )
  .fromTo(qrRef.value,
    { opacity: 0, y: 30 },
    { opacity: 1, y: 0, duration: 1, ease: "power3.out" },
    "-=0.2"
  )
  
  // Visual animations
  tl.fromTo(visualRef.value,
    { opacity: 0, x: 100 },
    { opacity: 1, x: 0, duration: 1.5, ease: "power3.out" },
    "-=1.5"
  )
  
  // Phone stack animation
  const phones = [phone1Ref.value, phone2Ref.value, phone3Ref.value]
  phones.forEach((phone, index) => {
    tl.fromTo(phone,
      { opacity: 0, y: 50, rotation: 10 },
      { opacity: 1, y: 0, rotation: 0, duration: 1, ease: "power3.out" },
      `-=${1.2 - (index * 0.2)}`
    )
  })
  
  // Stats animation
  const statItems = statsRef.value?.querySelectorAll('.stat-item')
  if (statItems) {
    staggerAnimation(statItems, {
      from: { opacity: 0, y: 30 },
      to: { opacity: 1, y: 0 }
    }, {
      stagger: 0.1,
      start: "top 80%"
    })
  }
  
  // Floating elements
  floatingAnimation(float1.value, { y: -15, rotation: 5, duration: 3 })
  floatingAnimation(float2.value, { y: -20, rotation: -3, duration: 2.5 })
  floatingAnimation(float3.value, { y: -10, rotation: 4, duration: 3.5 })
})
</script>

<style scoped>
.download-section {
  position: relative;
  padding: 6rem 0;
  background: linear-gradient(135deg, #0F172A 0%, #1E293B 50%, #334155 100%);
  overflow: hidden;
}

.download-background {
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
  left: -200px;
}

.orb-2 {
  width: 300px;
  height: 300px;
  background: linear-gradient(135deg, #06B6D4, #0891B2);
  bottom: -150px;
  right: -150px;
}

.floating-shapes {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
}

.floating-shape {
  position: absolute;
  width: 4px;
  height: 4px;
  background: #8B5CF6;
  border-radius: 50%;
  animation: float 8s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0px) rotate(0deg); opacity: 0.7; }
  50% { transform: translateY(-30px) rotate(180deg); opacity: 1; }
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  position: relative;
  z-index: 2;
}

.download-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
  align-items: center;
  margin-bottom: 4rem;
}

.download-text {
  color: white;
}

.download-badge {
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

.download-title {
  font-size: 3.5rem;
  font-weight: 800;
  line-height: 1.1;
  margin-bottom: 1.5rem;
  letter-spacing: -0.02em;
}

.gradient-text {
  background: linear-gradient(135deg, #8B5CF6, #06B6D4);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.download-description {
  font-size: 1.25rem;
  line-height: 1.6;
  color: #94A3B8;
  margin-bottom: 2.5rem;
  max-width: 500px;
}

.download-buttons {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-bottom: 3rem;
}

.download-btn {
  display: flex;
  align-items: center;
  padding: 1rem 1.5rem;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
  text-decoration: none;
  color: white;
  max-width: 200px;
}

.download-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
}

.btn-content {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.btn-icon {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.btn-icon svg {
  width: 24px;
  height: 24px;
}

.btn-text {
  display: flex;
  flex-direction: column;
}

.btn-label {
  font-size: 0.75rem;
  color: #94A3B8;
}

.btn-store {
  font-size: 1rem;
  font-weight: 600;
}

.qr-section {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.qr-container {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  backdrop-filter: blur(10px);
}

.qr-code {
  width: 60px;
  height: 60px;
  background: white;
  border-radius: 8px;
  padding: 4px;
}

.qr-grid {
  display: grid;
  grid-template-columns: repeat(8, 1fr);
  gap: 1px;
  height: 100%;
}

.qr-dot {
  background: transparent;
  border-radius: 1px;
}

.qr-dot-filled {
  background: #1E293B;
}

.qr-text {
  color: white;
}

.qr-label {
  font-size: 0.875rem;
  font-weight: 600;
  margin-bottom: 0.25rem;
}

.qr-subtitle {
  font-size: 0.75rem;
  color: #94A3B8;
}

.download-visual {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
}

.phone-stack {
  position: relative;
  width: 300px;
  height: 600px;
}

.phone {
  position: absolute;
  width: 200px;
  height: 400px;
  background: #1E293B;
  border-radius: 30px;
  padding: 15px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
  border: 2px solid #334155;
}

.phone-1 {
  top: 0;
  left: 0;
  z-index: 3;
}

.phone-2 {
  top: 50px;
  left: 50px;
  z-index: 2;
  opacity: 0.8;
}

.phone-3 {
  top: 100px;
  left: 100px;
  z-index: 1;
  opacity: 0.6;
}

.phone-screen {
  width: 100%;
  height: 100%;
  background: white;
  border-radius: 20px;
  overflow: hidden;
  position: relative;
}

.app-preview {
  height: 100%;
  padding: 1rem;
  display: flex;
  flex-direction: column;
}

.preview-header {
  text-align: center;
  margin-bottom: 1rem;
}

.preview-title {
  font-size: 1.25rem;
  font-weight: 700;
  color: #1E293B;
  margin-bottom: 0.25rem;
}

.preview-subtitle {
  font-size: 0.75rem;
  color: #64748B;
}

.preview-content {
  flex: 1;
}

.preview-card {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem;
  background: #F8FAFC;
  border-radius: 8px;
  margin-bottom: 0.5rem;
}

.card-icon {
  font-size: 1.25rem;
}

.card-info {
  flex: 1;
}

.card-title {
  font-size: 0.875rem;
  font-weight: 600;
  color: #1E293B;
  margin-bottom: 0.25rem;
}

.card-rating {
  font-size: 0.75rem;
  color: #F59E0B;
}

.message-bubble {
  background: #8B5CF6;
  color: white;
  padding: 0.75rem;
  border-radius: 12px;
  margin-bottom: 0.5rem;
  max-width: 80%;
}

.bubble-content {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.bubble-text {
  font-size: 0.875rem;
}

.bubble-time {
  font-size: 0.75rem;
  opacity: 0.8;
  align-self: flex-end;
}

.profile-preview {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  background: #F8FAFC;
  border-radius: 12px;
}

.profile-avatar {
  width: 50px;
  height: 50px;
  background: #8B5CF6;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  color: white;
}

.profile-info {
  flex: 1;
}

.profile-name {
  font-size: 1rem;
  font-weight: 600;
  color: #1E293B;
  margin-bottom: 0.25rem;
}

.profile-rating {
  font-size: 0.875rem;
  color: #F59E0B;
}

.floating-elements {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 4;
}

.floating-element {
  position: absolute;
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

.download-stats {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 2rem;
  text-align: center;
}

.stat-item {
  color: white;
}

.stat-number {
  font-size: 2.5rem;
  font-weight: 800;
  color: #8B5CF6;
  margin-bottom: 0.5rem;
}

.stat-label {
  font-size: 1rem;
  color: #94A3B8;
  font-weight: 500;
}

/* Responsive Design */
@media (max-width: 1024px) {
  .download-content {
    grid-template-columns: 1fr;
    gap: 3rem;
    text-align: center;
  }
  
  .download-title {
    font-size: 2.5rem;
  }
  
  .phone-stack {
    width: 250px;
    height: 500px;
  }
  
  .phone {
    width: 150px;
    height: 300px;
  }
}

@media (max-width: 768px) {
  .download-title {
    font-size: 2rem;
  }
  
  .download-description {
    font-size: 1rem;
  }
  
  .download-buttons {
    align-items: center;
  }
  
  .download-stats {
    grid-template-columns: repeat(2, 1fr);
    gap: 1.5rem;
  }
  
  .phone-stack {
    width: 200px;
    height: 400px;
  }
  
  .phone {
    width: 120px;
    height: 240px;
  }
  
  .floating-element {
    display: none;
  }
}
</style>
