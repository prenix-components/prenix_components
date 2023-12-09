// import TomSelect from '../../../vendors/tom-select/tom-select.base'
import TomSelect from '../../../vendors/tom-select/tom-select.base.min'
import no_active_items from '../../../vendors/tom-select/no_active_items'
import no_backspace_delete from '../../../vendors/tom-select/no_backspace_delete'
import autocomplete_multiple from './autocomplete_multiple_plugin'

import { setHasValue } from './utils'

TomSelect.define('autocomplete_multiple', autocomplete_multiple)
TomSelect.define('no_active_items', no_active_items)
TomSelect.define('no_backspace_delete', no_backspace_delete)

const selectOrInputSelector = '[data-original-input]'

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

const tomSelectOptions = ({ type, allowBlank, selectOrInput, wrapper }) => {
  const isMultiple = type === 'multiple'
  const isTags = type === 'tags'

  if (isTags) {
    return {
      create: true,
    }
  } else {
    let plugins = { no_backspace_delete: {} }
    if (isMultiple) {
      plugins = {
        autocomplete_multiple: {},
        no_active_items: {},
        no_backspace_delete: {},
      }
    }

    return {
      allowEmptyOption: allowBlank,
      plugins,
      onInitialize: () => {
        if (isMultiple) {
          const $selectedItemDisplay = document.createElement('div')
          $selectedItemDisplay.classList.add(
            'autocomplete-selected-items',
            'item',
          )
          $selectedItemDisplay.innerHTML = buildDisplayText(selectOrInput)
          const $tsControl = wrapper.querySelector('.ts-control')

          // Do not prepend because it messes with the $('.item') index
          // within $('.ts-control') when removing an item.
          $tsControl.append($selectedItemDisplay)
        }

        const $controlInput = wrapper.querySelector(
          '.ts-control input[role="combobox"]',
        )

        if ($controlInput.placeholder && $controlInput.placeholder.length > 0)
          wrapper.dataset.hasPlaceholder = true

        $controlInput.setAttribute('data-1p-ignore', '')
      },
      onDropdownOpen: ($tsDropdown) => {
        const $a = $tsDropdown.closest('[data-autocomplete]')
        $a.dataset.focus = true

        const $selectOrInput = $a.querySelector(selectOrInputSelector)
        const $tsDropdownContent = $a.querySelector('.ts-dropdown-content')
        const $controlInput = $a.querySelector(
          '.ts-control input[role="combobox"]',
        )

        setTimeout(() => {
          $tsDropdownContent.classList.add('open')
          $controlInput.placeholder = buildDisplayText($selectOrInput)
        })
      },
      onDropdownClose: ($tsDropdown) => {
        const $a = $tsDropdown.closest('[data-autocomplete]')
        $a.dataset.focus = false

        const $selectOrInput = $a.querySelector(selectOrInputSelector)

        $selectOrInput.tomselect.blur()
        setHasValue({ value: $selectOrInput.value, wrapper: $a })

        const $tsDropdownContent = $a.querySelector('.ts-dropdown-content')
        $tsDropdownContent.classList.remove('open')
      },
      onChange: (_value) => {
        if (isMultiple) {
          const $selectOrInput = wrapper.querySelector(selectOrInputSelector)
          const $selectedItemDisplay = wrapper.querySelector(
            '.autocomplete-selected-items',
          )
          const displayText = buildDisplayText($selectOrInput)

          $selectedItemDisplay.innerHTML = displayText

          const $controlInput = wrapper.querySelector(
            '.ts-control input[role="combobox"]',
          )

          setTimeout(() => {
            $controlInput.placeholder = displayText
          })
        }
      },
      render: {
        option: function (data, _escape) {
          const $option = data.$option

          if ($option.dataset.template) {
            return `<div class="autocomplete-option"><div class="autocomplete-option-label">${$option.dataset.template}</div></div>`
          } else {
            return `<div class="autocomplete-option"><div class="autocomplete-option-label">${$option.text}</div></div>`
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
    }
  }
}

const initAutocomplete = () => {
  document.querySelectorAll('[data-autocomplete]').forEach(($a) => {
    const $label = $a.querySelector('label.field-label')
    const allowBlank = 'allowBlank' in $a.dataset
    const type = $a.dataset.type

    if ($label) $a.dataset.hasLabel = true

    const $fw = $a.querySelector('.field-wrapper')

    $fw.addEventListener('click', (e) => {
      const $input = $fw.querySelector(selectOrInputSelector)
      const tomSelectInstance = $input.tomselect
      tomSelectInstance.open()
    })

    const $selectOrInput = $fw.querySelector(selectOrInputSelector)

    setHasValue({
      value: $selectOrInput.value,
      wrapper: $a,
    })

    new TomSelect(
      $selectOrInput,
      tomSelectOptions({
        allowBlank,
        selectOrInput: $selectOrInput,
        wrapper: $a,
        type,
      }),
    )
  })
}

export { initAutocomplete, TomSelect }
