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

  $("#applications_search input").bindWithDelay("keyup", function() {
    $.get($("#applications_search").attr("action"), $("#applications_search").serialize(), null, "script");
    //fallback for old browsers
    if (true || !('replaceState' in window.history)) return true
    //push our search to history
    history.replaceState(null, document.title, $("#applications_search").attr("action") + "?" + $("#applications_search").serialize());
    return false;
  }, 300);

  $("#machines_search").bindWithDelay("keyup", function() {
    $.get($("#machines_search").attr("action"), $("#machines_search").serialize(), null, "script");
    //fallback for old browsers
    if (true || !('replaceState' in window.history)) return true
    //push our search to history
    history.replaceState(null, document.title, $("#machines_search").attr("action") + "?" + $("#machines_search").serialize());
    return false;
  }, 300);

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
  $('form#filters').observe(1, function(){
    $(this).submit();
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

// utility

/* form observer ; see: http://blessednotes.wordpress.com/2009/07/28/jquery-form-changes-observer/ */
$.fn.observe = function(time, callback) {
  return this.each(function() {
    var form = this, change = false;
    $(form.elements).change(function() {
      change = true;
    });
    setInterval(function() {
      if (change) callback.call(form);
      change = false;
    }, time * 1000);
  });
};

/* 
bindWithDelay jQuery plugin
Author: Brian Grinstead
http://github.com/bgrins/bindWithDelay
Open source code under MIT license: http://www.opensource.org/licenses/mit-license.php

Usage: 
  See http://api.jquery.com/bind/
  .bindWithDelay( eventType, [ eventData ], handler(eventObject), timeout )

Examples:
  $("#foo").bindWithDelay("click", function(e) { }, 100);
  $(window).bindWithDelay("resize", { optional: "eventData" }, callback, 1000);
*/

(function($) {
$.fn.bindWithDelay = function( type, data, fn, timeout ) {
  var wait = null;
  var that = this;
  
  if ( $.isFunction( data ) ) {
    timeout = fn;
    fn = data;
    data = undefined;
  }
    
  var cb = function(e) {
    clearTimeout(wait);
    var cachedEvent = $.extend({}, e);
    
    wait = setTimeout(function() {
      fn.apply(that, [cachedEvent]);
    }, timeout);
  }
  
  return this.bind(type, data, cb);
}
})(jQuery);
