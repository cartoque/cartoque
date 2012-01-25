jQuery ->
  $(".long-list").sortable
	  axis: 'y'
	  handle: 'td:eq(0)'
	  opacity: 0.6
	  update: ->
	    $.post($(@).data('sort-url'), $(@).sortable('serialize'))
  .disableSelection()
