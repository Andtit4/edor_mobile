import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'
import { onMounted, onUnmounted, ref } from 'vue'

// Enregistrer le plugin ScrollTrigger
gsap.registerPlugin(ScrollTrigger)

export function useGSAP() {
  const timeline = ref(null)

  const createTimeline = () => {
    timeline.value = gsap.timeline()
    return timeline.value
  }

  const animateOnScroll = (element, animation, options = {}) => {
    return gsap.fromTo(element, 
      animation.from || {}, 
      {
        ...animation.to,
        scrollTrigger: {
          trigger: element,
          start: options.start || "top 80%",
          end: options.end || "bottom 20%",
          toggleActions: options.toggleActions || "play none none reverse",
          ...options
        }
      }
    )
  }

  const staggerAnimation = (elements, animation, options = {}) => {
    return gsap.fromTo(elements, 
      animation.from || {}, 
      {
        ...animation.to,
        stagger: options.stagger || 0.1,
        scrollTrigger: {
          trigger: elements[0],
          start: options.start || "top 80%",
          end: options.end || "bottom 20%",
          toggleActions: options.toggleActions || "play none none reverse",
          ...options
        }
      }
    )
  }

  const parallaxEffect = (element, speed = 0.5) => {
    return gsap.to(element, {
      yPercent: -50 * speed,
      ease: "none",
      scrollTrigger: {
        trigger: element,
        start: "top bottom",
        end: "bottom top",
        scrub: true
      }
    })
  }

  const morphingAnimation = (element, morphs, duration = 2) => {
    const tl = gsap.timeline({ repeat: -1, yoyo: true })
    
    morphs.forEach((morph, index) => {
      tl.to(element, {
        ...morph,
        duration: duration / morphs.length,
        ease: "power2.inOut"
      })
    })
    
    return tl
  }

  const floatingAnimation = (element, options = {}) => {
    return gsap.to(element, {
      y: options.y || -20,
      rotation: options.rotation || 0,
      duration: options.duration || 2,
      ease: "power2.inOut",
      repeat: -1,
      yoyo: true
    })
  }

  const textReveal = (element, options = {}) => {
    return gsap.fromTo(element, 
      { 
        opacity: 0, 
        y: options.y || 50,
        scale: options.scale || 0.8
      }, 
      {
        opacity: 1,
        y: 0,
        scale: 1,
        duration: options.duration || 1,
        ease: options.ease || "power3.out",
        scrollTrigger: {
          trigger: element,
          start: options.start || "top 80%",
          toggleActions: options.toggleActions || "play none none reverse"
        }
      }
    )
  }

  const particleAnimation = (particles, options = {}) => {
    particles.forEach((particle, index) => {
      gsap.to(particle, {
        x: options.x || Math.random() * 100 - 50,
        y: options.y || Math.random() * 100 - 50,
        rotation: options.rotation || Math.random() * 360,
        duration: options.duration || 3 + Math.random() * 2,
        ease: "none",
        repeat: -1,
        yoyo: true,
        delay: index * 0.1
      })
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
    createTimeline,
    animateOnScroll,
    staggerAnimation,
    parallaxEffect,
    morphingAnimation,
    floatingAnimation,
    textReveal,
    particleAnimation,
    cleanup
  }
}
