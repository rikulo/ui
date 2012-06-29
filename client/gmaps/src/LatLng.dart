//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Jun 22, 2012  03:19:59 PM
// Author: hernichen

/**
 * Bridge Dart to Google Maps JavaScript Object -- LatLng; 
 * see https://developers.google.com/maps/documentation/javascript/reference#LatLng for details.
 */
class LatLng implements JSPeer {
  static final String _NEW_LAT_LNG = "latlng.0";
  static final String _LNG = "latlng.1";
  static final String _LAT = "latlng.2";
  static bool _ready = false;
  
  final bool _noWrap;
  final double lat;
  final double lng;
  
  LatLng(this.lat, this.lng, [bool noWrap = false]) : _noWrap = noWrap {
    _initJSFunction();
  }
  
  LatLng.fromJSObject(var jsobj) :
    lat = jsutil.jsCall(_LAT, [jsobj]),
    lng = jsutil.jsCall(_LNG, [jsobj]),
    _noWrap = false;
  
  toJSObject() {
    return jsutil.jsCall(_NEW_LAT_LNG, [lat, lng, _noWrap]);
  }
  
  void _initJSFunction() {
    if (_ready) return;
    _ready = true;

    jsutil.newJSFunction(_NEW_LAT_LNG, ["lat","lng","noWrap"], "return new window.google.maps.LatLng(lat,lng,noWrap);");
    jsutil.newJSFunction(_LNG, ["latlng"], "return latlng.lng();");
    jsutil.newJSFunction(_LAT, ["latlng"], "return latlng.lat();");
  }
}
