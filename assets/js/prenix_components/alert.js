import { hide } from './utils'

const initAlert = () => {
  document.querySelectorAll('[data-alert]').forEach(($baseEl) => {
    const $closeButton = $baseEl.querySelector('[data-dismiss]')

    if ($closeButton) {
      $closeButton.addEventListener('click', () => {
        hide($baseEl)
      })
    }
  })
}

export { initAlert }
