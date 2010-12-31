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
    if (!('replaceState' in window.history)) return true
    //push our search to history
    history.replaceState(null, document.title, $("#applications_search").attr("action") + "?" + $("#applications_search").serialize());
    return false;
  }, 300);

  $("#machines_search").bindWithDelay("keyup", function() {
    $.get($("#machines_search").attr("action"), $("#machines_search").serialize(), null, "script");
    //fallback for old browsers
    if (!('replaceState' in window.history)) return true
    //push our search to history
    history.replaceState(null, document.title, $("#machines_search").attr("action") + "?" + $("#machines_search").serialize());
    return false;
  }, 300);

  //back button
  $(window).bind("popstate", function() {
    //$.getScript(location.href);
  });
});

// utility

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
