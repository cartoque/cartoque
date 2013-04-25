jQuery ->
  $('.modal .validate').on 'click', ->
    $modal = $(this).closest('.modal')
    $form  = $modal.find('form')
    if $form.length > 0
      $form.first().submit()
    else
      $modal.modal('hide')

  #display 'loading...' before some data-remote=true links
  $('#top-menu [data-remote="true"], .postit-link[data-remote="true"]').on 'click', ->
    $('#loading').fadeIn(150)
  #and hide it..
  $('.modal').on 'shown', ->
    $('#loading').fadeOut(150)

  #
  # DOUBLE CLICK IN SIDEBAR, BASECAMP LIKE
  #
  $("body").on "dblclick", (event) ->

    #ensures we don't get a click bubbled from a descendant node
    if $(event.target).get(0).tagName is "BODY"
      
      #remove selection: http://stackoverflow.com/questions/4117466/javascript-disable-text-selection-via-doubleclick
      if window.getSelection
        window.getSelection().removeAllRanges()
      else document.selection.empty()  if document.selection
      
      #useful vars
      $win = $(window)
      portion = $win.height() / 2.5
      
      #console.log("y: "+event.clientY+" win.scrollTop: "+$win.scrollTop()+ "portion: "+portion)
      #scroll to top
      if event.clientY < portion
        $("html, body").stop().animate
          scrollTop: 0
        ,
          duration: 600
          easing: "swing"

      
      #scroll to bottom
      else if $win.height() - event.clientY < portion
        $("html, body").stop().animate
          scrollTop: $(document).height() - $win.height()
        ,
          duration: 600
          easing: "swing"
