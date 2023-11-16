// https://codepen.io/TrevorWelch/pen/NwERXE

const rippleEffect = ({ $rippleEl, event }) => {
  const X = event.pageX - $rippleEl.offsetLeft
  const Y = event.pageY - $rippleEl.offsetTop
  const rippleDiv = document.createElement('div')
  rippleDiv.classList.add('ripple')
  rippleDiv.setAttribute('style', 'top:' + Y + 'px; left:' + X + 'px;')
  const customColor = $rippleEl.getAttribute('ripple-color')
  if (customColor) rippleDiv.style.background = customColor
  $rippleEl.appendChild(rippleDiv)
  setTimeout(function () {
    rippleDiv.parentElement.removeChild(rippleDiv)
  }, 900)
}

window.addEventListener('click', (event) => {
  const $targetEl = event.target
  const $rippleEl = $targetEl.closest('.btn-ripple')

  if ($rippleEl) {
    rippleEffect({ event, $rippleEl })
  }
})
