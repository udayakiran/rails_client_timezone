// This is example code to set browser cookies. Assuming that your app uses prototypejs
// These methods need to be there ideally on each page.

var browser_tz_baseline_year = 2011; //change this to 'current' if needed

var tz_baseline_year = function() {
  return (browser_tz_baseline_year.toString() === "current") ? new Date().getFullYear() : browser_tz_baseline_year.toString();
}

var set_cookie = function(cname, cvalue, exdays) {
  var d = new Date();
  d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
  var expires = "expires=" + d.toUTCString();
  document.cookie = cname + "=" + cvalue + "; " + expires + "; path=/";
}

var set_browser_offsets = function() {
  var base_year = tz_baseline_year();
  var winterOffset = -1 * (new Date(base_year, 11, 21)).getTimezoneOffset() * 60;
  var summerOffset = -1 * (new Date(base_year, 5, 21)).getTimezoneOffset() * 60;
  set_cookie('utc_offset_summer', summerOffset, 360);
  set_cookie('utc_offset_winter', winterOffset, 360);
}

document.observe("dom:loaded", function() {
  set_browser_offsets();
});

Ajax.Responders.register({
  onCreate: function () {
    set_browser_offsets();
  }
});
 