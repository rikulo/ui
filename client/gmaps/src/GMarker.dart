//Copyright (C) 2012 Potix Corporation. A:ll Rights Reserved.
//History: Mon, Jun 25, 2012  10:10:30 AM
// Author: hernichen

/**
 * Bridge Dart to Google Maps JavaScript object -- Marker; 
 * see https://developers.google.com/maps/documentation/javascript/reference#Marker for details.
 */
class GMarker implements JSPeer {
  //private JavaScript function
  static final String _NEW_MARKER = "gmarker.0";
  static bool _ready = false;
  
  var _gmarker; //JavaScript Marker object of Google Maps
  
  GMarker([Map markerOptions]) {
    _initJSFunctions();
    _gmarker = JSUtil.jsCall(_NEW_MARKER, [JSUtil.toJSMap(markerOptions, (v)=>JSUtil.toJSPeer(v))]);
  }

  toJSObject() {
    return _gmarker;
  }
  
  _initJSFunctions() {
    if (_ready) return;
    _ready = true;
    JSUtil.newJSFunction(_NEW_MARKER, ["opts"], "return new window.google.maps.Marker(opts);");
  }
}
