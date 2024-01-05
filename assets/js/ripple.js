// https://codepen.io/TrevorWelch/pen/NwERXE

const rippleEffect = ({ $rippleEl, e }) => {
  var rect = $rippleEl.getBoundingClientRect()

  let X = e.clientX - rect.left
  let Y = e.clientY - rect.top

  let rippleDiv = document.createElement('div')
  rippleDiv.classList.add('ripple')
  rippleDiv.setAttribute('style', 'top:' + Y + 'px; left:' + X + 'px;')
  $rippleEl.appendChild(rippleDiv)
  setTimeout(function () {
    rippleDiv.parentElement.removeChild(rippleDiv)
  }, 900)
}

window.addEventListener('click', (e) => {
  const $targetEl = e.target
  const $rippleEl = $targetEl.closest('[data-ripple]')

  if ($rippleEl) {
    rippleEffect({ $rippleEl, e })
  }
})
