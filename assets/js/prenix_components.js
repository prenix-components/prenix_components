import './ripple'
import * as Popper from '../../vendors/popperjs/popper.min'
import bootstrap from '../../vendors/bootstrap/bootstrap.min'

import { initAccordion } from './prenix_components/accordion'
import { initAlert } from './prenix_components/alert'
import { initAutocomplete, TomSelect } from './prenix_components/autocomplete'
import { initCheckbox } from './prenix_components/checkbox'
import { initCheckboxGroup } from './prenix_components/checkbox_group'
import { initDatepicker } from './prenix_components/datepicker'
import { initDropdown } from './prenix_components/dropdown'
import { initInput, autosize } from './prenix_components/input'
import { initToast } from './prenix_components/toast'

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
  initAlert()
  initAutocomplete()
  initCheckbox()
  initCheckboxGroup()
  initDatepicker()
  initDropdown()
  initInput()
  initTooltip()
  initToast()
}

autoInit()

export { autoInit, prenixModules }
