import { setHasValue, debounce } from './utils'
import bootstrap from '../../../vendors/bootstrap/bootstrap.min'

const initSelect = () => {
  document.querySelectorAll('[data-select]').forEach(($baseEl) => {
    const $label = $baseEl.querySelector('.select-label')
    const $toggle = $baseEl.querySelector('[data-bs-toggle]')
    const $input = $baseEl.querySelector('[data-select-el]')
    const $value = $baseEl.querySelector('[data-select-value')
    const width = $input.offsetWidth
    const dropdownInstance = bootstrap.Dropdown.getInstance($toggle)
    const $dropdown = $baseEl.querySelector('.dropdown-menu')
    $dropdown.style.width = `${width}px`
    // $dropdown.style
    console.log('dropdownInstance', dropdownInstance)

    // console.log('dropdownInstance')

    // console.log({ $select })
    if ($input.placeholder && $input.placeholder.length > 0) {
      $baseEl.dataset.jsHasPlaceholder = true
    }

    if ($label) {
      const labelText = $label.textContent.trim()

      if (labelText.length > 0) {
        $baseEl.dataset.jsHasLabel = true
        $input.setAttribute('aria-label', labelText)
      }
    }

    setHasValue({ value: $input.value, $wrapper: $baseEl })

    // $select.addEventListener('focus', () => {
    //   $baseEl.dataset.jsFocus = true
    // })

    // $select.addEventListener('blur', () => {
    //   $baseEl.dataset.jsFocus = false
    // })

    // $select.addEventListener('change', (e) => {
    //   setHasValue({ value: e.target.value, $wrapper: $baseEl })
    // })

    const $selectWrapper = $baseEl.querySelector('.select-wrapper')

    $selectWrapper.addEventListener('click', () => {
      console.log('wrapper clicked')
      // if ()
      if (!dropdownInstance._isShown()) {
        setTimeout(() => {
          dropdownInstance.show()
        }, 100)
      }
    })

    $selectWrapper.addEventListener('focus', () => {
      console.log('focus')

      $baseEl.dataset.jsFocus = true
      // $selectWrapper.click()
    })

    $selectWrapper.addEventListener('blur', () => {
      console.log('focus')

      $baseEl.dataset.jsFocus = false
      // $selectWrapper.click()
    })

    dropdownInstance._parent.addEventListener('show.bs.dropdown', async (e) => {
      $baseEl.dataset.jsFocus = true
      // dropdownInstance.focus()
      setTimeout(() => {
        // dropdownInstance._menu.focus()
        $baseEl.querySelector('.dropdown-item').focus()
        // $toggle.focus()
        // $toggleBtn.click()
      }, 100)
      // dropdownInstance._parent.focus()
      // dropdownInstance._parent.focus()
    })

    dropdownInstance._parent.addEventListener('hide.bs.dropdown', (e) => {
      $baseEl.dataset.jsFocus = false
    })
  })

  const onKeyDown = (x, y, z) => {
    console.log({ x, y, z })
  }

  window.addEventListener('keyup', (e) => {
    console.log({ e })
  })
}

export { initSelect }
