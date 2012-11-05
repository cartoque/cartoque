jQuery ->
  $('#modal-validate').on 'click', ->
    $form = $('#modal form')
    if $form.length > 0
      $form.first().submit()
    else
      $('#modal').modal('hide')
