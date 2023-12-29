const initAvatar = () => {
  document.querySelectorAll('[data-avatar]').forEach(($baseEl) => {
    console.log({ $baseEl })
    const $img = $baseEl.querySelector('img')

    $img.addEventListener('load', (e) => {
      $baseEl.dataset.jsLoaded = true
    })
  })
}

export { initAvatar }
