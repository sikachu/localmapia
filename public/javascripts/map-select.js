// Javascript for loading the map
$("body").unload(function(){
  GUnload();
});

$(document).ready(function(){
  if (GBrowserIsCompatible()) {
    map = new GMap2(document.getElementById("add-location-map"));
    map.setCenter(new GLatLng(13.751724, 100.506706), 12);
    map.setUIToDefault();
  }
});