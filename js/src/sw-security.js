/**
 * Secure Service Worker for XGuider Blog
 * Implements safe caching strategies and security measures
 */

// Service Worker version and cache name
const SW_VERSION = 'v2.0.0'
const CACHE_NAME = `xguider-blog-${SW_VERSION}`

// Define cache strategies
const CACHE_STRATEGIES = {
  // Cache first, then network
  CACHE_FIRST: 'cache-first',
  // Network first, then cache
  NETWORK_FIRST: 'network-first',
  // Stale while revalidate
  STALE_WHILE_REVALIDATE: 'stale-while-revalidate',
  // Network only (for analytics and API calls)
  NETWORK_ONLY: 'network-only'
}

// Resource patterns for different caching strategies
const CACHE_PATTERNS = {
  [CACHE_STRATEGIES.CACHE_FIRST]: [
    /\.(?:css|js|woff|woff2|ttf|eot|otf)$/,
    /\/(?:img|icons|images)\//,
    /manifest\.json$/
  ],
  [CACHE_STRATEGIES.NETWORK_FIRST]: [
    /\/(?:feed\.xml|sitemap\.xml)?$/,
    /\.html?$/
  ],
  [CACHE_STRATEGIES.STALE_WHILE_REVALIDATE]: [
    /\.(?:woff|woff2)$/
  ],
  [CACHE_STRATEGIES.NETWORK_ONLY]: [
    /google-analytics\.com/,
    /googletagmanager\.com/,
    /gstatic\.com/,
    /baidu\.com/,
    /plausible\.io/,
    /\/api\//
  ]
}

// Security headers to apply
const SECURITY_HEADERS = {
  'X-Content-Type-Options': 'nosniff',
  'X-Frame-Options': 'DENY',
  'X-XSS-Protection': '1; mode=block',
  'Referrer-Policy': 'no-referrer-when-downgrade'
}

// Helper function to determine cache strategy
function getCacheStrategy (url) {
  for (const [strategy, patterns] of Object.entries(CACHE_PATTERNS)) {
    if (patterns.some(pattern => pattern.test(url))) {
      return strategy
    }
  }
  return CACHE_STRATEGIES.NETWORK_FIRST
}

// Helper function to add security headers
function addSecurityHeaders (response) {
  const headers = new Headers(response.headers)
  Object.entries(SECURITY_HEADERS).forEach(([key, value]) => {
    headers.set(key, value)
  })
  return new Response(response.body, {
    status: response.status,
    statusText: response.statusText,
    headers
  })
}

// Safe resource fetching with timeout
async function safeFetch (request, timeout = 5000) {
  const fetchWithTimeout = Promise.race([
    fetch(request),
    new Promise((resolve, reject) =>
      setTimeout(() => reject(new Error('Fetch timeout')), timeout)
    )
  ])

  try {
    const response = await fetchWithTimeout
    return response
  } catch (error) {
    console.error('Fetch failed:', error)
    throw error
  }
}

// Network first strategy with offline fallback
async function networkFirst (request) {
  try {
    const networkResponse = await safeFetch(request)
    if (networkResponse.ok) {
      const cache = await caches.open(CACHE_NAME)
      cache.put(request, networkResponse.clone())
    }
    return networkResponse
  } catch (error) {
    const cachedResponse = await caches.match(request)
    if (cachedResponse) {
      return cachedResponse
    }
    // Custom offline page
    return new Response('Offline - 页面需要联网访问', {
      status: 503,
      statusText: 'Service Unavailable',
      headers: new Headers({
        'Content-Type': 'text/plain;charset=UTF-8'
      })
    })
  }
}

// Cache first strategy
async function cacheFirst (request) {
  const cachedResponse = await caches.match(request)
  if (cachedResponse) {
    return cachedResponse
  }

  try {
    const networkResponse = await safeFetch(request)
    if (networkResponse.ok) {
      const cache = await caches.open(CACHE_NAME)
      cache.put(request, networkResponse.clone())
    }
    return networkResponse
  } catch (error) {
    return new Response('Network offline', {
      status: 503,
      statusText: 'Service Unavailable'
    })
  }
}

// Stale while revalidate strategy
async function staleWhileRevalidate (request) {
  const cache = await caches.open(CACHE_NAME)
  const cachedResponse = await cache.match(request)

  const networkPromise = safeFetch(request).then(networkResponse => {
    if (networkResponse.ok) {
      cache.put(request, networkResponse.clone())
    }
    return networkResponse
  }).catch(() => cachedResponse)

  return cachedResponse || await networkPromise
}

// Install event - cache core resources
self.addEventListener('install', event => {
  console.log('Service Worker installing...')
  self.skipWaiting()

  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      return cache.addAll([
        '/',
        '/css/main.min.css',
        '/js/main.bundle.js',
        '/manifest.json',
        '/img/favicon.ico'
      ]).catch(error => {
        console.error('Failed to cache core resources:', error)
      })
    })
  )
})

// Activate event - clean old caches
self.addEventListener('activate', event => {
  console.log('Service Worker activating...')
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME && cacheName.startsWith('xguider-blog-')) {
            return caches.delete(cacheName)
          }
          return null
        })
      )
    }).then(() => self.clients.claim())
  )
})

// Fetch event - handle requests with security
self.addEventListener('fetch', event => {
  const { request } = event
  const url = new URL(request.url)

  // Skip non-GET requests
  if (request.method !== 'GET') {
    return
  }

  // Skip cross-origin requests that aren't whitelisted
  if (url.origin !== location.origin &&
      !CACHE_PATTERNS[CACHE_STRATEGIES.NETWORK_ONLY].some(pattern => pattern.test(url.href))) {
    return
  }

  const strategy = getCacheStrategy(url.href)

  event.respondWith(
    (async () => {
      let response

      switch (strategy) {
        case CACHE_STRATEGIES.NETWORK_ONLY:
          response = await safeFetch(request)
          break
        case CACHE_STRATEGIES.CACHE_FIRST:
          response = await cacheFirst(request)
          break
        case CACHE_STRATEGIES.STALE_WHILE_REVALIDATE:
          response = await staleWhileRevalidate(request)
          break
        default:
          response = await networkFirst(request)
      }

      // Add security headers
      response = addSecurityHeaders(response)
      return response
    })()
  )
})

// Background sync for offline actions
self.addEventListener('sync', event => {
  if (event.tag === 'syncAnalytics') {
    event.waitUntil(syncOfflineAnalytics())
  }
})

// Sync offline analytics when back online
async function syncOfflineAnalytics () {
  // Implementation for syncing offline events
  // This would use IndexedDB to store and sync events
  console.log('Syncing offline analytics...')
}

// Message event for handling updates
self.addEventListener('message', event => {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting()
  }
  if (event.data && event.data.type === 'GET_VERSION') {
    event.ports[0].postMessage({ version: SW_VERSION })
  }
})
