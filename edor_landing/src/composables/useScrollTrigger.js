import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'

// Enregistrer le plugin ScrollTrigger
gsap.registerPlugin(ScrollTrigger)

export function useScrollTrigger() {
  const initScrollTrigger = () => {
    // Configuration globale de ScrollTrigger
    ScrollTrigger.config({
      ignoreMobileResize: true,
      syncInterval: 16
    })

    // Rafraîchir ScrollTrigger après le chargement des images
    ScrollTrigger.refresh()
  }

  const createScrollTrigger = (trigger, animation, options = {}) => {
    return ScrollTrigger.create({
      trigger,
      animation,
      start: options.start || "top 80%",
      end: options.end || "bottom 20%",
      toggleActions: options.toggleActions || "play none none reverse",
      scrub: options.scrub || false,
      pin: options.pin || false,
      ...options
    })
  }

  const batchAnimate = (elements, animation, options = {}) => {
    return ScrollTrigger.batch(elements, {
      onEnter: (elements) => {
        gsap.fromTo(elements, 
          animation.from || {}, 
          {
            ...animation.to,
            stagger: options.stagger || 0.1,
            duration: options.duration || 1,
            ease: options.ease || "power3.out"
          }
        )
      },
      onLeave: (elements) => {
        gsap.to(elements, { 
          opacity: 0, 
          y: 50,
          duration: 0.5 
        })
      },
      onEnterBack: (elements) => {
        gsap.to(elements, { 
          opacity: 1, 
          y: 0,
          duration: 0.5 
        })
      },
      onLeaveBack: (elements) => {
        gsap.to(elements, { 
          opacity: 0, 
          y: 50,
          duration: 0.5 
        })
      },
      start: options.start || "top 80%",
      end: options.end || "bottom 20%",
      ...options
    })
  }

  const parallaxScroll = (element, speed = 0.5) => {
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

  const pinElement = (element, options = {}) => {
    return ScrollTrigger.create({
      trigger: element,
      start: options.start || "top top",
      end: options.end || "bottom top",
      pin: true,
      pinSpacing: options.pinSpacing !== false,
      ...options
    })
  }

  const cleanup = () => {
    ScrollTrigger.getAll().forEach(trigger => trigger.kill())
  }

  return {
    initScrollTrigger,
    createScrollTrigger,
    batchAnimate,
    parallaxScroll,
    pinElement,
    cleanup
  }
}

