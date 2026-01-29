module.exports = {
  ci: {
    collect: {
      url: ['http://localhost:4000/', 'http://localhost:4000/about/'],
      startServerCommand: 'bundle exec jekyll serve',
      startServerReadyPattern: 'done in'
    },
    assert: {
      assertions: {
        'categories:performance': ['error', {minScore: 0.9}],
        'categories:accessibility': ['error', {minScore: 0.95}],
        'categories:best-practices': ['error', {minScore: 0.9}],
        'categories:seo': ['error', {minScore: 0.95}],
        'categories:pwa': ['error', {minScore: 0.8}],

        // Performance-specific audits
        'first-contentful-paint': ['error', {maxNumericValue: 1500}],
        'largest-contentful-paint': ['error', {maxNumericValue: 2500}],
        'first-meaningful-paint': ['error', {maxNumericValue: 2000}],
        'speed-index': ['error', {maxNumericValue: 4000}],
        'total-blocking-time': ['error', {maxNumericValue: 500}],
        'cumulative-layout-shift': ['error', {maxNumericValue: 0.1}],

        // Accessibility specific checks
        'color-contrast': 'off',
        'html-has-lang': 'error',
        'aria-label': 'error',
        'aria-required-attr': 'error',
        'duplicate-id-aria': 'error',

        // Best Practices checks
        'no-vulnerable-libraries': 'error',
        'deprecated-apis': 'warn',
        'no-unload-listeners': 'error',
        'notification-on-start': 'error',
        'password-inputs-can-be-pasted-into': 'error'
      }
    },
    upload: {
      target: 'temporary-public-storage'
    }
  }
}