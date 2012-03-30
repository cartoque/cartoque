Cartoque =
  highlightNotPuppetServers: (term) ->
    $("#to-puppetize .servers a").each ->
      $elem = $(@)
      if term != "" && $elem.html().indexOf(term) >= 0
        $elem.addClass("item-highlighted")
      else
        $elem.removeClass("item-highlighted")

window.Cartoque = Cartoque
