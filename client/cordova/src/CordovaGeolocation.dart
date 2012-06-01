//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  09:13:10 AM
// Author: henrichen

/**
 * Geolocation implementation for Cordova device.
 */
class CordovaGeolocation extends AbstractGeolocation {
	void getCurrentPosition(GeolocationSuccessCallback onSuccess, [GeolocationErrorCallback onError, GeolocationOptions options]) {
	  jsCall("geolocation.getCurrentPosition", [_wrapFunction(onSuccess), onError, toJSMap(_toMap(options))]);
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
	
  GeolocationErrorCallback wrapErrorListener_(PositionEventListener listener) {   
    return (jsPosErr) => 
        listener(new PositionEvent(this, null, new PositionErrorImpl.from(toDartMap(jsPosErr))));
  }
  
	GeolocationSuccessCallback _wrapFunction(GeolocationSuccessCallback dartFn) {   
		return (jsPos) => 
		    dartFn(new Position(new CoordinatesImpl.from(toDartMap(jsPos.coords)), jsCall("get", [jsPos, "timestamp"])));
	}
	
	GeolocationErrorCallback _wrapErrorFunction(GeolocationErrorCallback dartFn) {
	  return (jsPosErr) => dartFn(new PositionErrorImpl.from(toDartMap(jsPosErr)));
	}

	watchPosition(GeolocationSuccessCallback onSuccess, [GeolocationErrorCallback onError, Map options]) {
	  jsCall("geolocation.watchPosition", [onSuccess, onError, toJSMap(options)]);
	}
	
	void clearWatch(var watchID) {
		jsCall("geolocation.clearWatch", [watchID]);
	}
}
