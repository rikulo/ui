//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  07:00:09 PM
// Author: henrichen

/**
 * Compass implementation for Cordova device.
 */
class CordovaCompass extends AbstractCompass {
  CordovaCompass() {
    _initJSFunctions();
  }
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
  
  void _initJSFunctions() {
    newJSFunction("compass.getCurrentCompassHeading", ["onSuccess", "onError"], '''
      var fnSuccess = function(heading) {onSuccess.\$call\$1(heading);},
          fnError = function() {onError.\$call\$0();};
      navigator.compass.getCurrentCompassHeading(fnSuccess, fnError);
    ''');
    newJSFunction("compass.watchHeading", ["onSuccess", "onError", "opts"], '''
      var fnSuccess = function(heading) {onSuccess.\$call\$1(heading);},
          fnError = function() {onError.\$call\$0();};
      return navigator.compass.watchHeading(fnSuccess, fnError, opts);
    ''');
    newJSFunction("compass.clearWatch", ["watchID"], "navigator.compass.clearWatch(watchID);");
  }
}
