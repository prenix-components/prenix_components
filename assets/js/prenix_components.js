import './ripple'
import * as Popper from '../../vendors/popperjs/popper.min'
import bootstrap from '../../vendors/bootstrap/bootstrap.min'

import { initAccordion } from './prenix_components/accordion'
import { initAvatar } from './prenix_components/avatar'
import { initAutocomplete, TomSelect } from './prenix_components/autocomplete'
import { initCheckbox } from './prenix_components/checkbox'
import { initCheckboxGroup } from './prenix_components/checkbox_group'
import { initDatepicker } from './prenix_components/datepicker'
import { initDropdown } from './prenix_components/dropdown'
import { initInput, autosize } from './prenix_components/input'

const prenixModules = {
  TomSelect,
  Popper,
  bootstrap,
  autosize,
}

const initTooltip = () => {
  document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(($t) => {
    new bootstrap.Tooltip($t)
  })
}

const autoInit = () => {
  initAccordion()
  initAutocomplete()
  initAvatar()
  initCheckbox()
  initCheckboxGroup()
  initDatepicker()
  initDropdown()
  initInput()
  initTooltip()
}

autoInit()

export { autoInit, prenixModules }
