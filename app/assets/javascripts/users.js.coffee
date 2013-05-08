#generate token button
jQuery ->
  #internal VS cas authentication
  $('#user_provider').on 'change', (e) ->
    $('.hidden-if-internal, .hidden-if-cas').toggleClass("cas")

  #token
  $("#generate-token").on "click", (e) ->
    $(@).disabled = true
    $.rails.ajax
      type: "GET",
      url: "/users/random_token",
      #data: $(this).val(),
      #dataType: "script",
      callback: null
    false

  $("#remove-token").on "click", (e) ->
    $("#authentication_token").html("")
    $("#user_authentication_token").attr("value", "")
    $("#remove-token").hide()
    $("#generate-token").show()
    false
