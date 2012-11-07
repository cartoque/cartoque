jQuery ->
  $('#modal-validate').on 'click', ->
    $form = $('#modal form')
    if $form.length > 0
      $form.first().submit()
    else
      $('#modal').modal('hide')

  #display 'loading...' before some data-remote=true links
  $('#top-menu [data-remote="true"]').on 'click', ->
    $('#loading').fadeIn(150)
  #and hide it..
  $('#modal').on 'shown', ->
    $('#loading').fadeOut(150)
