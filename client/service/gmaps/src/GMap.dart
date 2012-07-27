//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Jun 22, 2012  10:30:28 AM
// Author: hernichen

/**
 * Bridge Dart to Google Maps JavaScript object -- Map; 
 * see <https://developers.google.com/maps/documentation/javascript/reference#Map> for details.
 */
class GMap implements JSAgent {
  //private JavaScript function
  static final String _NEW_MAP = "gmaps.0";
  static final String _GET_MAP_TYPE_ID = "gmaps.1";
  static final String _SET_MAP_TYPE_ID = "gmaps.2";
  static final String _GET_CENTER = "gmaps.3";
  static final String _SET_CENTER = "gmaps.4";
  static final String _RESIZE = "gmaps.5";
  static final String _SET_OPTIONS = "gmaps.6";

  static LoadableModule _mapsModule;
  
  String _mapCanvas; //maps canvas, element to place maps content
  String _version; //maps module version
  Map _options; //options for loading the maps module
  var _jsMap; //JavaScript Map object of Google Maps
  
  /**
   * Prepare a Google Maps; see <https://developers.google.com/maps/documentation/javascript/tutorial> for details.
   * + [mapCanvas] - the id of the HTML div element to be associated with the Google Maps.
   * + [version] - the Google Maps API version to be loaded; default "3.9".
   * + [options] - special options when loading Google Maps API such as "sensor" and Google API "key"; default to {"sensor":true}.
   */
  GMap(String mapCanvas, [String version="3.9", Map options= const {"sensor":true}]) :
    _mapCanvas = mapCanvas, _version = version, _options = options {
    if (_mapsModule == null) {
      _mapsModule = new LoadableModule(_loadModule);
      _mapsModule.doWhenLoaded(null); //force loading module
    }
  }
  
  /**
   * Force Google Maps to re-sync with its container size; mostly called
   * when the container size changes.
   */ 
  void checkResize() {
    JSUtil.jsCall(_RESIZE, [_jsMap]);
  }
  
  void setOptoins(Map mapOptions) {
    JSUtil.jsCall(_SET_OPTIONS, [_jsMap, _toJSOptions(mapOptions)]);
  }
  
  getMapTypeId() {
    String key = JSUtil.jsCall(_GET_MAP_TYPE_ID, [_jsMap]);
    MapTypeId typeid = MapTypeId._lookFrom(key);
    return typeid != null ? typeid : key;
  }
  
  void setMapTypeId(var mapTypeId) { //MapTypeId or String
    JSUtil.jsCall(_SET_MAP_TYPE_ID, [_jsMap, mapTypeId is MapTypeId ? mapTypeId.toJSObject() : mapTypeId]);
  }
  
  LatLng getCenter() {
    return new LatLng.fromJSObject(JSUtil.jsCall(_GET_CENTER, [_jsMap]));
  }
  
  void setCenter(LatLng latlng) {
    JSUtil.jsCall(_SET_CENTER, [_jsMap, latlng.toJSObject()]);
  }
  
  //load maps module
  void _loadModule(Function readyFn) {
    _initJSFunctions();

    StringBuffer sb = new StringBuffer();
    if (_options != null)
      _options.forEach((k, v) => sb.add(sb.isEmpty() ? "" : "&").add(k).add("=").add(v));
      
    Map options = new Map();
    if (!sb.isEmpty())
      options["other_params"] = sb.toString();
    options["callback"] = readyFn; //callback after Maps API is loaded

    GLoader.load(GLoader.MAPS, _version, options); //load Maps API
  }    
  
  /**
   * init Google Maps with initial maps options; 
   * see https://developers.google.com/maps/documentation/javascript/reference#MapOptions for details.
   * + [mapOptions] - options for map's initialization.
   * + [onSuccess] - callback when the GMap is successfully initialized.
   */
  init(Map mapOptions, GMapSuccessCallback onSuccess) {
    if (_jsMap == null)
      _mapsModule.doWhenLoaded((){_init(mapOptions); if (onSuccess != null) onSuccess(this);});
  }

  //convert Dart Map to JavaScript options
  _toJSOptions(Map mapOptions) {
    return JSUtil.toJSMap(mapOptions, (k,v)=>JSUtil.toJSAgent(v));
  }
  
  //init the specified Maps
  void _init(Map mapOptions) {
    if (_jsMap == null) {
      Element div = query("#$_mapCanvas");
      if (div == null) {
        throw new IllegalArgumentException("mapCanvas: Cannot find the specified HTML element, $_mapCanvas");
      }
      _jsMap = JSUtil.jsCall(_NEW_MAP, [div, _toJSOptions(mapOptions)]); 
    }
  }
  
  toJSObject() {
    return _jsMap;
  }
  
  void _initJSFunctions() {
    JSUtil.newJSFunction(_NEW_MAP, ["mapdiv", "mapOptions"], "return new window.google.maps.Map(mapdiv, mapOptions);");
    JSUtil.newJSFunction(_GET_MAP_TYPE_ID, ["gmap"], "return gmap.getMapTypeId();");
    JSUtil.newJSFunction(_SET_MAP_TYPE_ID, ["gmap", "id"], "return gmap.setMapTypeId(id);");
    JSUtil.newJSFunction(_GET_CENTER, ["gmap"], "return gmap.getCenter();");
    JSUtil.newJSFunction(_SET_CENTER, ["gmap", "latlng"], "return gmap.setCenter(latlng);");
    JSUtil.newJSFunction(_RESIZE, ["gmap"], '''
      var c = gmap.getCenter();
      window.google.maps.event.trigger(gmap, "resize");
      gmap.setCenter(c);
    ''');
  }
}

typedef GMapSuccessCallback(GMap gmap);