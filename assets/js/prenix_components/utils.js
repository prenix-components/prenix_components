const setHasValue = ({ value, $wrapper }) => {
  if (value && value.length > 0) {
    $wrapper.dataset.hasValue = true
  } else {
    $wrapper.dataset.hasValue = false
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

export { setHasValue, randomString, getNavigatorLanguage, getDateFormatPattern }
