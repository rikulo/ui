//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Jun 22, 2012  12:12:12 PM
// Author: hernichen

/**
 * Bridge Dart to Google Maps JavaScript Object, MapTypeId ; 
 * see <https://developers.google.com/maps/documentation/javascript/tutorial> for details.
 */
class MapTypeId implements JSAgent {
  //private JS functions
  static final String _GET_BUILT_IN_MAP_TYPE_ID = "maptyp.0";
  
  //control varables
  static Map _builtInTypeIds;
  
  //built-in map types
  static MapTypeId _roadmap;
  static MapTypeId get ROADMAP { //displays the default road map view
    if (_roadmap == null)
      _roadmap = new MapTypeId("ROADMAP");
    return _roadmap;
  }
  static MapTypeId _satellite;
  static MapTypeId get SATELLITE { // displays Google Earth satellite images
    if (_satellite == null)
      _satellite = new MapTypeId("SATELLITE");
    return _satellite;
  }
  static MapTypeId _hybrid;
  static MapTypeId get HYBRID {  // displays a mixture of normal and satellite views
    if (_hybrid == null)
      _hybrid = new MapTypeId("HYBRID");
    return _hybrid;
  }
  static MapTypeId _terrain; 
  static MapTypeId get TERRAIN { // displays a physical map based on terrain information.
    if (_terrain == null)
      _terrain = new MapTypeId("TERRAIN");
    return _terrain;
  }
  
  String _key;
  var _jsMapTypeId;
  
  MapTypeId(this._key) {
    _initJSFunctions();
  }
  
  String get name => this._key; 
  
  toJSObject() { //must make it a lazy initial to fit timing of maps module loading
    if (_jsMapTypeId == null) {
      _jsMapTypeId = JSUtil.jsCall(_GET_BUILT_IN_MAP_TYPE_ID, [_key]);
      _builtInTypeIds[_jsMapTypeId] = this;
    }
    return _jsMapTypeId;
  }
  
  void _initJSFunctions() {
    if (_builtInTypeIds != null) return;
    _builtInTypeIds = new Map();
    
    JSUtil.newJSFunction(_GET_BUILT_IN_MAP_TYPE_ID, ["key"], "return window.google.maps.MapTypeId[key];");
  }
  
  static MapTypeId _lookFrom(var jsMapTypeId) { //called by GMaps to look built-in MapTypeId back
    return _builtInTypeIds[jsMapTypeId];
  }
}
