var RailsTimeZone = require('rails-timezone');

module.exports.SetupTimeZone = function() {
  console.log(jstz());
  var rails_tz = RailsTimeZone.to(jstz().timezone_name);
  window.rtz = RailsTimeZone;
  $("form#new_user input[name='user[timezone]']").val(rails_tz);
};