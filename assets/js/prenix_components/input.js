import { setHasValue } from './utils'

const initInput = () => {
  document.querySelectorAll('[data-input]').forEach(($baseEl) => {
    const $label = $baseEl.querySelector('.input-label')
    const $input = $baseEl.querySelector('.input')

    if ($input.placeholder && $input.placeholder.length > 0) {
      $baseEl.dataset.hasPlaceholder = true
    }

    if ($label) {
      $baseEl.dataset.hasLabel = true
      const labelText = $label.textContent.trim()
      $input.setAttribute('aria-label', labelText)
    }

    setHasValue({ value: $input.value, $wrapper: $baseEl })

    $input.addEventListener('focus', () => {
      $baseEl.dataset.focus = true
    })

    $input.addEventListener('blur', () => {
      $baseEl.dataset.focus = false
    })

    $input.addEventListener('change', (e) => {
      setHasValue({ value: e.target.value, $wrapper: $baseEl })
    })

    const $inputWrapper = $baseEl.querySelector('.input-wrapper')

    $inputWrapper.addEventListener('click', () => {
      $input.focus()
    })
  })
}

export { initInput }
