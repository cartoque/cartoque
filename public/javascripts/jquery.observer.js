/* form observer ; see: http://blessednotes.wordpress.com/2009/07/28/jquery-form-changes-observer/ */
$.fn.observe = function(time, callback) {
  return this.each(function() {
    var form = this, change = false;
    $(form.elements).change(function() {
      change = true;
    });
    setInterval(function() {
      if (change) callback.call(form);
      change = false;
    }, time * 1000);
  });
};
