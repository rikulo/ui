//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 2, 2012  10:09:21 AM
// Author: henrichen

/**
 * Accelerometer implementation for Cordova device.
 */
class CordovaAccelerometer extends AbstractAccelerometer {
  static final String _GET_CURRENT_ACCELERATION = "acce.1";
  static final String _WATCH_ACCELERATION = "acce.2";
  static final String _CLEAR_WATCH = "acce.3";
  CordovaAccelerometer() {
    _initJSFunctions();
  }
  void getCurrentAcceleration(AccelerometerSuccessCallback success, AccelerometerErrorCallback error) {
    var jsSuccess = JSUtil.toJSFunction((jsAccel) => success(new Acceleration.from(JSUtil.toDartMap(jsAccel))), 1);
    var jsError = JSUtil.toJSFunction(error, 0); 
    JSUtil.jsCall(_GET_CURRENT_ACCELERATION, [jsSuccess, jsError]);
  }
  
  AccelerometerSuccessCallback wrapSuccessListener_(AccelerationEventListener listener) {
    return (jsAccel) => listener(new AccelerationEvent(this, new Acceleration.from(JSUtil.toDartMap(jsAccel))));
  }
  
  AccelerometerErrorCallback wrapErrorListener_(AccelerationErrorEventListener listener) {
    return () {if (listener != null) listener(new AccelerationErrorEvent(this));};
  }
  
  watchAcceleration_(AccelerometerSuccessCallback success, AccelerometerErrorCallback error, [Map options]) {
    var jsSuccess = JSUtil.toJSFunction(success,1);
    var jsError = JSUtil.toJSFunction(error,0);
    return JSUtil.jsCall(_WATCH_ACCELERATION, [jsSuccess, jsError, JSUtil.toJSMap(options)]);
  }
  
  void clearWatch_(var watchID) {
    JSUtil.jsCall(_CLEAR_WATCH, [watchID]);
  }
  
  static bool _doneInit = false;
  void _initJSFunctions() {
    if (_doneInit) return;
    
    JSUtil.newJSFunction(_GET_CURRENT_ACCELERATION, ["onSuccess", "onError"], 
      "navigator.accelerometer.getCurrentAcceleration(onSuccess, onError);");
    JSUtil.newJSFunction(_WATCH_ACCELERATION, ["onSuccess", "onError", "opts"],
      "return navigator.accelerometer.watchAcceleration(onSuccess, onError, opts);");
    JSUtil.newJSFunction(_CLEAR_WATCH, ["watchID"], "navigator.accelerometer.clearWatch(watchID);");
    
    _doneInit = true;
  }
}