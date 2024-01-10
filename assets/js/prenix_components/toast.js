import { hide, show } from './utils'

const initToast = () => {
  const placements = ['top-right', 'top-left', 'bottom-right', 'bottom-left']
  placements.forEach((placement) => {
    const hasContainer = document.querySelector(
      `.toast-container--${placement}`,
    )

    if (!hasContainer) {
      const div = document.createElement('div')
      div.classList.add('toast-container', `toast-container--${placement}`)
      document.body.appendChild(div)
    }
  })

  document.querySelectorAll('[data-toast]').forEach(($baseEl) => {
    const $closeButton = $baseEl.querySelector('[data-dismiss]')
    const placement = $baseEl.dataset.placement
    const autoDismiss = $baseEl.dataset.autoDismiss
    const autoDismissDuration = $baseEl.dataset.autoDismissDuration
    const container = document.querySelector(`.toast-container--${placement}`)
    const $clone = $baseEl.cloneNode(true)
    let shouldAppend = !$baseEl.closest('.toast-container')

    if (shouldAppend) {
      $baseEl.remove()
      container.appendChild($clone)
    }

    if (autoDismiss === '') {
      const $el = shouldAppend ? $clone : $baseEl
      setTimeout(() => {
        hide($el)
      }, parseInt(autoDismissDuration))
    }

    if ($closeButton) {
      const $el = shouldAppend ? $clone : $baseEl
      const $elCloseButton = $el.querySelector('[data-dismiss]')

      $elCloseButton.addEventListener('click', () => {
        hide($el)
      })
    }
  })

  window.addEventListener('phx:hide_toast', (e) => {
    const selector = e.detail.selector

    if (selector) {
      const $el = document.querySelector(selector)

      if ($el) {
        hide($el)
      }
    }
  })

  window.addEventListener('phx:show_toast', (e) => {
    const selector = e.detail.selector

    if (selector) {
      const $el = document.querySelector(selector)

      if ($el) {
        show($el)
      }
    }
  })
}

export { initToast }
