Cartoque =
  highlightNotBackupedServers: (term) ->
    $("#not-backuped .servers a").each ->
      $elem = $(@)
      if term != "" && $elem.html().indexOf(term) >= 0
        $elem.addClass("highlighted")
      else
        $elem.removeClass("highlighted")

window.Cartoque = Cartoque
