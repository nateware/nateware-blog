/* map of sites */
$(function(){
  var req_url = window.location.pathname.substr(1);
  var url_map = {
    "2011/02/10/controlling-what-you-can/" : "controlling-what-you-can.html",
    "2010/06/14/atomic-rant-redux/"        : "atomic-rant-redux.html",
    "2010/02/18/an-atomic-rant/"           : "an-atomic-rant.html",
    "2008/10/16/doppelganger-spotted-in-london/" : "doppelganger-spotted-in-london.html"
  };
  var new_url = url_map[req_url];
  if (new_url) {
    window.location.href = '/' + new_url;
  } else {
    $('#bad_url').html(req_url);
  }
});
