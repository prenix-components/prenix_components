import './ripple'
import * as Popper from '../../vendors/popperjs/popper.min'
import bootstrap from '../../vendors/bootstrap/bootstrap.min'

import { initAutocomplete, TomSelect } from './prenix_components/autocomplete'
import { initCheckbox } from './prenix_components/checkbox'
import { initCheckboxGroup } from './prenix_components/checkbox_group'
import { initDropdown } from './prenix_components/dropdown'
import { initInput } from './prenix_components/input'
import { initPopover } from './prenix_components/popover'
import './prenix_components/datepicker'

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

const autoInit = () => {
  initAutocomplete()
  initCheckbox()
  initCheckboxGroup()
  initDropdown()
  initInput()
  initPopover()
  initTooltip()
}

autoInit()

export { autoInit, prenixModules }
