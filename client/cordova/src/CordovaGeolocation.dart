//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  09:13:10 AM
// Author: henrichen

/**
 * Geolocation implementation for Cordova device.
 */
class CordovaGeolocation extends AbstractGeolocation {
  static final String _GET_CURRENT_POSITION = "geolocation.getCurrentPosition";
  static final String _WATCH_POSITION = "geolocation.watchPosition";
  static final String _CLEAR_WATCH = "geolocation.clearWatch";
  
  CordovaGeolocation() {
    _initJSFunctions();
  }
  void getCurrentPosition(GeolocationSuccessCallback onSuccess, [GeolocationErrorCallback onError, GeolocationOptions options]) {
    jsCall(_GET_CURRENT_POSITION, [_wrapFunction(onSuccess), onError, toJSMap(_toMap(options))]);
  }

  _toMap(GeolocationOptions options) {
    return {
      "frequency" : options.frequency === null ? 10000 : options.frequency,
      "enableHighAccuracy" : options.enableHighAccuracy === null ? true : options.enableHighAccuracy,
      "timeout" : options.timeout === null ? 10000 : options.timeout,
      "maximumAge" : options.maximumAge === null ? 10000 : options.maximumAge
    };
  }
  
  GeolocationSuccessCallback wrapSuccessListener_(PositionEventListener listener) {   
    return (jsPos) => 
        listener(new PositionEvent(this, new Position(new CoordinatesImpl.from(toDartMap(jsPos.coords)), jsCall("get", [jsPos, "timestamp"]))));
  }
  
  GeolocationErrorCallback wrapErrorListener_(PositionErrorEventListener listener) {   
    return (jsPosErr) {
      if (listener !== null)  
        listener(new PositionErrorEvent(this, new PositionErrorImpl.from(toDartMap(jsPosErr))));
    };
  }
  
  GeolocationSuccessCallback _wrapFunction(GeolocationSuccessCallback dartFn) {   
    return (jsPos) => 
        dartFn(new Position(new CoordinatesImpl.from(toDartMap(jsPos.coords)), jsCall("get", [jsPos, "timestamp"])));
  }
  
  GeolocationErrorCallback _wrapErrorFunction(GeolocationErrorCallback dartFn) {
    return (jsPosErr) => dartFn(new PositionErrorImpl.from(toDartMap(jsPosErr)));
  }

  watchPosition(GeolocationSuccessCallback onSuccess, [GeolocationErrorCallback onError, Map options]) {
    jsCall(_WATCH_POSITION, [onSuccess, onError, toJSMap(options)]);
  }
  
  void clearWatch(var watchID) {
    jsCall(_CLEAR_WATCH, [watchID]);
  }
  
  void _initJSFunctions() {
    newJSFunction(_GET_CURRENT_POSITION, ["onSuccess", "onError", "opts"], '''
      var fnSuccess = function(pos) {onSuccess.\$call\$1(pos);},
          fnError = function(err) {onError.\$call\$1(err);};
      navigator.geolocation.getCurrentPosition(fnSuccess, fnError, opts);
    ''');
    newJSFunction(_WATCH_POSITION, ["onSuccess", "onError", "opts"], '''
      var fnSuccess = function(pos) {onSuccess.\$call\$1(pos);},
        fnError = function(err) {onError.\$call\$1(err);};
      return navigator.geolocation.watchPosition(fnSuccess, fnError, opts);
    ''');
    newJSFunction(_CLEAR_WATCH, ["watchID"], "navigator.geolocation.clearWatch(watchID);");
  }
}
