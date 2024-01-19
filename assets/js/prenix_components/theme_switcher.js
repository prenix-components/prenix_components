const setDarkTheme = () => {
  document.documentElement.classList.add('dark')
  localStorage.setItem('color-theme', 'dark')
}

const setLightTheme = () => {
  document.documentElement.classList.remove('dark')
  localStorage.setItem('color-theme', 'light')
}

const currentTheme = () => {
  if (
    localStorage.getItem('color-theme') === 'dark' ||
    (!('color-theme' in localStorage) &&
      window.matchMedia('(prefers-color-scheme: dark)').matches)
  ) {
    return 'dark'
  } else {
    return 'light'
  }
}

const initThemeSwitcher = () => {
  // On page load or when changing themes, best to add inline in `head` to avoid FOUC
  if (currentTheme() === 'dark') {
    setDarkTheme()
  } else {
    setLightTheme()
  }

  document.querySelectorAll('[data-theme-switcher]').forEach(($baseEl) => {
    const $toggles = $baseEl.querySelectorAll('[data-theme-switcher-toggle]')

    $toggles.forEach(($t) => {
      $t.addEventListener('click', () => {
        const theme = $t.dataset.themeSwitcherToggle

        if (theme === 'dark') {
          setDarkTheme()
        } else {
          setLightTheme()
        }
      })
    })
  })
}

export { initThemeSwitcher, setDarkTheme, setLightTheme, currentTheme }
