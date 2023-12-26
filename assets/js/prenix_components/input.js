import { setHasValue } from './utils'
import autosize from '../../../vendors/autosize/autosize.min'

const initInput = () => {
  document.querySelectorAll('[data-input]').forEach(($baseEl) => {
    const $label = $baseEl.querySelector('.input-label')
    const $input = $baseEl.querySelector('.input-el')

    if ($input.placeholder && $input.placeholder.length > 0) {
      $baseEl.dataset.hasPlaceholder = true
    }

    if ($label) {
      const labelText = $label.textContent.trim()

      if (labelText.length > 0) {
        $baseEl.dataset.hasLabel = true
        $input.setAttribute('aria-label', labelText)
      }
    }

    setHasValue({ value: $input.value, $wrapper: $baseEl })

    if ($input.tagName === 'TEXTAREA') {
      autosize($input)
    }

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

    $baseEl.querySelectorAll('.input-content').forEach(($c) => {
      if ($c.innerHTML.trim().length === 0) {
        $c.remove()
      }
    })
  })
}

export { initInput, autosize }
