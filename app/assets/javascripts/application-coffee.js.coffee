jQuery ->
  $('.modal .validate').on 'click', ->
    $modal = $(this).closest('.modal')
    $form  = $modal.find('form')
    if $form.length > 0
      $form.first().submit()
    else
      $modal.modal('hide')

  #display 'loading...' before some data-remote=true links
  $('#top-menu [data-remote="true"], .postit-link [data-remote="true"]').on 'click', ->
    $('#loading').fadeIn(150)
  #and hide it..
  $('.modal').on 'shown', ->
    $('#loading').fadeOut(150)
