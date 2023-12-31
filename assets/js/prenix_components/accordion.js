const initAccordion = () => {
  document.querySelectorAll('[data-accordion]').forEach(($baseEl) => {
    const id = $baseEl.id
    const expandMultiple = $baseEl.dataset.expandMultiple
    const classesJson = $baseEl.dataset.classes
    const classes = JSON.parse(classesJson)

    Object.entries(classes).forEach(([name, jsClasses]) => {
      if ($baseEl.dataset[name] === '') {
        $baseEl.classList.add(...jsClasses.split(' '))
      }

      const $elements = $baseEl.querySelectorAll(`[data-${name}]`)
      $elements.forEach(($element) => {
        $element.classList.add(...jsClasses.split(' '))
      })
    })

    if (expandMultiple === 'false') {
      $baseEl
        .querySelectorAll('[data-accordion-collapse]')
        .forEach(($collapseEl) => {
          $collapseEl.setAttribute('data-bs-parent', `#${id}`)
        })
    }
  })
}

export { initAccordion }
