const setHasValue = ({ value, $wrapper }) => {
  if (value.length > 0) {
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

export { setHasValue, randomString }
