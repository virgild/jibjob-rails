(function(win) {
  $(function() {
    if ($("form#new_user").length) {
      var timezone = jstz.determine();
      var rails_tz = win.RailsTimeZone.to(timezone.name());
      $("form#new_user input[name='user[timezone]']").val(rails_tz);
    }
  });
}(this));