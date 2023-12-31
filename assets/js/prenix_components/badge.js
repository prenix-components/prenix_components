const initBadge = () => {
  document.querySelectorAll('[data-badge]').forEach(($baseEl) => {
    const $content = $baseEl.querySelector('.badge-content')

    if ($content) {
      const style = getComputedStyle($content)
      const minWidth = Number(style.minWidth.replace('px', ''))
      const width = Number(style.width.replace('px', ''))

      console.log({ width, minWidth })
      if (width > minWidth) {
        $baseEl.dataset.jsPadded = true
      }
    }
  })
}

export { initBadge }
