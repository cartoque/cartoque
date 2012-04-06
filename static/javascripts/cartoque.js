$(document).ready(function() {
  //screenshots on welcome page
	$("#screenshots a").fancybox({
		'overlayShow'	: false,
		'transitionIn'	: 'elastic',
		'transitionOut'	: 'elastic',
    'easingIn'      : 'easeOutBack',
    'easingOut'     : 'easeInBack',
		'titlePosition'	: 'over'
	});

  //syntax highlighting
  function showHiddenParagraphs() {
    $("p.hidden").fadeIn(500);
  }
  setTimeout(showHiddenParagraphs, 1000);
});
