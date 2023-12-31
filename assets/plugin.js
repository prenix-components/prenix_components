const plugin = require('tailwindcss/plugin')

module.exports = plugin(
  function ({ addUtilities }) {
    addUtilities({
      'opacity-disabled': {
        opacity: 'var(--disabled-opacity)',
      },
      '.shadow-small': {
        boxShadow: 'var(--shadow-sm)',
      },
      '.shadow-medium': {
        boxShadow: 'var(--shadow-md)',
      },
      '.shadow-large': {
        boxShadow: 'var(--shadow-lg)',
      },
    })
  },
  {
    theme: {
      extend: {
        colors: {
          background: 'hsl(var(--background) / <alpha-value>)',
          foreground: 'hsl(var(--foreground) / <alpha-value>)',
          default: 'hsl(var(--default) / <alpha-value>)',
          'default-foreground':
            'hsl(var(--default-foreground) / <alpha-value>)',
          primary: 'hsl(var(--primary) / <alpha-value>)',
          'primary-foreground':
            'hsl(var(--primary-foreground) / <alpha-value>)',
          secondary: 'hsl(var(--secondary) / <alpha-value>)',
          'secondary-foreground':
            'hsl(var(--secondary-foreground) / <alpha-value>)',
          success: 'hsl(var(--success) / <alpha-value>)',
          'success-foreground':
            'hsl(var(--success-foreground) / <alpha-value>)',
          warning: 'hsl(var(--warning) / <alpha-value>)',
          'warning-foreground':
            'hsl(var(--warning-foreground) / <alpha-value>)',
          danger: 'hsl(var(--danger) / <alpha-value>)',
          'danger-foreground': 'hsl(var(--danger-foreground) / <alpha-value>)',
          content: 'hsl(var(--content) / <alpha-value>)',
          'content-foreground':
            'hsl(var(--content-foreground) / <alpha-value>)',
          'neutral1-foreground':
            'hsl(var(--neutral1-foreground) / <alpha-value>)',
          'neutral2-foreground':
            'hsl(var(--neutral2-foreground) / <alpha-value>)',
          'neutral3-foreground':
            'hsl(var(--neutral3-foreground) / <alpha-value>)',
          focus: 'hsl(var(--focus) / <alpha-value>)',
          ripple: 'hsl(var(--ripple) / var(--ripple-opacity))',
          divider: 'hsl(var(--divider) / var(--divider-opacity))',
          overlay: 'hsl(var(--overlay) / var(--overlay-opacity))',
        },
      },
    },
  },
)
