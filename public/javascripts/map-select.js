// Javascript for loading the map
var map, region;
var editable = false;
var edit_enable = false;
var region_marked = false;

function initialize_map(lat, lng, zoom){
  map = new GMap2(document.getElementById("add-location-map"));
  map.setCenter(new GLatLng(lat, lng), zoom);
  map.setUIToDefault();
  map.removeMapType(G_PHYSICAL_MAP);
  if(zoom >= 16){
    editable = true;
    $('#mark_region_button').attr('disabled', false);
  }

  $('#reset_region_button, #submit_button').attr('disabled', true);

  GEvent.addListener(map, "zoomend", function(oldLevel, newLevel){
    editable = (newLevel >= 16)
    if(newLevel >= 16 && !region_marked){
      $('#mark_region_button').attr('disabled', false);
    } else {
      $('#mark_region_button').attr('disabled', true);
    }
  });

  $('#mark_region_button').click(function(){
    if(!edit_enable){
      region = new GPolygon([], "#f33f00", 5, 1, "#ff0000", 0.2);
      map.addOverlay(region);
      region.enableDrawing();
      map.disableDragging();
      map.disableDoubleClickZoom();
      map.disableScrollWheelZoom();
  
      GEvent.addListener(region, "endline", function(){
        region_marked = true;
        $('#mark_region_button').attr('disabled', true).val("Mark Region");
        $('#reset_region_button, #submit_button').attr('disabled', false);
        edit_enable = false;
      });
      $(this).val("Cancel");
    } else {
      remove_overlay();
      $(this).val("Mark Region");
    }
    edit_enable = !edit_enable;
  });

  $('#reset_region_button').click(function(){
    region_marked = edit_enable = false;
    if(editable){ $('#mark_region_button').attr('disabled', false); }
    $('#reset_region_button, #submit_button').attr('disabled', true);
    remove_overlay();
  });

  $('#submit_button').click(function(){
    for(i = 0; i < region.getVertexCount() - 1; i++){
      $('#new_location').append('<input type="hidden" name="location[latlng][]" value="'+ region.getVertex(i).lat() +'|'+ region.getVertex(i).lng() + '" />');
    }
  });
}

function remove_overlay(){
  region.disableEditing();
  map.enableDragging();
  map.enableDoubleClickZoom();
  map.enableScrollWheelZoom();
  map.removeOverlay(region);
}  