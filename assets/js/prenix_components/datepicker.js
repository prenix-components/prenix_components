import '../../../vendors/vanillajs-datepicker/datepicker-full.min'
import { setHasValue, getNavigatorLanguage } from './utils'

const initDatepicker = () => {
  document.querySelectorAll('[data-datepicker]').forEach(($baseEl) => {
    const $input = $baseEl.querySelector('input')
    const $hiddenInput = document.querySelector($input.dataset.target)
    console.log({ $hiddenInput })
    const $clearBtn = $baseEl.querySelector('.datepicker-clear-btn')
    const optsStr = $baseEl.dataset.datepickerOpts
    const opts = JSON.parse(optsStr)

    const datepicker = new window.Datepicker($input, {
      todayButton: true,
      todayHighlight: true,
      todayButtonMode: 1,
      buttonClass: 'btn btn-ripple btn-default btn-ghost btn-sm btn-radius-lg',
      prevArrow: `<span class="btn-content"><span class="ion-chevron-back icon icon-current icon-sm"></span></span>`,
      nextArrow: `<span class="btn-content"><span class="ion-chevron-forward icon icon-current icon-sm"></span></span>`,
      format: {
        toValue(date, _format, _locale) {
          const dateISO = $input.dataset.value

          if (!dateISO) {
            return new Date(date)
          }

          return new Date(dateISO)
        },
        toDisplay(date, _format, _locale) {
          let dateObj = date

          if (!(date instanceof Date)) {
            dateObj = new Date(date)
          }

          const dateISO = dateObj.toISOString()
          $input.dataset.value = dateISO

          return new Intl.DateTimeFormat(getNavigatorLanguage()).format(dateObj)
        },
      },
    })

    $input.addEventListener('changeDate', (e) => {
      const value = e.target.value
      setHasValue({ value, $wrapper: $baseEl })
      $hiddenInput.value = e.target.dataset.value
    })

    $clearBtn.addEventListener('click', (e) => {
      datepicker.setDate({ clear: true })
      $input.value = ''
      $input.dataset.value = ''
      $hiddenInput.value = ''
      setHasValue({ value: '', $wrapper: $baseEl })
      e.stopPropagation()
    })
  })
}

export { initDatepicker }
