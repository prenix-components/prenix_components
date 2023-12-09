import './ripple'
// import TomSelect from '../../vendors/tom-select/tom-select.base'

// import TomSelect from '../../vendors/tom-select/tom-select.base.min'
// import TomSelect from '../../vendors/tom-select/tom-select.complete.min'

import * as Popper from '../../vendors/popperjs/popper.min'
import bootstrap from '../../vendors/bootstrap/bootstrap.min'

import { initAutocomplete, TomSelect } from './prenix_components/autocomplete'
import { initCheckbox } from './prenix_components/checkbox'
import { initCheckboxGroup } from './prenix_components/checkbox_group'

const prenixModules = {
  TomSelect,
  Popper,
  bootstrap,
}

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

const initTooltip = () => {
  document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(($t) => {
    new bootstrap.Tooltip($t)
  })
}

document.querySelectorAll('.dropdown-toggle').forEach(($dt) => {
  const dr = new bootstrap.Dropdown($dt, {
    popperConfig(defaultBsPopperConfig) {
      // console.log({ defaultBsPopperConfig })
      let { modifiers } = defaultBsPopperConfig
      // // modifiers.push({
      // //   name: 'flip',
      // //   options: {
      // //     fallbackPlacements: ['left'],
      // //     rootBoundary: 'document',
      // //   },
      // // })

      // modifiers = modifiers.filter((m) => m.name !== 'preventOverflow')
      // modifiers.push({
      //   name: 'preventOverflow',
      //   options: {
      //     // mainAxis: true, // false by default
      //     altBoundary: true, // false by defaul
      //   },
      // })
      // // console.log({ modifiers })
      return { ...defaultBsPopperConfig, strategy: 'fixed', modifiers }
    },
  })

  dr._parent.addEventListener('show.bs.dropdown', async (e) => {
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

document.querySelectorAll('.dropdown-item').forEach(($di) => {
  $di.addEventListener('mouseover', (e) => {
    e.stopPropagation()
    const $target = e.target

    if (!$target.classList.contains('dropdown-menu-inner')) {
      $di.dataset.hover = true
    }
  })

  $di.addEventListener('mouseout', (e) => {
    e.stopPropagation()

    $di.dataset.hover = false
  })
})

const autoInit = () => {
  initAutocomplete()
  initCheckbox()
  initCheckboxGroup()
  initField()
  initTooltip()
}

autoInit()

export { autoInit, prenixModules }
