jQuery ->
  $('body').popover(
    selector: '.has-postit',
    placement: 'right', trigger: 'hover',
    template: '<div class="popover postit"><div class="popover-inner"><div class="popover-content"><p></p></div></div></div>'
  )
