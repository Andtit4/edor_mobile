import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'
import { onMounted, onUnmounted, ref } from 'vue'

gsap.registerPlugin(ScrollTrigger)

export function useParallaxAnimations() {
  const parallaxElements = ref([])
  const scrollTriggers = ref([])

  // Parallax effect for elements
  const createParallax = (element, speed = 0.5, direction = 'y') => {
    if (!element) return

    const trigger = ScrollTrigger.create({
      trigger: element,
      start: 'top bottom',
      end: 'bottom top',
      scrub: true,
      onUpdate: (self) => {
        const progress = self.progress
        const movement = (progress - 0.5) * 100 * speed
        
        if (direction === 'y') {
          gsap.set(element, { y: movement })
        } else if (direction === 'x') {
          gsap.set(element, { x: movement })
        } else if (direction === 'both') {
          gsap.set(element, { x: movement * 0.5, y: movement })
        }
      }
    })

    scrollTriggers.value.push(trigger)
    return trigger
  }

  // Reveal animation on scroll
  const revealOnScroll = (element, options = {}) => {
    if (!element) return

    const {
      direction = 'up',
      distance = 100,
      duration = 1,
      delay = 0,
      stagger = 0
    } = options

    let fromProps = {}
    let toProps = { opacity: 1 }

    switch (direction) {
      case 'up':
        fromProps = { opacity: 0, y: distance }
        break
      case 'down':
        fromProps = { opacity: 0, y: -distance }
        break
      case 'left':
        fromProps = { opacity: 0, x: distance }
        break
      case 'right':
        fromProps = { opacity: 0, x: -distance }
        break
      case 'scale':
        fromProps = { opacity: 0, scale: 0.8 }
        toProps = { opacity: 1, scale: 1 }
        break
      case 'rotate':
        fromProps = { opacity: 0, rotation: 180 }
        toProps = { opacity: 1, rotation: 0 }
        break
    }

    const trigger = ScrollTrigger.create({
      trigger: element,
      start: 'top 80%',
      end: 'bottom 20%',
      onEnter: () => {
        gsap.fromTo(element, fromProps, {
          ...toProps,
          duration,
          delay,
          stagger,
          ease: 'power3.out'
        })
      }
    })

    scrollTriggers.value.push(trigger)
    return trigger
  }

  // Stagger reveal for multiple elements
  const staggerReveal = (elements, options = {}) => {
    if (!elements || elements.length === 0) return

    const {
      direction = 'up',
      distance = 100,
      duration = 0.8,
      stagger = 0.1
    } = options

    let fromProps = {}
    let toProps = { opacity: 1 }

    switch (direction) {
      case 'up':
        fromProps = { opacity: 0, y: distance }
        break
      case 'down':
        fromProps = { opacity: 0, y: -distance }
        break
      case 'left':
        fromProps = { opacity: 0, x: distance }
        break
      case 'right':
        fromProps = { opacity: 0, x: -distance }
        break
      case 'scale':
        fromProps = { opacity: 0, scale: 0.8 }
        toProps = { opacity: 1, scale: 1 }
        break
    }

    const trigger = ScrollTrigger.create({
      trigger: elements[0],
      start: 'top 80%',
      end: 'bottom 20%',
      onEnter: () => {
        gsap.fromTo(elements, fromProps, {
          ...toProps,
          duration,
          stagger,
          ease: 'power3.out'
        })
      }
    })

    scrollTriggers.value.push(trigger)
    return trigger
  }

  // Pin element on scroll
  const pinOnScroll = (element, options = {}) => {
    if (!element) return

    const {
      start = 'top top',
      end = 'bottom top',
      pinSpacing = true
    } = options

    const trigger = ScrollTrigger.create({
      trigger: element,
      start,
      end,
      pin: true,
      pinSpacing,
      ...options
    })

    scrollTriggers.value.push(trigger)
    return trigger
  }

  // Horizontal scroll effect
  const horizontalScroll = (element, options = {}) => {
    if (!element) return

    const {
      speed = 1,
      direction = 'left'
    } = options

    const trigger = ScrollTrigger.create({
      trigger: element,
      start: 'top bottom',
      end: 'bottom top',
      scrub: true,
      onUpdate: (self) => {
        const progress = self.progress
        const movement = progress * 100 * speed
        
        if (direction === 'left') {
          gsap.set(element, { x: -movement })
        } else {
          gsap.set(element, { x: movement })
        }
      }
    })

    scrollTriggers.value.push(trigger)
    return trigger
  }

  // Magnetic hover effect
  const magneticHover = (element, options = {}) => {
    if (!element) return

    const {
      strength = 0.3,
      range = 50
    } = options

    const handleMouseMove = (e) => {
      const rect = element.getBoundingClientRect()
      const centerX = rect.left + rect.width / 2
      const centerY = rect.top + rect.height / 2
      
      const deltaX = (e.clientX - centerX) * strength
      const deltaY = (e.clientY - centerY) * strength
      
      const distance = Math.sqrt(deltaX * deltaX + deltaY * deltaY)
      
      if (distance < range) {
        gsap.to(element, {
          x: deltaX,
          y: deltaY,
          duration: 0.3,
          ease: 'power2.out'
        })
      }
    }

    const handleMouseLeave = () => {
      gsap.to(element, {
        x: 0,
        y: 0,
        duration: 0.5,
        ease: 'elastic.out(1, 0.3)'
      })
    }

    element.addEventListener('mousemove', handleMouseMove)
    element.addEventListener('mouseleave', handleMouseLeave)

    return () => {
      element.removeEventListener('mousemove', handleMouseMove)
      element.removeEventListener('mouseleave', handleMouseLeave)
    }
  }

  // Tilt effect on hover
  const tiltEffect = (element, options = {}) => {
    if (!element) return

    const {
      maxTilt = 15,
      perspective = 1000
    } = options

    element.style.transformStyle = 'preserve-3d'
    element.style.perspective = `${perspective}px`

    const handleMouseMove = (e) => {
      const rect = element.getBoundingClientRect()
      const centerX = rect.left + rect.width / 2
      const centerY = rect.top + rect.height / 2
      
      const deltaX = (e.clientX - centerX) / rect.width
      const deltaY = (e.clientY - centerY) / rect.height
      
      const rotateX = deltaY * maxTilt
      const rotateY = -deltaX * maxTilt
      
      gsap.to(element, {
        rotateX,
        rotateY,
        duration: 0.3,
        ease: 'power2.out'
      })
    }

    const handleMouseLeave = () => {
      gsap.to(element, {
        rotateX: 0,
        rotateY: 0,
        duration: 0.5,
        ease: 'elastic.out(1, 0.3)'
      })
    }

    element.addEventListener('mousemove', handleMouseMove)
    element.addEventListener('mouseleave', handleMouseLeave)

    return () => {
      element.removeEventListener('mousemove', handleMouseMove)
      element.removeEventListener('mouseleave', handleMouseLeave)
    }
  }

  // Floating animation
  const floatingAnimation = (element, options = {}) => {
    if (!element) return

    const {
      amplitude = 20,
      duration = 3,
      delay = 0
    } = options

    return gsap.to(element, {
      y: `-=${amplitude}`,
      duration,
      delay,
      ease: 'power2.inOut',
      repeat: -1,
      yoyo: true
    })
  }

  // Rotation animation
  const rotationAnimation = (element, options = {}) => {
    if (!element) return

    const {
      rotation = 360,
      duration = 10,
      direction = 1
    } = options

    return gsap.to(element, {
      rotation: rotation * direction,
      duration,
      ease: 'none',
      repeat: -1
    })
  }

  // Scale pulse animation
  const scalePulse = (element, options = {}) => {
    if (!element) return

    const {
      scale = 1.1,
      duration = 2,
      delay = 0
    } = options

    return gsap.to(element, {
      scale,
      duration,
      delay,
      ease: 'power2.inOut',
      repeat: -1,
      yoyo: true
    })
  }

  // Color transition animation
  const colorTransition = (element, colors, options = {}) => {
    if (!element || !colors || colors.length === 0) return

    const {
      duration = 2,
      delay = 0
    } = options

    const tl = gsap.timeline({ repeat: -1, delay })

    colors.forEach((color, index) => {
      tl.to(element, {
        backgroundColor: color,
        duration: duration / colors.length,
        ease: 'power2.inOut'
      })
    })

    return tl
  }

  // Cleanup function
  const cleanup = () => {
    scrollTriggers.value.forEach(trigger => trigger.kill())
    scrollTriggers.value = []
  }

  onUnmounted(() => {
    cleanup()
  })

  return {
    createParallax,
    revealOnScroll,
    staggerReveal,
    pinOnScroll,
    horizontalScroll,
    magneticHover,
    tiltEffect,
    floatingAnimation,
    rotationAnimation,
    scalePulse,
    colorTransition,
    cleanup
  }
}





