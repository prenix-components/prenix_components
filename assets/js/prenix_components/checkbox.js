import { setSelected } from './utils'

const initCheckbox = (
  collection = document.querySelectorAll('[data-checkbox]'),
) => {
  collection.forEach(($c) => {
    const $input = $c.querySelector('input[type="checkbox"]')
    const $polyline = $c.querySelector('polyline')
    const $label = $c.querySelector('.checkbox-label')

    if ($label) {
      const labelText = $label.textContent.trim()
      $input.setAttribute('aria-label', labelText)
    }

    setSelected({ boolean: $input.checked, wrapper: $c, polyline: $polyline })

    $input.addEventListener('change', (e) => {
      const $c = e.target.closest('[data-checkbox]')
      const $polyline = $c.querySelector('polyline')
      const $input = $c.querySelector('input[type="checkbox"]')

      setTimeout(() => {
        setSelected({
          boolean: $input.checked,
          wrapper: $c,
          polyline: $polyline,
        })
      })
    })

    $input.addEventListener('click', (e) => {
      const $c = e.target.closest('[data-checkbox]')
      $c.dataset.focus = false
    })

    $input.addEventListener('focus', (e) => {
      const $c = e.target.closest('[data-checkbox]')
      $c.dataset.focus = true
    })

    $input.addEventListener('blur', (e) => {
      const $c = e.target.closest('[data-checkbox]')
      $c.dataset.focus = false
    })
  })
}

export { initCheckbox }
