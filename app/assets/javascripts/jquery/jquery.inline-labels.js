/*!
* Cross-browser Inline Labels Plugin for jQuery
*
* Copyright (c) 2010 Mark Dodwell (@madeofcode)
* Licensed under the MIT license
*
* Requires: jQuery v1.3.2
* Version: 0.1.0
*/
(function($) {
  
  //
  // Helpers
  //
  
  // is an input blank
  $.fn.isEmpty = function() {
    return $(this)[0].value === '';
  };

  // is an input present
  $.fn.isPresent = function() {
    return !$(this).isEmpty();
  };

  // return element for label
  $.fn.element = function() {
    return $('#' + $(this).attr('for'));
  };

  // return top/left offset for element
  $.fn.innerOffset = function() {
    var el = $(this);

    // TODO check for nil?
    var topOffset = 
      parseInt(el.css('marginTop')) + 
      parseInt(el.css('paddingTop')) +
      parseInt(el.css('borderTopWidth'));
      
    // TODO check for nil?
    var leftOffset = 
      parseInt(el.css('marginLeft')) + 
      parseInt(el.css('paddingLeft')) +
      parseInt(el.css('borderLeftWidth'));

    return { top: topOffset, left: leftOffset };
  };
  
  // setup
  $(function() {
    var labels = $('label.inline');
    
    // set as supported
    labels.addClass('supported')
    
    // delegate mousedown to input
    .mousedown(function(e) {
      $(this).element()[0].focus();
      e.stopPropagation();
      e.preventDefault();
    })
    
    .each(function() {
      var label = $(this);
      var el = label.element();
      
      // calc offset
      var leftOffset = el[0].tagName == "TEXTAREA" ? 0 : 2;
      
      // adopt styling of inputs
      label.css({
        fontSize: el.css('fontSize'), 
        fontFamily: el.css('fontFamily'),
        fontWeight: el.css('fontWeight'),
        lineHeight: el.css('lineHeight'),
        letterSpacing: el.css('letterSpacing'),
        top: el.position().top + el.innerOffset().top,
        left: el.position().left + el.innerOffset().left + leftOffset,
        width: el.width() - leftOffset
      });

      // set input as having inline label
      el.addClass('field_with_inline_label').data('inline.label', label);

      // show input if empty
      if (el.isEmpty()) label.addClass("empty");
    });

    // elm behaviours
    $(".field_with_inline_label")
    
    // focus behaviours
    .focus(function() {
      var el = $(this);
      var label = el.data('inline.label');

      // focus label
      label.addClass("focus");

      // clear existing timer (maybe don't need this?)
      var timer = el.data('inline.timer');
      window.clearInterval(timer);
      el.data('inline.timer', null);

      // set timer
      el.data('inline.timer', window.setInterval(function() {
        if (el.isPresent()) label.removeClass('empty');
      }, 25));
    }) 
    
    // blur behaviours 
    .blur(function() {
      var el = $(this);
      var label = el.data('inline.label');

      // unfocus label
      label.removeClass("focus");

      // cancel timer
      var timer = el.data('inline.timer');
      window.clearInterval(timer);
      el.data('inline.timer', null);

      // show label on blur if field empty
      if (el.isEmpty()) label.addClass("empty");
    });

    // ready! show labels
    $('label.inline').show();
  });

})(jQuery);
