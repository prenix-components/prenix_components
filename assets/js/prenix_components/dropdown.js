import bootstrap from '../../../vendors/bootstrap/bootstrap.min'

const initDropdown = () => {
  document.querySelectorAll('[data-dropdown]').forEach(($baseEl) => {
    const $toggle = $baseEl.querySelector('[data-bs-toggle]')
    const variant = $baseEl.dataset.variant

    const dropdownItems = $baseEl.querySelectorAll('.dropdown-item')
    dropdownItems.forEach(($di) => {
      $di.classList.add(`dropdown-item--${variant}`)
    })

    const dropdownInstance = new bootstrap.Dropdown($toggle, {
      popperConfig(defaultBsPopperConfig) {
        let { modifiers } = defaultBsPopperConfig
        return { ...defaultBsPopperConfig, strategy: 'fixed', modifiers }
      },
    })

    dropdownInstance._parent.addEventListener('show.bs.dropdown', async (e) => {
      const $target = e.target
      const $content = $target
        .closest('.dropdown')
        .querySelector('.dropdown-content')

      setTimeout(() => $content.classList.add('open'))
    })

    dropdownInstance._parent.addEventListener('hide.bs.dropdown', (e) => {
      const $target = e.target
      const $content = $target
        .closest('.dropdown')
        .querySelector('.dropdown-content')

      $content.classList.remove('open')
    })
  })

  document.querySelectorAll('.dropdown-item').forEach(($di) => {
    $di.addEventListener('mouseover', (e) => {
      e.stopPropagation()
      $di.focus()
      $di.dataset.hover = true
    })

    $di.addEventListener('blur', (e) => {
      e.stopPropagation()
      $di.dataset.hover = false
    })

    $di.addEventListener('mouseout', (e) => {
      e.stopPropagation()
      $di.dataset.hover = false
    })
  })
}

export { initDropdown }
