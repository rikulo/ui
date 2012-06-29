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
  void getCurrentPosition(GeolocationSuccessCallback onSuccess, [GeolocationErrorCallback onError, GeolocationOptions options]) {
    jsutil.jsCall(_GET_CURRENT_POSITION, [_wrapFunction(onSuccess), onError, jsutil.toJSMap(_toMap(options))]);
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
        listener(new PositionEvent(this, new Position(new CoordinatesImpl.from(jsutil.toDartMap(jsPos.coords)), jsutil.getJSValue(jsPos, "timestamp"))));
  }
  
  GeolocationErrorCallback wrapErrorListener_(PositionErrorEventListener listener) {   
    return (jsPosErr) {
      if (listener !== null)  
        listener(new PositionErrorEvent(this, new PositionErrorImpl.from(jsutil.toDartMap(jsPosErr))));
    };
  }
  
  GeolocationSuccessCallback _wrapFunction(GeolocationSuccessCallback dartFn) {   
    return (jsPos) => 
        dartFn(new Position(new CoordinatesImpl.from(jsutil.toDartMap(jsPos.coords)), jsutil.getJSValue(jsPos, "timestamp")));
  }
  
  GeolocationErrorCallback _wrapErrorFunction(GeolocationErrorCallback dartFn) {
    return (jsPosErr) => dartFn(new PositionErrorImpl.from(jsutil.toDartMap(jsPosErr)));
  }

  watchPosition(GeolocationSuccessCallback onSuccess, [GeolocationErrorCallback onError, Map options]) {
    jsutil.jsCall(_WATCH_POSITION, [onSuccess, onError, jsutil.toJSMap(options)]);
  }
  
  void clearWatch(var watchID) {
    jsutil.jsCall(_CLEAR_WATCH, [watchID]);
  }
  
  void _initJSFunctions() {
    jsutil.newJSFunction(_GET_CURRENT_POSITION, ["onSuccess", "onError", "opts"], '''
      var fnSuccess = function(pos) {onSuccess.\$call\$1(pos);},
          fnError = function(err) {onError.\$call\$1(err);};
      navigator.geolocation.getCurrentPosition(fnSuccess, fnError, opts);
    ''');
    jsutil.newJSFunction(_WATCH_POSITION, ["onSuccess", "onError", "opts"], '''
      var fnSuccess = function(pos) {onSuccess.\$call\$1(pos);},
        fnError = function(err) {onError.\$call\$1(err);};
      return navigator.geolocation.watchPosition(fnSuccess, fnError, opts);
    ''');
    jsutil.newJSFunction(_CLEAR_WATCH, ["watchID"], "navigator.geolocation.clearWatch(watchID);");
  }
}
