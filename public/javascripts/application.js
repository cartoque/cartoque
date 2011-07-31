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
  $('#machine_virtual').live('change', function(e) {
    $('#machine-maintenance, #machine-physical-hardware').toggle();
    if ($('input#machine_virtual').attr('checked') == true) {
      $('#machine-hardware-title').html("Ressources");
    } else {
      $('#machine-hardware-title').html("Matériel");
    }
  });

  //filters observer
  submitFilters = function() {
    $.get($("#filters").attr("action"), $("#filters").serialize(), null, "script");
    //fallback for old browsers
    if (!('replaceState' in window.history)) return true
    //push our search to history
    var filters = jQuery.param( jQuery.grep( $('#filters').serializeArray(), function(o){ return o.name != "utf8" && o.value != "" } ) )
    var url = $("#filters").attr("action").split("?")[0] + "?" + filters
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
  $(".contextswitch").click(function(e){
    var a=$(this), d=a.closest(".toggle");
    if (a.hasClass("activated")) {
      a.removeClass("activated");
    } else {
      a.addClass("activated");
      e.stopPropagation();
      $(document).one("click", {contextSwitch: a}, function(e){ e.data.contextSwitch.removeClass("activated"); });
    }
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

// elastic <textarea>'s
$(function() {
  $('textarea').elastic();
});
//highlight lines when mouse is hover
$(function() {
  $(".pretty.list tr").live({
    mouseenter: function() { $(this).addClass("highlight"); },
    mouseleave: function() { $(this).removeClass("highlight"); }
  })
});

//fixed table column sizes
function fixTableHeaders() {
  $('.fixed-size, #fix-on-scroll').children().each(function() { fixElementSize($(this)); });
  $('td.multirow').siblings().andSelf().each(function() { fixElementSize($(this)); });
}
function fixElementSize(elem) {
  elem.css('width', parseInt(elem.innerWidth()) - parseInt(elem.css('paddingLeft')) - parseInt(elem.css('paddingRight')));
}

$(function() { fixTableHeaders() });

//fixed table headers on scroll
$(function () {  
  var selector = '#fix-on-scroll';
  if ($(selector).length < 1) return false;
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

//top menu items
$(function() {
  var otherOpen = false;
  $('.has-submenu:not(.active)>a').live('click', openSubMenu);
  $('.has-submenu:not(.active)>a').live('mouseenter', openSubMenuIfOtherOpen);
  $('.has-submenu.active>a').live('click', closeAllSubMenus);
  function openSubMenu(event) {
    closeAllSubMenus();
    var button = $(this).parent().addClass('active');
    var menu = $(this).children('div');
    var h = (button.outerHeight) ? button.outerHeight() : button.height();
    menu.addClass('active')
        .click(function(e) { e.stopPropagation(); })
    $(document).one('click', {button: button}, closeSubMenu);
    otherOpen = true;
    return false;
  }
  function openSubMenuIfOtherOpen(event) {
    if (otherOpen) { $(this).trigger('click'); }
  }
  function closeSubMenu(event) {
    if (!$(event.target).hasClass("submenu") && !$(event.target).closest('.has-submenu').hasClass('active')) {
      event.data.button.removeClass('active');
      otherOpen = false;
    } else {
      $(document).one('click', {button: event.data.button}, closeSubMenu);
    }
  }
  function closeAllSubMenus() {
    $('.has-submenu').removeClass('active');
    otherOpen = false;
    return false;
  }
});
