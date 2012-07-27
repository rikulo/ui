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
  void getCurrentHeading(CompassSuccessCallback success, CompassErrorCallback error) {
    var jsSuccess = JSUtil.toJSFunction((jsHeading) => success(new CompassHeading.from(JSUtil.toDartMap(jsHeading))), 1);
    var jsError = JSUtil.toJSFunction(error, 0);
    JSUtil.jsCall(_GET_CURRENT_HEADING, [jsSuccess, jsError]);
  }

  CompassSuccessCallback wrapSuccessListener_(CompassHeadingEventListener listener) {   
    return (jsHeading) => listener(new CompassHeadingEvent(this, new CompassHeading.from(JSUtil.toDartMap(jsHeading))));
  }

  CompassErrorCallback wrapErrorListener_(CompassHeadingErrorEventListener listener) {  
    return () {if (listener != null) listener(new CompassHeadingErrorEvent(this));};
  }
  
  watchHeading_(CompassSuccessCallback success, CompassErrorCallback error, [Map options]) {
    var jsSuccess = JSUtil.toJSFunction(success, 1);
    var jsError = JSUtil.toJSFunction(error, 0);
    return JSUtil.jsCall(_WATCH_HEADING, [jsSuccess, jsError, JSUtil.toJSMap(options)]);
  }
  
  void clearWatch_(var watchID) {
    JSUtil.jsCall(_CLEAR_WATCH, [watchID]);
  }
  
  static bool _doneInit = false;
  void _initJSFunctions() {
    if (_doneInit) return;

    JSUtil.newJSFunction(_GET_CURRENT_HEADING, ["onSuccess", "onError"],
      "navigator.compass.getCurrentCompassHeading(onSuccess, onError);");
    JSUtil.newJSFunction(_WATCH_HEADING, ["onSuccess", "onError", "opts"],
      "return navigator.compass.watchHeading(onSuccess, onError, opts);");
    JSUtil.newJSFunction(_CLEAR_WATCH, ["watchID"], "navigator.compass.clearWatch(watchID);");
    
    _doneInit = true;
  }
}
