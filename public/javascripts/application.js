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
    var filters = jQuery.param( jQuery.grep( $('form#filters').serializeArray(), function(o){ return o.name != "utf8" && o.value != "" } ) )
    var url = $("form#filters").attr("action").split("?")[0] + "?" + filters
    history.replaceState(null, document.title, url);
  }
  $(".filters input").bindWithDelay("keyup", submitFilters, 300);
  $(".filters select").change(submitFilters);

  //back button for pushState's
  $(window).bind("popstate", function() {
    //commented out since it makes calls to ".js"'s urls even when not necessary at all (welcome page for instance)
    //TODO: switch to jquery-pjax ftw!
    //$.getScript(location.href);
  });

  //multiselect with bsmSelect plugin
  bsmizeSelects();
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

// some checkboxes acts as radio buttons on machines/show view
$(function(){
  $('input[type="checkbox"].main_ip').live('change', function() {
    if ($(this).is(":checked")) {
      var id = $(this).attr("id");
      $('input[type="checkbox"].main_ip:checked').each(function() {
        if ($(this).attr("id") != id) $(this).attr("checked", false);
      });
    }
  });
});

//bsm plugin
function bsmizeSelects() {
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
}

// nested forms
function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
  bsmizeSelects();
}

//fixed table column sizes
function fixTableHeaders() {
  var selector = 'tr.fixed-size, #fix-on-scroll';
  $(selector).children().each(function() {
    $(this).css('width', parseInt($(this).innerWidth()) - parseInt($(this).css('paddingLeft')) - parseInt($(this).css('paddingRight')));
  });
}
$(function() { fixTableHeaders() });

//fixed table headers on scroll
$(function () {  
  var selector = '#fix-on-scroll';
  var top = $(selector).offset().top; // - parseFloat($(selector).css('marginTop').replace(/auto/, 0));
  $(window).scroll(function (event) {
    // what the y position of the scroll is
    var y = $(this).scrollTop();
    // whether that's below the form
    if (y >= top) {
      // if so, ad the fixed class
      $(selector).addClass('fixed');
    } else {
      // otherwise remove it
      $(selector).removeClass('fixed');
    }
  });
});
