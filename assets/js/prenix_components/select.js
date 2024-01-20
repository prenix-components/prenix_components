import { setHasValue } from './utils'
import bootstrap from '../../../vendors/bootstrap/bootstrap.min'

let query = ''
let typingTimer //timer identifier
const doneTypingInterval = 500 //time in ms

const doneTyping = () => {
  if (query.length > 0) {
    const $dropdownMenu = document.querySelector(
      '[data-select] .dropdown-menu.show',
    )

    if ($dropdownMenu) {
      const $options = $dropdownMenu.querySelectorAll('[data-select-option]')

      const found = Array.from($options).find(($o) =>
        $o.innerText.toLowerCase().startsWith(query),
      )

      if (found) {
        found.focus()
      }
    }

    setTimeout(() => {
      query = ''
    }, 500)
  }
}

const keyUp = (e) => {
  const key = e.key.toLowerCase()

  const re = new RegExp(/[a-zA-Z0-9]/g)

  if (key.length === 1 && key.match(re)) {
    query = query += key
  }

  typingTimer = setTimeout(doneTyping, doneTypingInterval)
}

const initSelect = () => {
  document.querySelectorAll('[data-select]').forEach(($baseEl) => {
    const $label = $baseEl.querySelector('.select-label')
    const $toggle = $baseEl.querySelector('[data-bs-toggle]')
    const $input = $baseEl.querySelector('[data-select-el]')
    const $value = $baseEl.querySelector('[data-select-value')
    const $selectWrapper = $baseEl.querySelector('.select-wrapper')
    const dropdownInstance = bootstrap.Dropdown.getInstance($toggle)
    const $dropdown = $baseEl.querySelector('.dropdown-menu')
    const $option = $baseEl.querySelectorAll('[data-select-option]')

    const computedStyle = window.getComputedStyle($selectWrapper)
    const paddingX =
      parseFloat(computedStyle.paddingLeft) +
      parseFloat(computedStyle.paddingRight)
    const width = $selectWrapper.offsetWidth - paddingX

    $dropdown.style.width = `${width}px`

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

    const handleDropdown = (e) => {
      if (!dropdownInstance._isShown()) {
        setTimeout(() => {
          dropdownInstance.show()
        }, 150)
      }
    }

    setHasValue({ value: $input.value, $wrapper: $baseEl })

    $selectWrapper.addEventListener('click', handleDropdown)
    $selectWrapper.addEventListener('focus', handleDropdown)

    dropdownInstance._parent.addEventListener('show.bs.dropdown', (e) => {
      window.addEventListener('keyup', keyUp)

      $baseEl.dataset.jsFocus = true

      const value = $value.value

      const selectedDropdownItem = $baseEl.querySelector(
        `[data-select-option][data-value="${value}"]`,
      )

      setTimeout(() => {
        if (selectedDropdownItem) {
          selectedDropdownItem.focus()
        } else {
          $baseEl.querySelector('.dropdown-item').focus()
        }
      })
    })

    dropdownInstance._parent.addEventListener('hide.bs.dropdown', (e) => {
      window.removeEventListener('keyup', keyUp)

      $baseEl.dataset.jsFocus = false
    })

    $option.forEach(($o) => {
      $o.addEventListener('click', () => {
        const value = $o.dataset.value
        const name = $o.dataset.name
        $input.value = name
        $value.value = value

        setHasValue({ value: name, $wrapper: $baseEl })

        setTimeout(() => {
          $o.closest('.dropdown-content')
            .querySelectorAll('[data-select-option]')
            .forEach(($o2) => {
              $o2.dataset.selected = false
            })

          $o.dataset.selected = true
        })
      })
    })
  })
}

export { initSelect }
