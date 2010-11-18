$(function() {
  //applications
  $("#applications th a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
  $("#applications_search").keyup(function() {
    $.get(this.action, $(this).serialize(), null, "script");
    return false;
  });
  //machines
  $("#machines th a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
  $("#machines_search").keyup(function() {
    $.get(this.action, $(this).serialize(), null, "script");
    return false;
  });
});
