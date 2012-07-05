//Copyright (C) 2012 Potix Corporation. A:ll Rights Reserved.
//History: Mon, Jun 25, 2012  10:10:30 AM
// Author: hernichen

/**
 * Bridge Dart to Google Maps JavaScript object -- Marker; 
 * see <https://developers.google.com/maps/documentation/javascript/reference#Marker> for details.
 */
class GMarker implements JSAgent {
  //private JavaScript function
  static final String _NEW_MARKER = "gmarker.0";
  
  var _gmarker; //JavaScript Marker object of Google Maps
  
  GMarker([Map markerOptions]) {
    _initJSFunctions();
    _gmarker = JSUtil.jsCall(_NEW_MARKER, [JSUtil.toJSMap(markerOptions, (k,v)=>JSUtil.toJSAgent(v))]);
  }

  toJSObject() {
    return _gmarker;
  }
  
  static bool _doneInit = false;
  _initJSFunctions() {
    if (_doneInit) return;
    
    JSUtil.newJSFunction(_NEW_MARKER, ["opts"], "return new window.google.maps.Marker(opts);");
    
    _doneInit = true;
  }
}
