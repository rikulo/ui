//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  09:13:10 AM
// Author: henrichen

/**
 * Geolocation implementation for Cordova device.
 */
class CordovaGeolocation extends AbstractGeolocation {
  static final String _GET_CURRENT_POSITION = "geo.1";
  static final String _WATCH_POSITION = "geo.2";
  static final String _CLEAR_WATCH = "geo.3";
  
  CordovaGeolocation() {
    _initJSFunctions();
  }
  void getCurrentPosition(GeolocationSuccessCallback success, [GeolocationErrorCallback error, GeolocationOptions options]) {
    var jsSuccess = JSUtil.toJSFunction((jsPos) => 
      success(new Position(new _Coordinates.from(JSUtil.toDartMap(jsPos.coords)), JSUtil.getJSValue(jsPos, "timestamp"))), 1);
    var jsError = JSUtil.toJSFunction((jsPosErr) {
      if (error != null) error(new _PositionError.from(JSUtil.toDartMap(jsPosErr)));}, 1);
    JSUtil.jsCall(_GET_CURRENT_POSITION, [jsSuccess, jsError, JSUtil.toJSMap(_toMap(options))]);
  }

  _toMap(GeolocationOptions options) {
    return {
      "frequency" : options.frequency == null ? 10000 : options.frequency,
      "enableHighAccuracy" : options.enableHighAccuracy == null ? true : options.enableHighAccuracy,
      "timeout" : options.timeout == null ? 10000 : options.timeout,
      "maximumAge" : options.maximumAge == null ? 10000 : options.maximumAge
    };
  }
  
  GeolocationSuccessCallback wrapSuccessListener_(PositionEventListener listener) {   
    return (jsPos) => 
      listener(new PositionEvent(this, new Position(new _Coordinates.from(JSUtil.toDartMap(jsPos.coords)), JSUtil.getJSValue(jsPos, "timestamp"))));
  }
  
  GeolocationErrorCallback wrapErrorListener_(PositionErrorEventListener listener) {   
    return (jsPosErr) {
      if (listener != null)  
        listener(new PositionErrorEvent(this, new _PositionError.from(JSUtil.toDartMap(jsPosErr))));
    };
  }
  
  watchPosition_(GeolocationSuccessCallback success, [GeolocationErrorCallback error, Map options]) {
    var jsSuccess = JSUtil.toJSFunction(success, 1);
    var jsError = JSUtil.toJSFunction(error, 1);
    JSUtil.jsCall(_WATCH_POSITION, [jsSuccess, jsError, JSUtil.toJSMap(options)]);
  }
  
  void clearWatch_(var watchID) {
    JSUtil.jsCall(_CLEAR_WATCH, [watchID]);
  }
  
  static bool _doneInit = false;
  void _initJSFunctions() {
    if (_doneInit) return;

    JSUtil.newJSFunction(_GET_CURRENT_POSITION, ["onSuccess", "onError", "opts"],
      "navigator.geolocation.getCurrentPosition(onSuccess, onError, opts);");
    JSUtil.newJSFunction(_WATCH_POSITION, ["onSuccess", "onError", "opts"],
      "return navigator.geolocation.watchPosition(onSuccess, onError, opts);");
    JSUtil.newJSFunction(_CLEAR_WATCH, ["watchID"], "navigator.geolocation.clearWatch(watchID);");

    _doneInit = true;
  }
}

class _PositionError implements PositionError {
  int code;
  String message;
  
  _PositionError(int this.code, String this.message);
  
  _PositionError.from(Map map) : this(map["code"], map["message"]);
}
class _Coordinates implements Coordinates {
  /** Latitude in decimal degrees. */
  double latitude;
  /** Longitude in decimal degrees. */
  double longitude;
  /** Height of the position in meters above the ellipsoid. */
  double altitude;
  /** Accuracy level of the latitude and longitude in meters. */
  double accuracy;
  /** Accuracy level of altitude in meters. */
  double altitudeAccuracy;
  /** Direction of travel in degrees to true north (north is 0 degree, east is 90 degree, south is 180 degree, west is 270 degree) */
  double heading;
  /** Ground speed in meters per second */
  double speed;
  
  _Coordinates(this.latitude, this.longitude, this.altitude, 
    this.accuracy, this.altitudeAccuracy, this.heading, this.speed);
  _Coordinates.from(Map coords) :
    this(coords["latitude"], coords["longitude"], coords["altitude"],
      coords["accuracy"],  coords["altitudeAccuracy"], coords["heading"],
      coords["speed"]);
}
