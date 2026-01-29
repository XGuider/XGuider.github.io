/**
 * Main JavaScript entry point for XGuider Blog
 * Initializes blog functionality and components
 * Modern implementation without jQuery/Bootstrap dependencies
 */

(function () {
  'use strict'

  // Better error handling for missing elements
  function initNavigation () {
    const nav = document.querySelector('.site-navigation')
    if (!nav) return

    // Smooth scroll behavior for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
      anchor.addEventListener('click', function (e) {
        e.preventDefault()
        const target = document.querySelector(this.getAttribute('href'))
        if (target) {
          target.scrollIntoView({
            behavior: 'smooth',
            block: 'start'
          })
        }
      })
    })
  }

  // Initialize progressive image loading
  function initImageLazyLoading () {
    if ('IntersectionObserver' in window) {
      const images = document.querySelectorAll('img[data-lazy]')
      const imageObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            const img = entry.target
            img.src = img.dataset.lazy
            img.classList.add('loaded')
            imageObserver.unobserve(img)
          }
        })
      })

      images.forEach(img => imageObserver.observe(img))
    }
  }

  // Handle scroll events with throttling
  function initScrollEffects () {
    let ticking = false

    function updateScrollEffects () {
      const scrollPosition = window.pageYOffset || document.documentElement.scrollTop

      // Add/remove visible class for animations
      const elements = document.querySelectorAll('[data-animate]')
      elements.forEach(el => {
        const triggerPoint = el.dataset.animateTrigger || '100'
        if (scrollPosition > triggerPoint) {
          el.classList.add('animate-in')
        }
      })

      ticking = false
    }

    window.addEventListener('scroll', () => {
      if (!ticking) {
        requestAnimationFrame(updateScrollEffects)
        ticking = true
      }
    })
  }

  // Modern analytics tracker
  function trackEvent (category, action, label) {
    if (typeof window.gtag === 'function') {
      window.gtag('event', action, {
        event_category: category,
        event_label: label,
        transport_type: 'beacon'
      })
    }
  }

  // Initialize all components
  function initializeApp () {
    console.log('XGuider Blog v2.0 initialized')

    // Initialize components
    initNavigation()
    initImageLazyLoading()
    initScrollEffects()

    // Track page performance
    if (window.performance && typeof window.gtag === 'function') {
      window.addEventListener('load', () => {
        const perfData = window.performance.timing
        const pageLoadTime = perfData.loadEventEnd - perfData.navigationStart
        window.gtag('event', 'page_load_time', {
          value: pageLoadTime,
          event_category: 'performance',
          non_interaction: true
        })
      })
    }
  }

  // Initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeApp)
  } else {
    initializeApp()
  }

  // Public API
  window.XGuiderBlog = {
    trackEvent,
    version: '2.0.0'
  }
})()
