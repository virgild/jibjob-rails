var RailsTimeZone = require('rails-timezone');
var jstz = require('jstimezonedetect').jstz;

module.exports.SetupTimeZone = function() {
  var tz = jstz.determine();
  var rails_tz = RailsTimeZone.to(tz.name());
  $("form#new_user input[name='user[timezone]']").val(rails_tz);
};