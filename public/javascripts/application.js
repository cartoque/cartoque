$(function() {
  $("#applications th a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
  $("#applications_search").submit(function() {
    $.get(this.action, $(this).serialize(), null, "script");
    return false;
  });
});
