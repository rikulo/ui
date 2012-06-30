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
    jsutil.jsCall(_GET_CURRENT_ACCELERATION, [_wrapFunction(success), error]);
  }
  
  AccelerometerSuccessCallback wrapSuccessListener_(AccelerationEventListener listener) {
    return (jsAccel) => listener(new AccelerationEvent(this, new Acceleration.from(jsutil.toDartMap(jsAccel))));
  }
  
  AccelerometerErrorCallback wrapErrorListener_(AccelerationErrorEventListener listener) {
    return () {if (listener !== null) listener(new AccelerationErrorEvent(this));};
  }

  _wrapFunction(dartFn) {
    return (jsAccel) => dartFn(new Acceleration.from(jsutil.toDartMap(jsAccel)));
  }
  
  watchAcceleration_(AccelerometerSuccessCallback success, AccelerometerErrorCallback error, [Map options]) {
    return jsutil.jsCall(_WATCH_ACCELERATION, [success, error, jsutil.toJSMap(options)]);
  }
  
  void clearWatch_(var watchID) {
    jsutil.jsCall(_CLEAR_WATCH, [watchID]);
  }
  
  void _initJSFunctions() {
      jsutil.newJSFunction(_GET_CURRENT_ACCELERATION, ["onSuccess", "onError"], ''' 
        var fnSuccess = function(accel) {onSuccess.\$call\$1(accel);},
            fnError = function() {onError.\$call\$0();};
        navigator.accelerometer.getCurrentAcceleration(fnSuccess, fnError);
      ''');
      jsutil.newJSFunction(_WATCH_ACCELERATION, ["onSuccess", "onError", "opts"], '''
        var fnSuccess = function(accel) {onSuccess.\$call\$1(accel);},
            fnError = function() {onError.\$call\$0();};
        return navigator.accelerometer.watchAcceleration(fnSuccess, fnError, opts);
      ''');
      jsutil.newJSFunction(_CLEAR_WATCH, ["watchID"], "navigator.accelerometer.clearWatch(watchID);");
  }
}