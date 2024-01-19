import './ripple'
import * as Popper from '../../vendors/popperjs/popper.min'
import bootstrap from '../../vendors/bootstrap/bootstrap.min'
import autosize from '../../vendors/autosize/autosize.min'
import Cleave from '../../vendors/cleavejs/cleave.min'
import { initAccordion } from './prenix_components/accordion'
import { initAlert } from './prenix_components/alert'
import { initAutocomplete, TomSelect } from './prenix_components/autocomplete'
import { initCheckboxGroup } from './prenix_components/checkbox_group'
import { initCheckbox } from './prenix_components/checkbox'
import { initDatepicker } from './prenix_components/datepicker'
import { initDropdown } from './prenix_components/dropdown'
import { initInput } from './prenix_components/input'
import { initToast } from './prenix_components/toast'
import { initSelect } from './prenix_components/select'
import {
  initThemeSwitcher,
  setDarkTheme,
  setLightTheme,
  currentTheme,
} from './prenix_components/theme_switcher'
import {
  setHasValue,
  randomString,
  getNavigatorLanguage,
  getDateFormatPattern,
  hide,
  show,
} from './prenix_components/utils'

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
  initSelect()
  initTooltip()
  initToast()
  initThemeSwitcher()
}

autoInit()

const prenix = {
  autoInit,
  initAccordion,
  initAlert,
  initAutocomplete,
  initCheckboxGroup,
  initCheckbox,
  initDatepicker,
  initDropdown,
  initInput,
  initSelect,
  initToast,
  initThemeSwitcher,
  utils: {
    setDarkTheme,
    setLightTheme,
    currentTheme,
    setHasValue,
    randomString,
    getNavigatorLanguage,
    getDateFormatPattern,
    hide,
    show,
  },
  vendors: {
    TomSelect,
    Popper,
    autosize,
    Cleave,
    Datepicker: window.Datepicker,
  },
}

export { prenix }
