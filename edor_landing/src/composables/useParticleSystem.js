import { gsap } from 'gsap'
import { onMounted, onUnmounted, ref } from 'vue'

export function useParticleSystem() {
  const particles = ref([])
  const particleContainer = ref(null)
  const animationId = ref(null)

  // Create particle
  const createParticle = (options = {}) => {
    const {
      x = Math.random() * window.innerWidth,
      y = Math.random() * window.innerHeight,
      size = Math.random() * 4 + 1,
      color = '#ffffff',
      speed = Math.random() * 2 + 0.5,
      direction = Math.random() * Math.PI * 2,
      life = 100,
      type = 'circle'
    } = options

    return {
      x,
      y,
      size,
      color,
      speed,
      direction,
      life,
      maxLife: life,
      type,
      vx: Math.cos(direction) * speed,
      vy: Math.sin(direction) * speed,
      element: null
    }
  }

  // Create particle element
  const createParticleElement = (particle) => {
    const element = document.createElement('div')
    element.className = 'particle'
    
    if (particle.type === 'circle') {
      element.style.cssText = `
        position: absolute;
        width: ${particle.size}px;
        height: ${particle.size}px;
        background: ${particle.color};
        border-radius: 50%;
        pointer-events: none;
        z-index: 1;
        box-shadow: 0 0 ${particle.size * 2}px ${particle.color};
      `
    } else if (particle.type === 'star') {
      element.style.cssText = `
        position: absolute;
        width: ${particle.size}px;
        height: ${particle.size}px;
        background: ${particle.color};
        clip-path: polygon(50% 0%, 61% 35%, 98% 35%, 68% 57%, 79% 91%, 50% 70%, 21% 91%, 32% 57%, 2% 35%, 39% 35%);
        pointer-events: none;
        z-index: 1;
        box-shadow: 0 0 ${particle.size * 2}px ${particle.color};
      `
    } else if (particle.type === 'square') {
      element.style.cssText = `
        position: absolute;
        width: ${particle.size}px;
        height: ${particle.size}px;
        background: ${particle.color};
        pointer-events: none;
        z-index: 1;
        box-shadow: 0 0 ${particle.size * 2}px ${particle.color};
      `
    }

    particle.element = element
    return element
  }

  // Update particle
  const updateParticle = (particle) => {
    particle.x += particle.vx
    particle.y += particle.vy
    particle.life--

    // Apply gravity
    particle.vy += 0.01

    // Apply wind
    particle.vx += (Math.random() - 0.5) * 0.1

    // Update element position
    if (particle.element) {
      particle.element.style.left = `${particle.x}px`
      particle.element.style.top = `${particle.y}px`
      
      // Fade out based on life
      const opacity = particle.life / particle.maxLife
      particle.element.style.opacity = opacity
      
      // Scale based on life
      const scale = 0.5 + (opacity * 0.5)
      particle.element.style.transform = `scale(${scale})`
    }

    return particle.life > 0
  }

  // Animation loop
  const animate = () => {
    // Update existing particles
    particles.value = particles.value.filter(particle => {
      const isAlive = updateParticle(particle)
      if (!isAlive && particle.element) {
        particle.element.remove()
      }
      return isAlive
    })

    // Create new particles
    if (Math.random() < 0.1) {
      const particle = createParticle({
        x: Math.random() * window.innerWidth,
        y: window.innerHeight + 10,
        color: `hsl(${Math.random() * 60 + 200}, 70%, 60%)`,
        speed: Math.random() * 3 + 1,
        direction: Math.random() * Math.PI - Math.PI / 2,
        type: Math.random() > 0.7 ? 'star' : 'circle'
      })

      const element = createParticleElement(particle)
      if (particleContainer.value) {
        particleContainer.value.appendChild(element)
      }
      particles.value.push(particle)
    }

    animationId.value = requestAnimationFrame(animate)
  }

  // Initialize particle system
  const initParticleSystem = (container, options = {}) => {
    const {
      particleCount = 50,
      colors = ['#8B5CF6', '#06B6D4', '#10B981', '#F59E0B'],
      types = ['circle', 'star', 'square']
    } = options

    particleContainer.value = container

    // Create initial particles
    for (let i = 0; i < particleCount; i++) {
      const particle = createParticle({
        x: Math.random() * window.innerWidth,
        y: Math.random() * window.innerHeight,
        color: colors[Math.floor(Math.random() * colors.length)],
        type: types[Math.floor(Math.random() * types.length)],
        speed: Math.random() * 2 + 0.5,
        direction: Math.random() * Math.PI * 2
      })

      const element = createParticleElement(particle)
      container.appendChild(element)
      particles.value.push(particle)
    }

    // Start animation
    animate()
  }

  // Mouse interaction particles
  const createMouseParticles = (element, options = {}) => {
    const {
      count = 10,
      colors = ['#8B5CF6', '#06B6D4', '#10B981'],
      speed = 5
    } = options

    const handleMouseMove = (e) => {
      for (let i = 0; i < count; i++) {
        const particle = createParticle({
          x: e.clientX,
          y: e.clientY,
          color: colors[Math.floor(Math.random() * colors.length)],
          speed: Math.random() * speed + 2,
          direction: Math.random() * Math.PI * 2,
          life: 30,
          size: Math.random() * 3 + 1
        })

        const particleElement = createParticleElement(particle)
        document.body.appendChild(particleElement)
        particles.value.push(particle)
      }
    }

    element.addEventListener('mousemove', handleMouseMove)

    return () => {
      element.removeEventListener('mousemove', handleMouseMove)
    }
  }

  // Explosion effect
  const createExplosion = (x, y, options = {}) => {
    const {
      count = 20,
      colors = ['#8B5CF6', '#06B6D4', '#10B981', '#F59E0B'],
      speed = 8
    } = options

    for (let i = 0; i < count; i++) {
      const particle = createParticle({
        x,
        y,
        color: colors[Math.floor(Math.random() * colors.length)],
        speed: Math.random() * speed + 3,
        direction: (Math.PI * 2 * i) / count,
        life: 60,
        size: Math.random() * 4 + 2
      })

      const particleElement = createParticleElement(particle)
      if (particleContainer.value) {
        particleContainer.value.appendChild(particleElement)
      } else {
        document.body.appendChild(particleElement)
      }
      particles.value.push(particle)
    }
  }

  // Fireworks effect
  const createFireworks = (x, y, options = {}) => {
    const {
      count = 3,
      colors = ['#8B5CF6', '#06B6D4', '#10B981', '#F59E0B', '#EF4444']
    } = options

    for (let i = 0; i < count; i++) {
      setTimeout(() => {
        createExplosion(
          x + (Math.random() - 0.5) * 100,
          y + (Math.random() - 0.5) * 100,
          { count: 15, colors, speed: 6 }
        )
      }, i * 200)
    }
  }

  // Cleanup
  const cleanup = () => {
    if (animationId.value) {
      cancelAnimationFrame(animationId.value)
    }
    
    particles.value.forEach(particle => {
      if (particle.element) {
        particle.element.remove()
      }
    })
    
    particles.value = []
  }

  onUnmounted(() => {
    cleanup()
  })

  return {
    initParticleSystem,
    createMouseParticles,
    createExplosion,
    createFireworks,
    cleanup
  }
}





