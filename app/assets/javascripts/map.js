var map;
var MY_MAPTYPE_ID = 'custom_style';

function initialize(centerx,centery,zoom) {

	var featureOpts = [
  {
    "stylers": [
      { "hue": "#ffff00" },
      { "saturation": 95 },
      { "gamma": 0.36 },
      { "lightness": -4 }
    ]
  },{
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      { "color": "#ececec" }
    ]
  },{
    "featureType": "transit",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "poi",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
  }
]

    var map_canvas = document.getElementById('map_canvas');
    if(!centerx || centerx=='')
      var centerx = 34.043805
    if(!centery || centery=='')
      var centery = -118.254917
    if(!zoom || zoom=='' || zoom==0)
      var zoom = 14;

    var map_options = {
      center: new google.maps.LatLng(centerx,centery),
      zoom: parseInt(zoom),
      panControl:false,
      zoomControl:true,
      mapTypeControl:false,
      scaleControl:false,
      streetViewControl:false,
      overviewMapControl:false,
      rotateControl:false,    
      mapTypeId: MY_MAPTYPE_ID
    }
    map = new google.maps.Map(map_canvas, map_options);
    var styledMapOptions = {
    	name: 'Custom Style'
  	};
  	var customMapType = new google.maps.StyledMapType(featureOpts, styledMapOptions);
  	map.mapTypes.set(MY_MAPTYPE_ID, customMapType)
    return map;
}
