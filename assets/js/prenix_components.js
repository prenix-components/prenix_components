import './ripple'
import * as Popper from '../../vendors/popperjs/popper.min'
import bootstrap from '../../vendors/bootstrap/bootstrap.min'

import { initAutocomplete, TomSelect } from './prenix_components/autocomplete'
import { initCheckbox } from './prenix_components/checkbox'
import { initCheckboxGroup } from './prenix_components/checkbox_group'
import { initInput } from './prenix_components/input'

const prenixModules = {
  TomSelect,
  Popper,
  bootstrap,
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
  initInput()
  initTooltip()
}

autoInit()

export { autoInit, prenixModules }
