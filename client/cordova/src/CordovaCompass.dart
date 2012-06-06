//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  07:00:09 PM
// Author: henrichen

/**
 * Compass implementation for Cordova device.
 */
class CordovaCompass extends AbstractCompass {
  void getCurrentHeading(CompassSuccessCallback onSuccess, CompassErrorCallback onError) {
    jsCall("compass.getCurrentCompassHeading", [_wrapFunction(onSuccess), onError]);
  }

  CompassSuccessCallback _wrapFunction(CompassSuccessCallback dartFn) {   
    return (jsHeading) => dartFn(new CompassHeading.from(toDartMap(jsHeading)));
  }
  
  CompassSuccessCallback wrapSuccessListener_(CompassHeadingEventListener listener) {   
    return (jsHeading) => listener(new CompassHeadingEvent(this, new CompassHeading.from(toDartMap(jsHeading))));
  }

  CompassErrorCallback wrapErrorListener_(CompassHeadingEventListener listener) {   
    return () => listener(new CompassHeadingEvent(this, null, false));
  }
  
  watchHeading(CompassSuccessCallback onSuccess, CompassErrorCallback onError, [Map options]) {
    return jsCall("compass.watchHeading", [onSuccess, onError, toJSMap(options)]);
  }
  
  void clearWatch(var watchID) {
    jsCall("compass.clearWatch", [watchID]);
  }
}
