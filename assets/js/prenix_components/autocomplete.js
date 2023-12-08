import TomSelect from '../../../vendors/tom-select/tom-select.base.min'
import no_active_items from '../../../vendors/tom-select/no_active_items'
import no_backspace_delete from '../../../vendors/tom-select/no_backspace_delete'

import autocomplete_multiple from './autocomplete_multiple_plugin'
import { setHasValue } from './utils'

TomSelect.define('autocomplete_multiple', autocomplete_multiple)
TomSelect.define('no_active_items', no_active_items)
TomSelect.define('no_backspace_delete', no_backspace_delete)

const buildDisplayText = (select) => {
  const textArr = []

  Array.from(select.selectedOptions).forEach(($o) => {
    textArr.push($o.textContent.trim())
  })

  let text = textArr[0] || ''

  if (textArr.length === 2) {
    text = textArr.join(' and ')
  } else if (textArr.length > 2) {
    text = `${text} and ${textArr.length - 1} more`
  }

  return text
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

    setHasValue({
      value: $select.value,
      wrapper: $a,
    })

    const allowBlank = 'allowBlank' in $a.dataset
    const isMultiple = 'multiple' in $a.dataset

    const instance = new TomSelect($select, {
      allowEmptyOption: allowBlank,
      plugins: {
        no_backspace_delete: {},
      },
      ...(isMultiple && {
        plugins: {
          autocomplete_multiple: {},
          no_active_items: {},
          no_backspace_delete: {},
        },
      }),
      onInitialize: () => {
        if (isMultiple) {
          const $multiItemDisplay = document.createElement('div')
          $multiItemDisplay.classList.add('autocomplete-multi-item', 'item')
          $multiItemDisplay.innerHTML = buildDisplayText($select)
          const $tsControl = $a.querySelector('.ts-control')

          // Do not prepend because it messes with the $('.item') index
          // within $('.ts-control') when removing an item
          $tsControl.append($multiItemDisplay)
        }
      },
      onDropdownOpen: ($dropdownEl) => {
        const $a = $dropdownEl.closest('[data-autocomplete]')
        $a.dataset.focus = true

        const $select = $fw.querySelector('select')
        const $dropdownContent = $a.querySelector('.ts-dropdown-content')
        const $input = $a.querySelector('.ts-control input[role="combobox"]')

        setTimeout(() => {
          $dropdownContent.classList.add('open')
          $input.placeholder = buildDisplayText($select)
        })
      },
      onDropdownClose: ($dropdownEl) => {
        const $a = $dropdownEl.closest('[data-autocomplete]')
        $a.dataset.focus = false
        const $select = $fw.querySelector('select')
        $select.tomselect.blur()
        setHasValue({ value: $select.value, wrapper: $a })

        const $dropdownContent = $a.querySelector('.ts-dropdown-content')
        $dropdownContent.classList.remove('open')
      },
      onChange: (_value) => {
        console.log('on change', _value)

        if (isMultiple) {
          const $select = $a.querySelector('select')
          const $multiItemDisplay = $a.querySelector('.autocomplete-multi-item')
          const displayText = buildDisplayText($select)

          $multiItemDisplay.innerHTML = displayText

          const $input = $a.querySelector('.ts-control input[role="combobox"]')

          setTimeout(() => {
            $input.placeholder = displayText
          })
        }
      },
      render: {
        option: function (data, _escape) {
          const $option = data.$option

          if ($option.dataset.template) {
            return $option.dataset.template
          } else if (isMultiple) {
            return `<div><div class="autocomplete-multi-label">${$option.text}</div></div>`
          } else {
            return `<div>${$option.text}</div>`
          }
        },
        item: function (data, _escape) {
          if (isMultiple) {
            return '<div></div>'
          } else {
            return `<div>${data.text}</div>`
          }
        },
      },
    })

    const $controlInput = $a.querySelector('.ts-control input[role="combobox"]')

    // instance.on('change', (value) => {
    //   console.log('INSTANCE on change ', value)
    // })

    if ($controlInput.placeholder && $controlInput.placeholder.length > 0)
      $a.dataset.hasPlaceholder = true

    $controlInput.setAttribute('data-1p-ignore', '')
  })
}

export { initAutocomplete }
