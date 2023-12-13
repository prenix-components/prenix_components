import bootstrap from '../../../vendors/bootstrap/bootstrap.min'

const initPopover = () => {
  document.querySelectorAll('[data-popover]').forEach(($dt) => {
    const dr = new bootstrap.Dropdown($dt, {
      popperConfig(defaultBsPopperConfig) {
        let { modifiers } = defaultBsPopperConfig
        return { ...defaultBsPopperConfig, strategy: 'fixed', modifiers }
      },
    })

    dr._parent.addEventListener('show.bs.dropdown', async (e) => {
      const $target = e.target
      const $popover = $target
        .closest('.popover-base')
        .querySelector('.popover')

      console.log('popover', $popover)
      setTimeout(() => $popover.classList.add('open'))
    })

    dr._parent.addEventListener('hide.bs.dropdown', (e) => {
      const $target = e.target
      const $popover = $target
        .closest('.popover-base')
        .querySelector('.popover')

      $popover.classList.remove('open')
    })
  })
}

export { initPopover }
