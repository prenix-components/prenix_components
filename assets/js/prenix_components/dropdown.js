import bootstrap from '../../../vendors/bootstrap/bootstrap.min'

const initDropdown = () => {
  document.querySelectorAll('[data-dropdown]').forEach(($baseEl) => {
    const $toggle = $baseEl.querySelector('[data-bs-toggle]')

    const dropdownInstance = new bootstrap.Dropdown($toggle, {
      popperConfig(defaultBsPopperConfig) {
        let { modifiers } = defaultBsPopperConfig
        return { ...defaultBsPopperConfig, strategy: 'fixed', modifiers }
      },
    })

    dropdownInstance._parent.addEventListener('show.bs.dropdown', async (e) => {
      const $target = e.target
      const $menuInner = $target
        .closest('.dropdown')
        .querySelector('.dropdown-menu-inner')

      setTimeout(() => $menuInner.classList.add('open'))
    })

    dropdownInstance._parent.addEventListener('hide.bs.dropdown', (e) => {
      const $target = e.target
      const $menuInner = $target
        .closest('.dropdown')
        .querySelector('.dropdown-menu-inner')

      $menuInner.classList.remove('open')
    })
  })

  document.querySelectorAll('.dropdown-item').forEach(($di) => {
    $di.addEventListener('mouseover', (e) => {
      e.stopPropagation()
      $di.dataset.hover = true
    })

    $di.addEventListener('mouseout', (e) => {
      e.stopPropagation()
      $di.dataset.hover = false
    })
  })
}

export { initDropdown }
