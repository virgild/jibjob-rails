var RailsTimeZone = require('rails-timezone');

module.exports.SetupTimeZone = function() {
  var tz = jstz.determine();
  var rails_tz = RailsTimeZone.to(tz.name());
  window.rtz = RailsTimeZone;
  $("form#new_user input[name='user[timezone]']").val(rails_tz);
};