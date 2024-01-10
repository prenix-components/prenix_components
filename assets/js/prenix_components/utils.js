const setHasValue = ({ value, $wrapper }) => {
  if (value && value.length > 0) {
    $wrapper.dataset.jsHasValue = true
  } else {
    $wrapper.dataset.jsHasValue = false
  }
}

const CHARACTERS =
  'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

const randomString = (length = 10) => {
  let result = ''
  const charactersLength = CHARACTERS.length
  for (let i = 0; i < length; i++) {
    result += CHARACTERS.charAt(Math.floor(Math.random() * charactersLength))
  }

  return result
}

const getNavigatorLanguage = () => {
  if (navigator.languages && navigator.languages.length) {
    return navigator.languages[0]
  } else {
    return (
      navigator.userLanguage ||
      navigator.language ||
      navigator.browserLanguage ||
      'en'
    )
  }
}

const getDateFormatPattern = (locale) => {
  const getPatternForPart = (part) => {
    switch (part.type) {
      case 'day':
        return 'd'.repeat(part.value.length)
      case 'month':
        return 'm'.repeat(part.value.length)
      case 'year':
        return 'y'.repeat(part.value.length)
      case 'literal':
        return part.value
      default:
        console.log('Unsupported date part', part)
        return ''
    }
  }

  return new Intl.DateTimeFormat(locale)
    .formatToParts(new Date('2021-01-01'))
    .map(getPatternForPart)
    .join('')
}

const hide = ($el, delay = 200) => {
  $el.classList.add('opacity-0')

  setTimeout(() => {
    $el.classList.add('hidden')
  }, delay)
}

const show = ($el, delay = 200) => {
  $el.classList.remove('opacity-0')

  setTimeout(() => {
    $el.classList.remove('hidden')
  }, delay)
}

export {
  setHasValue,
  randomString,
  getNavigatorLanguage,
  getDateFormatPattern,
  hide,
  show,
}
