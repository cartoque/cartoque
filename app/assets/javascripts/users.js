//generate token button
$(function() {
  $("#generate-token").live("click", function(e) {
    $(this).html("Génération...");
    $(this).disabled = true;
    $.ajax({
      type: "GET",
      url: "/users/random_token",
      //data: $(this).val(),
      //dataType: "script",
      callback: null
    });
    $(this).html("Générer");
    return false;
  });
  $("#remove-token").live("click", function(e) {
    $("#authentication_token").html("");
    $("#user_authentication_token").attr("value", "");
    $("#remove-token").hide();
    $("#generate-token").show();
    return false;
  });
});
