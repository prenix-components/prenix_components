const initToast = () => {
  ;['top-right', 'top-left', 'bottom-right', 'bottom-left'].forEach(
    (placement) => {
      const hasContainer = document.querySelector(
        `.toast-container--${placement}`,
      )

      if (!hasContainer) {
        const div = document.createElement('div')
        div.classList.add('toast-container', `toast-container--${placement}`)
        document.body.appendChild(div)
      }
    },
  )

  document.querySelectorAll('[data-toast]').forEach(($baseEl) => {
    const $closeButton = $baseEl.querySelector('[data-bs-dismiss="toast"]')
    const placement = $baseEl.dataset.placement
    const autoDismiss = $baseEl.dataset.autoDismiss
    const autoDismissDuration = $baseEl.dataset.autoDismissDuration
    console.log('placement', placement)

    const container = document.querySelector(`.toast-container--${placement}`)
    container.appendChild($baseEl)

    if (autoDismiss === '') {
      setTimeout(() => {
        $baseEl.remove()
      }, parseInt(autoDismissDuration))
    }

    if ($closeButton) {
      $closeButton.addEventListener('click', () => {
        $baseEl.remove()
      })
    }
  })
}

export { initToast }
