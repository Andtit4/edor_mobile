import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'
import { onMounted, onUnmounted, ref } from 'vue'

gsap.registerPlugin(ScrollTrigger)

export function useSmoothScroll() {
  const scrollContainer = ref(null)
  const scrollContent = ref(null)
  const isScrolling = ref(false)
  const scrollDirection = ref('down')
  const scrollProgress = ref(0)
  const scrollVelocity = ref(0)
  
  let lastScrollY = 0
  let scrollTimeout = null
  let momentumTimeout = null
  let scrollTween = null

  // Smooth scroll with momentum
  const initSmoothScroll = (options = {}) => {
    const {
      smoothness = 0.1,
      momentum = 0.8,
      friction = 0.95,
      minVelocity = 0.1,
      maxVelocity = 50
    } = options

    let currentScroll = 0
    let targetScroll = 0
    let velocity = 0
    let isAnimating = false

    const updateScroll = () => {
      if (!isAnimating) {
        isAnimating = true
        requestAnimationFrame(() => {
          // Calculate velocity
          const delta = targetScroll - currentScroll
          velocity = delta * smoothness
          
          // Apply momentum
          if (Math.abs(velocity) > minVelocity) {
            velocity *= momentum
          }
          
          // Apply friction
          velocity *= friction
          
          // Update current scroll
          currentScroll += velocity
          
          // Update scroll position
          if (scrollContainer.value) {
            scrollContainer.value.scrollTop = currentScroll
          }
          
          // Update progress
          const maxScroll = scrollContainer.value?.scrollHeight - scrollContainer.value?.clientHeight || 0
          scrollProgress.value = maxScroll > 0 ? currentScroll / maxScroll : 0
          
          // Update velocity
          scrollVelocity.value = Math.abs(velocity)
          
          // Continue animation if still moving
          if (Math.abs(velocity) > 0.01) {
            updateScroll()
          } else {
            isAnimating = false
          }
        })
      }
    }

    const handleWheel = (e) => {
      e.preventDefault()
      
      const delta = e.deltaY
      targetScroll += delta * 0.5
      
      // Clamp scroll position
      const maxScroll = scrollContainer.value?.scrollHeight - scrollContainer.value?.clientHeight || 0
      targetScroll = Math.max(0, Math.min(targetScroll, maxScroll))
      
      updateScroll()
    }

    const handleScroll = (e) => {
      const currentY = e.target.scrollTop
      scrollDirection.value = currentY > lastScrollY ? 'down' : 'up'
      lastScrollY = currentY
      
      isScrolling.value = true
      
      // Clear existing timeout
      if (scrollTimeout) {
        clearTimeout(scrollTimeout)
      }
      
      // Set new timeout
      scrollTimeout = setTimeout(() => {
        isScrolling.value = false
      }, 150)
    }

    if (scrollContainer.value) {
      scrollContainer.value.addEventListener('wheel', handleWheel, { passive: false })
      scrollContainer.value.addEventListener('scroll', handleScroll)
    }

    return () => {
      if (scrollContainer.value) {
        scrollContainer.value.removeEventListener('wheel', handleWheel)
        scrollContainer.value.removeEventListener('scroll', handleScroll)
      }
    }
  }

  // Parallax layers with different speeds
  const createParallaxLayers = (layers, options = {}) => {
    const {
      baseSpeed = 0.5,
      speedVariation = 0.3,
      direction = 'y'
    } = options

    layers.forEach((layer, index) => {
      if (!layer.element) return

      const speed = baseSpeed + (index * speedVariation)
      
      ScrollTrigger.create({
        trigger: layer.element,
        start: 'top bottom',
        end: 'bottom top',
        scrub: true,
        onUpdate: (self) => {
          const progress = self.progress
          const movement = (progress - 0.5) * 100 * speed
          
          if (direction === 'y') {
            gsap.set(layer.element, { y: movement })
          } else if (direction === 'x') {
            gsap.set(layer.element, { x: movement })
          } else if (direction === 'both') {
            gsap.set(layer.element, { 
              x: movement * 0.5, 
              y: movement,
              rotation: movement * 0.1
            })
          }
        }
      })
    })
  }

  // Smooth section transitions
  const createSectionTransitions = (sections, options = {}) => {
    const {
      transitionDuration = 1,
      ease = 'power2.inOut',
      stagger = 0.1
    } = options

    sections.forEach((section, index) => {
      if (!section.element) return

      ScrollTrigger.create({
        trigger: section.element,
        start: 'top 80%',
        end: 'bottom 20%',
        onEnter: () => {
          gsap.fromTo(section.element, 
            { 
              opacity: 0, 
              y: 100,
              scale: 0.95
            },
            { 
              opacity: 1, 
              y: 0,
              scale: 1,
              duration: transitionDuration,
              ease,
              delay: index * stagger
            }
          )
        },
        onLeave: () => {
          gsap.to(section.element, {
            opacity: 0.3,
            scale: 0.98,
            duration: 0.5,
            ease: 'power2.out'
          })
        },
        onEnterBack: () => {
          gsap.to(section.element, {
            opacity: 1,
            scale: 1,
            duration: 0.5,
            ease: 'power2.out'
          })
        }
      })
    })
  }

  // Momentum scroll with inertia
  const createMomentumScroll = (element, options = {}) => {
    const {
      momentum = 0.9,
      friction = 0.95,
      minVelocity = 0.1
    } = options

    let velocity = 0
    let isAnimating = false
    let lastTime = 0

    const animate = (currentTime) => {
      if (!lastTime) lastTime = currentTime
      const deltaTime = currentTime - lastTime
      lastTime = currentTime

      if (Math.abs(velocity) > minVelocity) {
        velocity *= friction
        element.scrollTop += velocity * deltaTime * 0.1
        
        if (isAnimating) {
          requestAnimationFrame(animate)
        }
      } else {
        isAnimating = false
      }
    }

    const handleWheel = (e) => {
      e.preventDefault()
      
      velocity += e.deltaY * 0.1
      velocity = Math.max(-50, Math.min(50, velocity))
      
      if (!isAnimating) {
        isAnimating = true
        requestAnimationFrame(animate)
      }
    }

    element.addEventListener('wheel', handleWheel, { passive: false })

    return () => {
      element.removeEventListener('wheel', handleWheel)
    }
  }

  // Scroll progress indicator
  const createScrollProgress = (element, options = {}) => {
    const {
      position = 'top',
      height = '4px',
      color = 'linear-gradient(90deg, #8B5CF6, #06B6D4)',
      zIndex = 1000
    } = options

    const progressBar = document.createElement('div')
    progressBar.style.cssText = `
      position: fixed;
      ${position}: 0;
      left: 0;
      width: 0%;
      height: ${height};
      background: ${color};
      z-index: ${zIndex};
      transition: width 0.1s ease;
      box-shadow: 0 0 10px rgba(139, 92, 246, 0.5);
    `

    document.body.appendChild(progressBar)

    ScrollTrigger.create({
      trigger: element,
      start: 'top top',
      end: 'bottom bottom',
      onUpdate: (self) => {
        const progress = self.progress * 100
        progressBar.style.width = `${progress}%`
      }
    })

    return progressBar
  }

  // Scroll snap with smooth transitions
  const createScrollSnap = (sections, options = {}) => {
    const {
      snapDuration = 1,
      snapEase = 'power2.inOut',
      snapDelay = 0.1
    } = options

    let currentSection = 0
    let isSnapping = false

    const snapToSection = (index) => {
      if (isSnapping || !sections[index]) return

      isSnapping = true
      currentSection = index

      gsap.to(window, {
        scrollTo: {
          y: sections[index].element.offsetTop,
          autoKill: false
        },
        duration: snapDuration,
        ease: snapEase,
        delay: snapDelay,
        onComplete: () => {
          isSnapping = false
        }
      })
    }

    // Keyboard navigation
    const handleKeyDown = (e) => {
      if (e.key === 'ArrowDown' || e.key === 'PageDown') {
        e.preventDefault()
        snapToSection(Math.min(currentSection + 1, sections.length - 1))
      } else if (e.key === 'ArrowUp' || e.key === 'PageUp') {
        e.preventDefault()
        snapToSection(Math.max(currentSection - 1, 0))
      }
    }

    window.addEventListener('keydown', handleKeyDown)

    return {
      snapToSection,
      cleanup: () => {
        window.removeEventListener('keydown', handleKeyDown)
      }
    }
  }

  // Smooth scroll to element
  const smoothScrollTo = (element, options = {}) => {
    const {
      duration = 1,
      ease = 'power2.inOut',
      offset = 0
    } = options

    if (!element) return

    gsap.to(window, {
      scrollTo: {
        y: element.offsetTop + offset,
        autoKill: false
      },
      duration,
      ease
    })
  }

  // Scroll velocity tracking
  const trackScrollVelocity = () => {
    let lastScrollY = window.scrollY
    let lastTime = Date.now()

    const updateVelocity = () => {
      const currentScrollY = window.scrollY
      const currentTime = Date.now()
      const deltaY = currentScrollY - lastScrollY
      const deltaTime = currentTime - lastTime

      if (deltaTime > 0) {
        scrollVelocity.value = Math.abs(deltaY / deltaTime)
      }

      lastScrollY = currentScrollY
      lastTime = currentTime

      requestAnimationFrame(updateVelocity)
    }

    updateVelocity()
  }

  // Cleanup function
  const cleanup = () => {
    if (scrollTimeout) {
      clearTimeout(scrollTimeout)
    }
    if (momentumTimeout) {
      clearTimeout(momentumTimeout)
    }
    if (scrollTween) {
      scrollTween.kill()
    }
    ScrollTrigger.getAll().forEach(trigger => trigger.kill())
  }

  onMounted(() => {
    trackScrollVelocity()
  })

  onUnmounted(() => {
    cleanup()
  })

  return {
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
  }
}





