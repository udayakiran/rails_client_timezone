// This is example code to set browser cookies. Assuming that your app uses jQuery and jquery-cookie libraries.
// These methods need to be there ideally on each page.

var browser_tz_baseline_year = 2011; //change this to 'current' if needed

var tz_baseline_year = function () {
  return (browser_tz_baseline_year.toString() === "current") ? new Date().getFullYear() : browser_tz_baseline_year.toString();
}

var set_browser_offsets = function () {
  var base_year = tz_baseline_year();
  var winterOffset = -1 * (new Date(base_year, 11, 21)).getTimezoneOffset() * 60;
  var summerOffset = -1 * (new Date(base_year, 5, 21)).getTimezoneOffset() * 60;
  $.cookie('utc_offset_summer', null, {path: '/'});
  $.cookie('utc_offset_winter', null, {path: '/'});
  $.cookie('utc_offset_summer', summerOffset, {path: '/'});
  $.cookie('utc_offset_winter', winterOffset, {path: '/'});
}

$(document).ready(function () {
  set_browser_offsets();
});

$(document).ajaxStart(function () {
  set_browser_offsets();
});

window.onbeforeunload = function() {
  set_browser_offsets();
};