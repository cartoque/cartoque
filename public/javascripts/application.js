// application events
$(function() {
  //table sorting
  $("items_list th a").live("click", function(e) {
    $.getScript(this.href);
    //fallback for old browsers
    if (!('pushState' in window.history)) return true
    //ensure middle, control and command clicks act normally
    if (e.which == 2 || e.metaKey || e.ctrlKey) {
      return true
    }
    //push history!
    history.pushState(null, document.title, this.href);
    return false
  });

  //back button
  $(window).bind("popstate", function() {
    //$.getScript(location.href);
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
  $(".filters input").bindWithDelay("keyup", function() {
    $.get($("form#filters").attr("action"), $("form#filters").serialize(), null, "script");
    //fallback for old browsers
    if (true || !('replaceState' in window.history)) return true
    //push our search to history
    history.replaceState(null, document.title, $("form#filters").attr("action") + "?" + $("form#filters").serialize());
    return false;
  }, 300);
  //$('form#filters').observe(1, function(){
  //  $(this).submit();
  //});

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

