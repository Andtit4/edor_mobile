import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'
import { onMounted, onUnmounted, ref } from 'vue'

gsap.registerPlugin(ScrollTrigger)

export function useAdvancedAnimations() {
  const timeline = ref(null)

  // Animation de typewriter pour le texte
  const typewriterEffect = (element, text, options = {}) => {
    const duration = options.duration || 2
    const delay = options.delay || 0.05
    
    return gsap.fromTo(element, 
      { text: "" },
      {
        text: text,
        duration: duration,
        ease: "none",
        delay: delay
      }
    )
  }

  // Animation de morphing pour les formes
  const morphingAnimation = (element, shapes, options = {}) => {
    const tl = gsap.timeline({ repeat: -1, yoyo: true })
    const duration = options.duration || 3
    
    shapes.forEach((shape, index) => {
      tl.to(element, {
        ...shape,
        duration: duration / shapes.length,
        ease: "power2.inOut"
      })
    })
    
    return tl
  }

  // Animation de particules connectées
  const connectedParticles = (particles, options = {}) => {
    const connections = []
    
    particles.forEach((particle, index) => {
      // Animation de mouvement
      gsap.to(particle, {
        x: `random(-100, 100)`,
        y: `random(-100, 100)`,
        rotation: `random(0, 360)`,
        duration: options.duration || 4 + Math.random() * 2,
        ease: "none",
        repeat: -1,
        yoyo: true,
        delay: index * 0.1
      })
      
      // Créer des connexions avec les particules proches
      particles.forEach((otherParticle, otherIndex) => {
        if (index !== otherIndex) {
          const connection = document.createElement('div')
          connection.className = 'particle-connection'
          connection.style.cssText = `
            position: absolute;
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(139, 92, 246, 0.3), transparent);
            transform-origin: left center;
            z-index: 1;
          `
          document.body.appendChild(connection)
          connections.push(connection)
        }
      })
    })
    
    return connections
  }

  // Animation de glitch pour le texte
  const glitchEffect = (element, options = {}) => {
    const tl = gsap.timeline({ repeat: -1, repeatDelay: options.repeatDelay || 3 })
    
    tl.to(element, {
      skewX: 2,
      x: 2,
      duration: 0.1,
      ease: "power2.inOut"
    })
    .to(element, {
      skewX: -2,
      x: -2,
      duration: 0.1,
      ease: "power2.inOut"
    })
    .to(element, {
      skewX: 0,
      x: 0,
      duration: 0.1,
      ease: "power2.inOut"
    })
    
    return tl
  }

  // Animation de liquide pour les éléments
  const liquidAnimation = (element, options = {}) => {
    return gsap.to(element, {
      scaleX: 1.1,
      scaleY: 0.9,
      rotation: 2,
      duration: options.duration || 2,
      ease: "power2.inOut",
      repeat: -1,
      yoyo: true
    })
  }

  // Animation de respiration pour les éléments
  const breathingAnimation = (element, options = {}) => {
    return gsap.to(element, {
      scale: 1.05,
      opacity: 0.8,
      duration: options.duration || 3,
      ease: "power2.inOut",
      repeat: -1,
      yoyo: true
    })
  }

  // Animation de vague pour les éléments
  const waveAnimation = (elements, options = {}) => {
    return gsap.to(elements, {
      y: -20,
      duration: options.duration || 1,
      ease: "power2.inOut",
      stagger: options.stagger || 0.1,
      repeat: -1,
      yoyo: true
    })
  }

  // Animation de rotation 3D
  const rotate3D = (element, options = {}) => {
    return gsap.to(element, {
      rotationX: options.rotationX || 360,
      rotationY: options.rotationY || 360,
      rotationZ: options.rotationZ || 0,
      duration: options.duration || 4,
      ease: "none",
      repeat: -1
    })
  }

  // Animation de pulsation colorée
  const colorPulse = (element, colors, options = {}) => {
    const tl = gsap.timeline({ repeat: -1 })
    
    colors.forEach((color, index) => {
      tl.to(element, {
        backgroundColor: color,
        duration: options.duration || 1,
        ease: "power2.inOut"
      })
    })
    
    return tl
  }

  // Animation de texte qui s'écrit
  const textReveal = (element, options = {}) => {
    const text = element.textContent
    element.textContent = ''
    
    return gsap.fromTo(element, 
      { text: "" },
      {
        text: text,
        duration: options.duration || 2,
        ease: "none",
        delay: options.delay || 0
      }
    )
  }

  // Animation de réseau neuronal
  const neuralNetwork = (nodes, connections, options = {}) => {
    const tl = gsap.timeline({ repeat: -1 })
    
    // Animer les nœuds
    nodes.forEach((node, index) => {
      gsap.to(node, {
        scale: 1.2,
        opacity: 0.8,
        duration: 0.5,
        ease: "power2.inOut",
        delay: index * 0.1,
        repeat: -1,
        yoyo: true
      })
    })
    
    // Animer les connexions
    connections.forEach((connection, index) => {
      gsap.to(connection, {
        scaleX: 1.2,
        opacity: 0.6,
        duration: 0.3,
        ease: "power2.inOut",
        delay: index * 0.05,
        repeat: -1,
        yoyo: true
      })
    })
    
    return tl
  }

  // Animation de chargement avec points
  const loadingDots = (element, options = {}) => {
    const dots = element.querySelectorAll('.loading-dot')
    
    return gsap.to(dots, {
      scale: 1.5,
      opacity: 1,
      duration: 0.3,
      ease: "power2.inOut",
      stagger: 0.2,
      repeat: -1,
      yoyo: true
    })
  }

  // Animation de particules qui suivent la souris
  const mouseFollower = (particles, options = {}) => {
    const mouse = { x: 0, y: 0 }
    
    const updateMouse = (e) => {
      mouse.x = e.clientX
      mouse.y = e.clientY
    }
    
    window.addEventListener('mousemove', updateMouse)
    
    particles.forEach((particle, index) => {
      gsap.to(particle, {
        x: () => mouse.x + (Math.random() - 0.5) * 100,
        y: () => mouse.y + (Math.random() - 0.5) * 100,
        duration: 1 + Math.random(),
        ease: "power2.out",
        repeat: -1,
        delay: index * 0.1
      })
    })
    
    return () => window.removeEventListener('mousemove', updateMouse)
  }

  // Animation de texte qui se décompose
  const textBreakdown = (element, options = {}) => {
    const text = element.textContent
    const letters = text.split('')
    element.innerHTML = letters.map(letter => 
      `<span class="letter">${letter === ' ' ? '&nbsp;' : letter}</span>`
    ).join('')
    
    const letterElements = element.querySelectorAll('.letter')
    
    return gsap.fromTo(letterElements, 
      { 
        opacity: 0, 
        y: 50, 
        rotationX: 90 
      },
      {
        opacity: 1,
        y: 0,
        rotationX: 0,
        duration: 0.8,
        ease: "back.out(1.7)",
        stagger: 0.05
      }
    )
  }

  // Animation de gradient qui bouge
  const movingGradient = (element, colors, options = {}) => {
    const gradient = `linear-gradient(45deg, ${colors.join(', ')})`
    
    return gsap.to(element, {
      backgroundPosition: '200% 200%',
      duration: options.duration || 3,
      ease: "none",
      repeat: -1,
      yoyo: true
    })
  }

  const cleanup = () => {
    if (timeline.value) {
      timeline.value.kill()
    }
    ScrollTrigger.getAll().forEach(trigger => trigger.kill())
  }

  onUnmounted(() => {
    cleanup()
  })

  return {
    typewriterEffect,
    morphingAnimation,
    connectedParticles,
    glitchEffect,
    liquidAnimation,
    breathingAnimation,
    waveAnimation,
    rotate3D,
    colorPulse,
    textReveal,
    neuralNetwork,
    loadingDots,
    mouseFollower,
    textBreakdown,
    movingGradient,
    cleanup
  }
}

