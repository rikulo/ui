//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  07:00:09 PM
// Author: henrichen

/**
 * Compass implementation for Cordova device.
 */
class CordovaCompass extends AbstractCompass {
  static final String _GET_CURRENT_HEADING = "comp.1";
  static final String _WATCH_HEADING = "comp.2";
  static final String _CLEAR_WATCH = "comp.3";
  CordovaCompass() {
    _initJSFunctions();
  }
  void getCurrentHeading(CompassSuccessCallback onSuccess, CompassErrorCallback onError) {
    jsutil.jsCall(_GET_CURRENT_HEADING, [_wrapFunction(onSuccess), onError]);
  }

  CompassSuccessCallback _wrapFunction(CompassSuccessCallback dartFn) {   
    return (jsHeading) => dartFn(new CompassHeading.from(jsutil.toDartMap(jsHeading)));
  }
  
  CompassSuccessCallback wrapSuccessListener_(CompassHeadingEventListener listener) {   
    return (jsHeading) => listener(new CompassHeadingEvent(this, new CompassHeading.from(jsutil.toDartMap(jsHeading))));
  }

  CompassErrorCallback wrapErrorListener_(CompassHeadingErrorEventListener listener) {  
    return () {if (listener !== null) listener(new CompassHeadingErrorEvent(this));};
  }
  
  watchHeading(CompassSuccessCallback onSuccess, CompassErrorCallback onError, [Map options]) {
    return jsutil.jsCall(_WATCH_HEADING, [onSuccess, onError, jsutil.toJSMap(options)]);
  }
  
  void clearWatch(var watchID) {
    jsutil.jsCall(_CLEAR_WATCH, [watchID]);
  }
  
  void _initJSFunctions() {
    jsutil.newJSFunction(_GET_CURRENT_HEADING, ["onSuccess", "onError"], '''
      var fnSuccess = function(heading) {onSuccess.\$call\$1(heading);},
          fnError = function() {onError.\$call\$0();};
      navigator.compass.getCurrentCompassHeading(fnSuccess, fnError);
    ''');
    jsutil.newJSFunction(_WATCH_HEADING, ["onSuccess", "onError", "opts"], '''
      var fnSuccess = function(heading) {onSuccess.\$call\$1(heading);},
          fnError = function() {onError.\$call\$0();};
      return navigator.compass.watchHeading(fnSuccess, fnError, opts);
    ''');
    jsutil.newJSFunction(_CLEAR_WATCH, ["watchID"], "navigator.compass.clearWatch(watchID);");
  }
}
