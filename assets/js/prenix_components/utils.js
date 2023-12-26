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

export { setHasValue, randomString, getNavigatorLanguage }
