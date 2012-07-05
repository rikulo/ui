//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Jun 22, 2012  03:19:59 PM
// Author: hernichen

/**
 * Bridge Dart to Google Maps JavaScript Object -- LatLng; 
 * see <https://developers.google.com/maps/documentation/javascript/reference#LatLng> for details.
 */
class LatLng implements JSAgent {
  static final String _NEW_LAT_LNG = "latlng.0";
  static final String _LNG = "latlng.1";
  static final String _LAT = "latlng.2";
  
  final bool _noWrap;
  final double lat;
  final double lng;
  
  LatLng(this.lat, this.lng, [bool noWrap = false]) : _noWrap = noWrap {
    _initJSFunctions();
  }
  
  LatLng.fromJSObject(var jsobj) :
    lat = JSUtil.jsCall(_LAT, [jsobj]),
    lng = JSUtil.jsCall(_LNG, [jsobj]),
    _noWrap = false;
  
  toJSObject() {
    return JSUtil.jsCall(_NEW_LAT_LNG, [lat, lng, _noWrap]);
  }
  
  static bool _doneInit = false;
  void _initJSFunctions() {
    if (_doneInit) return;

    JSUtil.newJSFunction(_NEW_LAT_LNG, ["lat","lng","noWrap"], "return new window.google.maps.LatLng(lat,lng,noWrap);");
    JSUtil.newJSFunction(_LNG, ["latlng"], "return latlng.lng();");
    JSUtil.newJSFunction(_LAT, ["latlng"], "return latlng.lat();");

    _doneInit = true;
  }
}
