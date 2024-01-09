import { randomString } from './utils'
import { initCheckbox } from './checkbox'

const getDom = (query) => {
  if (query instanceof HTMLElement) {
    return query
  }

  if (isHtmlString(query)) {
    var tpl = document.createElement('template')
    tpl.innerHTML = query.trim() // Never return a text node of whitespace as the result
    return tpl.content.firstChild
  }

  return document.querySelector(query)
}

const isHtmlString = (arg) => {
  if (typeof arg === 'string' && arg.indexOf('<') > -1) {
    return true
  }
  return false
}

const preventDefault = (evt, stop) => {
  if (evt) {
    evt.preventDefault()
    if (stop) {
      evt.stopPropagation()
    }
  }
}
const hash_key = (value) => {
  if (typeof value === 'undefined' || value === null) return null
  return get_hash(value)
}

const get_hash = (value) => {
  if (typeof value === 'boolean') return value ? '1' : '0'
  return value + ''
}

const checkboxQuery = 'input[type="checkbox"]'

const checkboxTemplate = (id, label) => {
  return `
    <div class="visually-hidden">
      <input id=${id} aria-labelledby="${id}-label" type="checkbox" aria-label="${label}">
    </div>
    <span aria-hidden="true" class="checkbox-checkbox checkbox-checkbox--md checkbox-checkbox--primary">
      <svg aria-hidden="true" role="presentation" viewBox="0 0 17 18" class="checkbox-checkmark checkbox-checkmark--md">
        <polyline fill="none" points="1 9 7 14 15 4" stroke="currentColor" stroke-dasharray="22" stroke-dashoffset="66" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" style="transition: stroke-dashoffset 250ms linear 0.2s;">
          <polyline fill="none" points="1 9 7 14 15 4" stroke="currentColor" stroke-dasharray="22" stroke-dashoffset="44" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" style="transition: stroke-dashoffset 250ms linear 0.2s;">
          </polyline>
        </polyline>
      </svg>
    </span>`
}

export default function (_userOptions) {
  var self = this
  var orig_onOptionSelect = self.onOptionSelect

  self.settings.hideSelected = false

  var UpdateCheckbox = function (checkbox, toCheck) {
    if (toCheck) {
      checkbox.checked = true
    } else {
      checkbox.checked = false
    }

    const event = new Event('change')
    checkbox.dispatchEvent(event)
  }

  // add checkbox to option template
  self.hook('after', 'setupTemplates', () => {
    var orig_render_option = self.settings.render.option

    self.settings.render.option = (data, escape_html) => {
      var rendered = getDom(orig_render_option.call(self, data, escape_html))
      const label = rendered.textContent.trim()

      const $checkbox = document.createElement('label')
      const timestamp = new Date().getTime()
      const id = `autocomplete-checkbox-${randomString()}-${timestamp}`
      $checkbox.setAttribute('data-checkbox', '')
      $checkbox.setAttribute('for', id)
      $checkbox.classList.add('checkbox', 'autocomplete-option-checkbox')
      $checkbox.innerHTML = checkboxTemplate(id, label)

      const hashed = hash_key(data[self.settings.valueField])
      const isSelected = !!(hashed && self.items.indexOf(hashed) > -1)

      const $checkboxEl = $checkbox.querySelector(checkboxQuery)
      UpdateCheckbox($checkboxEl, isSelected)
      initCheckbox([$checkbox])

      rendered.prepend($checkbox)
      return rendered
    }
  })

  // uncheck when item removed
  self.on('item_remove', (value) => {
    var option = self.getOption(value)

    if (option) {
      UpdateCheckbox(option.querySelector(checkboxQuery), false)
    }
  })

  // check when item added
  self.on('item_add', (value) => {
    var option = self.getOption(value)

    if (option) {
      UpdateCheckbox(option.querySelector(checkboxQuery), true)
    }
  })

  // remove items when selected option is clicked
  self.hook('instead', 'onOptionSelect', (evt, option) => {
    if (option.classList.contains('selected')) {
      option.classList.remove('selected')
      self.removeItem(option.dataset.value)
      self.refreshOptions()
      preventDefault(evt, true)
      return
    }

    orig_onOptionSelect.call(self, evt, option)
    UpdateCheckbox(option.querySelector(checkboxQuery), true)
  })
}
