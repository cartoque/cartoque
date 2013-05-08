jQuery ->
  $("#upgrades .validate").on("click", () ->
    $(@).disabled = true
    $.ajax(
      type: "PUT"
      url: "/upgrades/"+$(@).data("id")+"/validate"
      callback: null
    )
    return false
  )
