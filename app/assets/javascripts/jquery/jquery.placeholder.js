//make HTML5 placeholders work in non supportive browsers
//see: http://www.standardista.com/html5-placeholder-attribute-script
$("input[placeholder]").each(function(){
  if($(this).val()==""){
   // $(this).addClass('hasplaceholder');
    $(this).val($(this).attr("placeholder"));
    $(this).focus(function(){
      if($(this).val()==$(this).attr("placeholder")) $(this).val("");
     // $(this).removeClass('hasplaceholder');
    });
    $(this).blur(function(){
      if($(this).val()==""){
  // $(this).addClass('hasplaceholder');
         $(this).val($(this).attr("placeholder"));
      }
     });
  }
});

$('form').submit(function(evt){
  $('input[placeholder]').each(function(){
    if($(this).attr("placeholder") == $(this).val()) {$(this).val('');}
  });
});
