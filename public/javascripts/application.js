// application events
$(function() {
  //table sorting
  $(".items_list th a").live("click", function(e) {
    $.getScript(this.href);
    //fallback for old browsers
    if (!('pushState' in window.history)) return true
    //ensure middle, control and command clicks act normally
    //if (e.which == 2 || e.metaKey || e.ctrlKey) return true
    //push history!
    history.pushState(null, document.title, this.href);
    e.preventDefault();
  });

  //TODO: test it (Jasmine?)
  //machine 'virtual' toggling
  $('input#machine_virtual').live('change', function(e) {
    $('#machine-maintenance, #machine-physical-hardware').toggle();
    if ($('input#machine_virtual').attr('checked') == true) {
      $('#machine-hardware-title').html("Ressources");
    } else {
      $('#machine-hardware-title').html("Matériel");
    }
  });

  //filters observer
  submitFilters = function() {
    $.get($("form#filters").attr("action"), $("form#filters").serialize(), null, "script");
    //fallback for old browsers
    if (!('replaceState' in window.history)) return true
    //push our search to history
    var url = $("form#filters").attr("action").split("?")[0] + "?" + $("form#filters").serialize()
    history.replaceState(null, document.title, url);
  }
  $(".filters input").bindWithDelay("keyup", submitFilters, 300);
  $(".filters select").change(submitFilters);

  //back button for pushState's
  $(window).bind("popstate", function() {
    $.getScript(location.href);
  });

  //multiselect with bsmSelect plugin
  $("select[multiple]").bsmSelect({
    showEffect: function($el){ $el.fadeIn(); },
    hideEffect: function($el){ $el.fadeOut(function(){ $(this).remove();}); },
    title: 'Sélectionnez...',
    highlight: 'highlight',
    addItemTarget: 'original',
    removeLabel: '<strong>x</strong>',
    containerClass: 'bsmContainer',                // Class for container that wraps this widget
    listClass: 'bsmList-custom',                   // Class for the list ($ol)
    listItemClass: 'bsmListItem-custom',           // Class for the <li> list items
    listItemLabelClass: 'bsmListItemLabel-custom', // Class for the label text that appears in list items
    removeClass: 'bsmListItemRemove-custom',       // Class given to the "remove" link
  });
});

// context
$(function(){
  $(".contextswitch").each(function(){
    var a=$(this), d=a.find(".toggle");
    d.click(function(){
      a.hasClass("nochoices") || a.toggleClass("activated")
    })
  })
});

