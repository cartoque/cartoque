#generate token button
jQuery ->
  #internal VS cas authentication
  $('#user_provider').live 'change', (e) ->
    $('.hidden-if-internal, .hidden-if-cas').toggleClass("cas")

  #token
  $("#generate-token").live "click", (e) ->
    $(@).disabled = true
    $.rails.ajax
      type: "GET",
      url: "/users/random_token",
      #data: $(this).val(),
      #dataType: "script",
      callback: null
    false

  $("#remove-token").live "click", (e) ->
    $("#authentication_token").html("")
    $("#user_authentication_token").attr("value", "")
    $("#remove-token").hide()
    $("#generate-token").show()
    false
