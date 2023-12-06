import './ripple'
import TomSelect from '../../vendors/tom-select/tom-select.complete.min'
import bootstrap from '../../vendors/bootstrap/bootstrap.bundle.min'

const setHasValue = ({ value, wrapper }) => {
  if (value.length > 0) {
    wrapper.dataset.hasValue = true
  } else {
    wrapper.dataset.hasValue = false
  }
}

const initField = () => {
  document.querySelectorAll('[data-field]').forEach(($f) => {
    const $label = $f.querySelector('label.field-label')
    const $input = $f.querySelector('input.field-input')

    if ($input.placeholder && $input.placeholder.length > 0) {
      $f.dataset.hasPlaceholder = true
    }

    if ($label) {
      $f.dataset.hasLabel = true
      const labelText = $label.textContent.trim()
      $input.setAttribute('aria-label', labelText)
    }

    setHasValue({ value: $input.value, wrapper: $f })

    $input.addEventListener('focus', () => {
      const $fw = $input.closest('[data-field]')
      $fw.dataset.focus = true
    })

    $input.addEventListener('blur', () => {
      const $fw = $input.closest('[data-field]')
      $fw.dataset.focus = false
    })

    $input.addEventListener('change', (e) => {
      setHasValue({ value: e.target.value, wrapper: $f })
    })

    const $fw = $f.querySelector('.field-wrapper')

    $fw.addEventListener('click', () => {
      const $i = $fw.querySelector('.field-input')
      if ($i) $i.focus()
    })
  })
}

const initAutocomplete = () => {
  document.querySelectorAll('[data-autocomplete]').forEach(($a) => {
    const hasLabel = $a.querySelector('label.field-label')
    if (hasLabel) $a.dataset.hasLabel = true

    const $fw = $a.querySelector('.field-wrapper')

    $fw.addEventListener('click', () => {
      const $select = $fw.querySelector('select')
      if ($select) {
        const control = $select.tomselect
        control.open()
      }
    })

    const $select = $a.querySelector('select')
    setHasValue({ value: $select.value, wrapper: $a })

    const instance = new TomSelect($select, {
      onDropdownOpen: ($dropdownEl) => {
        const $a = $dropdownEl.closest('[data-autocomplete]')
        $a.dataset.focus = true

        const $dropdownContent = $a.querySelector('.ts-dropdown-content')
        setTimeout(() => $dropdownContent.classList.add('open'))
      },
      onDropdownClose: ($dropdownEl) => {
        const $a = $dropdownEl.closest('[data-autocomplete]')
        $a.dataset.focus = false
        const $select = $fw.querySelector('select')
        setHasValue({ value: $select.value, wrapper: $a })

        const $dropdownContent = $a.querySelector('.ts-dropdown-content')
        setTimeout(() => $dropdownContent.classList.remove('open'))
      },
    })

    instance.on('change', () => {
      instance.blur()
    })

    const $controlInput = $a.querySelector('.ts-control input[role="combobox"]')

    if ($controlInput.placeholder && $controlInput.placeholder.length > 0)
      $a.dataset.hasPlaceholder = true

    $controlInput.setAttribute('data-1p-ignore', '')
  })
}

const initTooltip = () => {
  document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(($t) => {
    new bootstrap.Tooltip($t)
  })
}

document.querySelectorAll('.dropdown-toggle').forEach(($dt) => {
  const dr = new bootstrap.Dropdown($dt, {
    popperConfig(defaultBsPopperConfig) {
      return { ...defaultBsPopperConfig, strategy: 'fixed' }
    },
  })

  dr._parent.addEventListener('show.bs.dropdown', (e) => {
    const $target = e.target
    const $menuInner = $target
      .closest('.dropdown')
      .querySelector('.dropdown-menu-inner')

    setTimeout(() => $menuInner.classList.add('open'))
  })

  dr._parent.addEventListener('hide.bs.dropdown', (e) => {
    const $target = e.target
    const $menuInner = $target
      .closest('.dropdown')
      .querySelector('.dropdown-menu-inner')

    $menuInner.classList.remove('open')
  })
})

const setSelected = ({ boolean, wrapper, polyline }) => {
  if (boolean) {
    wrapper.dataset.selected = true
    polyline.setAttribute('stroke-dashoffset', 44)
  } else {
    polyline.setAttribute('stroke-dashoffset', 66)
    wrapper.dataset.selected = false
  }
}

const initCheckbox = () => {
  document.querySelectorAll('[data-checkbox]').forEach(($c) => {
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
      setSelected({
        boolean: e.target.checked,
        wrapper: $c,
        polyline: $polyline,
      })
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

  document.querySelectorAll('[data-checkbox-group]').forEach(($cg) => {
    const $label = $cg.querySelector('.checkbox-group-label')

    if ($label) {
      const labelText = $label.textContent.trim()
      $cg.setAttribute('aria-label', labelText)
    }
  })
}

const autoInit = () => {
  initAutocomplete()
  initCheckbox()
  initField()
  initTooltip()
}

autoInit()

export { TomSelect, bootstrap, autoInit }

// window.preline = preline

// window.addEventListener('click', (e) => {
//   const $targetEl = e.target
//   const $dropdownItemEl = $targetEl.closest('.dropdown-item')
//   const $modalCloseEl = $targetEl.closest('[data-modal-close]')

//   const $modalOpenEl = $targetEl.closest('[data-modal-open]')

//   if ($dropdownItemEl) {
//     const $dropdownEl = $dropdownItemEl.closest('.dropdown')

//     if ($dropdownEl) {
//       preline.HSDropdown.close($dropdownEl)
//     }
//   } else if ($modalCloseEl) {
//     const $modalEl = $modalCloseEl.closest('.modal')

//     if ($modalEl) {
//       preline.HSOverlay.close($modalEl)
//     }
//   } else if ($modalOpenEl) {
//     const modalTarget = $modalOpenEl.dataset.modalOpen
//     const $modalEl = document.querySelector(modalTarget)

//     if ($modalEl) {
//       // const element = preline.HSOverlay.getInstance(modalTarget)

//       // console.log('element', element)
//       console.log('$modalTarget', modalTarget)
//       console.log('$modalEl', $modalEl)

//       preline.HSOverlay.open($modalEl)

//       // console.log('$modalEl', $modalEl)
//       // const modal = new preline.HSOverlay($modalEl)
//       // console.log('$modal', modal)
//       // element.open()
//       // preline.HSOverlay.open(modalTarget)
//     }
//   }
// })
