//generate token button
$(function() {
  $("#generate-token").live("click", function(e) {
    $(this).disabled = true;
    $.rails.ajax({
      type: "GET",
      url: "/users/random_token",
      //data: $(this).val(),
      //dataType: "script",
      callback: null
    });
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
