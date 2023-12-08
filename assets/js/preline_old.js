// window.preline = preline

// window.addEventListener('click', (e) => {
//   const $targetEl = e.target
//   const $dropdownItemEl = $targetEl.closest('.dropdown-item')
//   const $modalCloseEl = $targetEl.closest('[data-modal-close]')

//   const $modalOpenEl = $targetEl.closest('[data-modal-open]')

//   if ($dropdownItemEl) {
//     const $dropdownEl = $dropdownItemEl.closest('.dropdown')

//     if ($dropdownEl) {
//       preline.HSDropdown.close($dropdownEl)
//     }
//   } else if ($modalCloseEl) {
//     const $modalEl = $modalCloseEl.closest('.modal')

//     if ($modalEl) {
//       preline.HSOverlay.close($modalEl)
//     }
//   } else if ($modalOpenEl) {
//     const modalTarget = $modalOpenEl.dataset.modalOpen
//     const $modalEl = document.querySelector(modalTarget)

//     if ($modalEl) {
//       // const element = preline.HSOverlay.getInstance(modalTarget)

//       // console.log('element', element)
//       console.log('$modalTarget', modalTarget)
//       console.log('$modalEl', $modalEl)

//       preline.HSOverlay.open($modalEl)

//       // console.log('$modalEl', $modalEl)
//       // const modal = new preline.HSOverlay($modalEl)
//       // console.log('$modal', modal)
//       // element.open()
//       // preline.HSOverlay.open(modalTarget)
//     }
//   }
// })
