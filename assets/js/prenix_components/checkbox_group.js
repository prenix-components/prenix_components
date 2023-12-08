const initCheckboxGroup = () => {
  document.querySelectorAll('[data-checkbox-group]').forEach(($cg) => {
    const $label = $cg.querySelector('.checkbox-group-label')

    if ($label) {
      const labelText = $label.textContent.trim()
      $cg.setAttribute('aria-label', labelText)
    }
  })
}

export { initCheckboxGroup }
