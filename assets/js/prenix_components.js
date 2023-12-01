import * as preline from '../../vendors/preline/preline.min'
import './ripple'

window.preline = preline

window.addEventListener('click', (e) => {
  const $targetEl = e.target
  const $dropdownItemEl = $targetEl.closest('.dropdown-item')

  if ($dropdownItemEl) {
    const $dropdownEl = $dropdownItemEl.closest('.dropdown')
    if ($dropdownEl) {
      preline.HSDropdown.close($dropdownEl)
    }
  }
})
