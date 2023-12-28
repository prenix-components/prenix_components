const setSelected = ({ boolean, $wrapper, $polyline }) => {
  if (boolean) {
    $wrapper.dataset.jsSelected = true
    $polyline.setAttribute('stroke-dashoffset', 44)
  } else {
    $polyline.setAttribute('stroke-dashoffset', 66)
    $wrapper.dataset.jsSelected = false
  }
}

const initCheckbox = (
  collection = document.querySelectorAll('[data-checkbox]'),
) => {
  collection.forEach(($baseEl) => {
    const $input = $baseEl.querySelector('input[type="checkbox"]')
    const $polyline = $baseEl.querySelector('polyline')
    const $label = $baseEl.querySelector('.checkbox-label')

    if ($label) {
      const labelText = $label.textContent.trim()
      $input.setAttribute('aria-label', labelText)
    }

    setSelected({ boolean: $input.checked, $wrapper: $baseEl, $polyline })

    $input.addEventListener('change', () => {
      setTimeout(() => {
        setSelected({
          boolean: $input.checked,
          $wrapper: $baseEl,
          $polyline,
        })
      })
    })

    $input.addEventListener('click', () => {
      $baseEl.dataset.jsFocus = false
    })

    $input.addEventListener('focus', () => {
      $baseEl.dataset.jsFocus = true
    })

    $input.addEventListener('blur', () => {
      $baseEl.dataset.jsFocus = false
    })
  })
}

export { initCheckbox }
