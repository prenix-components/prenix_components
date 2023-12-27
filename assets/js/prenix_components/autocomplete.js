import TomSelect from '../../../vendors/tom-select/tom-select.base.min'
import no_active_items from '../../../vendors/tom-select/no_active_items'
import no_backspace_delete from '../../../vendors/tom-select/no_backspace_delete'
import remove_button from '../../../vendors/tom-select/remove_button'
import autocomplete_multiple from './autocomplete_multiple_plugin'
import { setHasValue } from './utils'

TomSelect.define('autocomplete_multiple', autocomplete_multiple)
TomSelect.define('no_active_items', no_active_items)
TomSelect.define('no_backspace_delete', no_backspace_delete)
TomSelect.define('remove_button', remove_button)

const originalInputSelector = '[data-original-input]'

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

const tomSelectOptions = ({ type, allowBlank, $originalInput, $wrapper }) => {
  const originalInputClass = $originalInput.dataset.inputClass
  const isMultiple = type === 'multiple'
  const isTags = type === 'tags'
  let opts = {
    copyClassesToDropdown: false,
    controlInput:
      '<input class="autocomplete-input" type="text" autocomplete="off" size="1" />',
  }

  let plugins = {}

  switch (type) {
    case 'tags':
      const options = $originalInput.dataset.options
        ? $originalInput.dataset.options.split(',').map((o) => {
            return { value: o, text: o }
          })
        : []

      opts = { ...opts, options, create: true, addPrecedence: true }
      plugins = { remove_button: {} }
      break
    case 'multiple':
      opts = { ...opts, allowEmptyOption: allowBlank }
      plugins = {
        autocomplete_multiple: {},
        no_active_items: {},
        no_backspace_delete: {},
      }
      break
    default:
      opts = { ...opts, allowEmptyOption: allowBlank }
      plugins = { no_backspace_delete: {} }
  }

  let tagItemTemplate = $wrapper.dataset.tagItemTemplate
  tagItemTemplate = tagItemTemplate

  return {
    ...opts,
    plugins,
    onInitialize: () => {
      if (isMultiple) {
        const $autocompleteItem = document.createElement('div')
        $autocompleteItem.classList.add('autocomplete-item', 'item')

        if (originalInputClass) {
          $autocompleteItem.classList.add(originalInputClass)
        }

        $autocompleteItem.innerHTML = buildDisplayText($originalInput)
        const $tsControl = $wrapper.querySelector('.ts-control')
        // Do not prepend because it messes with the $('.item') index
        // within $('.ts-control') when removing an item.
        $tsControl.append($autocompleteItem)
      }
      const $controlInput = $wrapper.querySelector('.autocomplete-input')

      if (originalInputClass) {
        $controlInput.classList.add(originalInputClass)
      }

      if ($controlInput.placeholder && $controlInput.placeholder.length > 0) {
        $wrapper.dataset.hasPlaceholder = true
      }

      $controlInput.setAttribute('data-1p-ignore', '')
    },
    onDropdownOpen: (_$tsDropdown) => {
      $wrapper.dataset.dropdownOpen = true
      const $tsDropdownContent = $wrapper.querySelector('.ts-dropdown-content')
      const $controlInput = $wrapper.querySelector('.autocomplete-input')
      setTimeout(() => {
        $tsDropdownContent.classList.add('open')

        if (!isTags) {
          $controlInput.placeholder = buildDisplayText($originalInput)
        }
      })
    },
    onDropdownClose: (_$tsDropdown) => {
      $wrapper.dataset.dropdownOpen = false

      if (!isTags) {
        $originalInput.tomselect.blur()
      }

      const $tsDropdownContent = $wrapper.querySelector('.ts-dropdown-content')
      $tsDropdownContent.classList.remove('open')
    },
    onChange: (_value) => {
      if (isMultiple) {
        const $autocompleteItem = $wrapper.querySelector('.autocomplete-item')
        const displayText = buildDisplayText($originalInput)
        $autocompleteItem.innerHTML = displayText
        const $controlInput = $wrapper.querySelector('.autocomplete-input')
        setTimeout(() => {
          $controlInput.placeholder = displayText
        })
      }

      setHasValue({
        value: $originalInput.value,
        $wrapper: $wrapper,
      })
    },
    onFocus: () => {
      $wrapper.dataset.focus = true
    },
    onBlur: () => {
      $wrapper.dataset.focus = false
    },
    render: {
      option: (data, _escape) => {
        const $option = data.$option
        const label = $option ? $option.text : data.text

        if ($option && $option.dataset.template) {
          return `<div class="autocomplete-option"><div class="autocomplete-option-label">${$option.dataset.template}</div></div>`
        } else {
          return `<div class="autocomplete-option"><div class="autocomplete-option-label">${label}</div></div>`
        }
      },
      item: (data, _escape) => {
        if (isTags) {
          let html = tagItemTemplate
          html = html.replace(/{{AUTOCOMPLETE_TAG_ITEM}}/, data.text)
          return html
        } else if (isMultiple) {
          return '<div></div>'
        } else {
          const originalInputClass = $originalInput.dataset.inputClass || ''
          return `<div class="autocomplete-item ${originalInputClass}">${data.text}</div>`
        }
      },
      dropdown: () => {
        return '<div class="autocomplete-dropdown"></div>'
      },
      option_create: function (data, escape) {
        let html = tagItemTemplate
        html = html.replace(/{{AUTOCOMPLETE_TAG_ITEM}}/, escape(data.input))

        return `
          <div class="autocomplete-create create">
            Add
            ${html}
        </div>`
      },
    },
  }
}

const initAutocomplete = () => {
  document.querySelectorAll('[data-autocomplete]').forEach(($baseEl) => {
    const $label = $baseEl.querySelector('.autocomplete-label')
    const allowBlank = 'allowBlank' in $baseEl.dataset
    const type = $baseEl.dataset.type
    const $originalInput = $baseEl.querySelector(originalInputSelector)

    setHasValue({
      value: $originalInput.value,
      $wrapper: $baseEl,
    })

    if ($label) $baseEl.dataset.hasLabel = true

    const $autocompleteWrapper = $baseEl.querySelector('.autocomplete-wrapper')

    $autocompleteWrapper.addEventListener('click', (e) => {
      const $input = $baseEl.querySelector(originalInputSelector)
      const tomSelectInstance = $input.tomselect
      tomSelectInstance.focus()
    })

    const tomselect = new TomSelect(
      $originalInput,
      tomSelectOptions({
        allowBlank,
        $originalInput: $originalInput,
        $wrapper: $baseEl,
        type,
      }),
    )
  })
}

export { initAutocomplete, TomSelect }
