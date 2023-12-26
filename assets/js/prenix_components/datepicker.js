import '../../../vendors/vanillajs-datepicker/datepicker-full.min'
import Cleave from '../../../vendors/cleavejs/cleave.min'

import {
  setHasValue,
  getNavigatorLanguage,
  getDateFormatPattern,
} from './utils'

const dateFormat = getDateFormatPattern(getNavigatorLanguage())

const getDateDelimiter = (format) => {
  switch (true) {
    case format.indexOf(' ') !== -1:
      return ' '
    case format.indexOf('-') !== -1:
      return '-'
    case format.indexOf('.') !== -1:
      return '.'
    default:
      return '/'
  }
}

const dateDelimiter = getDateDelimiter(dateFormat)

const getDatePattern = (format) => {
  const dateFormatArr = format.split(dateDelimiter)
  const patternArr = []
  dateFormatArr.forEach((p) => {
    if (p.includes('y')) {
      patternArr.push('Y')
    } else if (p.includes('m')) {
      patternArr.push('m')
    } else {
      patternArr.push('d')
    }
  })

  return patternArr
}

const datePattern = getDatePattern(dateFormat)

const yearIndex = datePattern.indexOf('Y')
const monthIndex = datePattern.indexOf('m')
const dayIndex = datePattern.indexOf('d')

const getPlaceholder = (pattern) => {
  const placeholderArr = []

  pattern.forEach((p) => {
    if (p.includes('Y')) {
      placeholderArr.push('yyyy')
    } else if (p.includes('m')) {
      placeholderArr.push('mm')
    } else {
      placeholderArr.push('dd')
    }
  })

  return placeholderArr.join(dateDelimiter)
}

const initDatepicker = () => {
  document.querySelectorAll('[data-datepicker]').forEach(($baseEl) => {
    const $input = $baseEl.querySelector('input')
    const $hiddenInput = document.querySelector($input.dataset.target)
    const $clearBtn = $baseEl.querySelector('.datepicker-clear-btn')
    const optsStr = $baseEl.dataset.datepickerOpts
    const opts = JSON.parse(optsStr)
    $input.placeholder = getPlaceholder(datePattern)
    let defaultValue = $input.value

    const datepicker = new window.Datepicker($input, {
      todayButton: true,
      todayHighlight: true,
      todayButtonMode: 1,
      buttonClass: 'btn btn-ripple btn-default btn-ghost btn-sm btn-radius-lg',
      prevArrow: `<span class="btn-content"><span class="ion-chevron-back icon icon-current icon-sm"></span></span>`,
      nextArrow: `<span class="btn-content"><span class="ion-chevron-forward icon icon-current icon-sm"></span></span>`,
      format: {
        toValue(date, _format, _locale) {
          let dateStr = defaultValue

          if (defaultValue) {
            defaultValue = null
            return new Date(dateStr)
          }

          dateStr = date
          const dateArr = dateStr.split(dateDelimiter)

          // Return UTC date
          return new Date(
            `${dateArr[yearIndex]}-${dateArr[monthIndex]}-${dateArr[dayIndex]}`,
          )
        },
        toDisplay(date, _format, _locale) {
          const dateObj = new Date(date)
          return new Intl.DateTimeFormat(getNavigatorLanguage()).format(dateObj)
        },
      },
    })

    $input.addEventListener('changeDate', (e) => {
      const value = e.target.value
      setHasValue({ value, $wrapper: $baseEl })
      const date = e.detail.date
      if (date) $hiddenInput.value = date.toISOString()
    })

    $clearBtn.addEventListener('click', (e) => {
      datepicker.setDate({ clear: true })
      $input.value = ''
      $hiddenInput.value = ''
      setHasValue({ value: '', $wrapper: $baseEl })
      e.stopPropagation()
    })

    new Cleave($input, {
      date: true,
      delimiter: dateDelimiter,
      datePattern: datePattern,
    })
  })
}

export { initDatepicker }
