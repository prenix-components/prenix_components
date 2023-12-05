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
    const hasLabel = $f.querySelector('label.field-label')
    if (hasLabel) $f.dataset.hasLabel = true

    const $input = $f.querySelector('input.field-input')
    if ($input.placeholder && $input.placeholder.length > 0)
      $f.dataset.hasPlaceholder = true

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
      },
      onDropdownClose: ($dropdownEl) => {
        const $a = $dropdownEl.closest('[data-autocomplete]')
        $a.dataset.focus = false
        const $select = $fw.querySelector('select')
        setHasValue({ value: $select.value, wrapper: $a })
      },
    })

    console.log('instance', instance)

    instance.on('item_select', () => {
      console.log('item select')
    })

    instance.on('change', () => {
      console.log('change')
      instance.blur()
    })

    const $controlInput = $a.querySelector('.ts-control input[role="combobox"]')

    if ($controlInput.placeholder && $controlInput.placeholder.length > 0)
      $a.dataset.hasPlaceholder = true
  })

  document
    .querySelectorAll('.ts-control input[role="combobox"]')
    .forEach(($i) => {
      $i.setAttribute('data-1p-ignore', '')
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

  dr._parent.addEventListener('show.bs.dropdown', (event) => {
    const $target = event.target
    $target
      .closest('.dropdown')
      .querySelector('.dropdown-menu')
      .classList.remove('hidden')
  })

  dr._parent.addEventListener('hide.bs.dropdown', (event) => {
    const $target = event.target
    $target
      .closest('.dropdown')
      .querySelector('.dropdown-menu')
      .classList.add('hidden')
  })
})

initAutocomplete()
initField()
initTooltip()

const autoInit = {
  initAutocomplete,
  initField,
  initTooltip,
}

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
