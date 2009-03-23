function initialize_map(lat, lng, regions){
  var map = new GMap2(document.getElementById("map-display"));
  var latlng = new GLatLng(lat, lng);
  map.setCenter(latlng, 17);
  map.disableDragging();
  map.disableDoubleClickZoom();
  map.disableScrollWheelZoom();
  map.addOverlay(new GMarker(latlng));
  map.addOverlay(new GPolygon(regions, "#f33f00", 2, 1, "#ff0000", 0.2));
}