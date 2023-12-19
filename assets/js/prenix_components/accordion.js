const initAccordion = () => {
  document.querySelectorAll('[data-accordion]').forEach(($baseEl) => {
    const id = $baseEl.id

    const expandMultiple = $baseEl.dataset.expandMultiple

    if (expandMultiple === 'false') {
      $baseEl.querySelectorAll('.accordion-collapse').forEach(($collapseEl) => {
        $collapseEl.setAttribute('data-bs-parent', `#${id}`)
      })
    }
  })
}

export { initAccordion }
