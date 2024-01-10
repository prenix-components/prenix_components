import { hide } from './utils'

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
    container.appendChild($baseEl)

    if (autoDismiss === '') {
      setTimeout(() => {
        hide($baseEl)
      }, parseInt(autoDismissDuration))
    }

    if ($closeButton) {
      $closeButton.addEventListener('click', () => {
        hide($baseEl)
      })
    }
  })
}

export { initToast }
