//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 4, 2012  04:45:33 PM
// Author: henrichen

abstract class AbstractAccelerometer implements Accelerometer {
  AccelerationEvents _on;
  List<WatchIDInfo> _listeners;
  
  AbstractAccelerometer() {
    _listeners = new List<WatchIDInfo>();
  }

  AccelerationEvents get on() {
    if (_on === null)
      _on = new AccelerationEvents(this);
    return _on;
  }

  void addEventListener(String type, AccelerationEventListener listener, [Map options]) {
    removeEventListener(type, listener);
    var watchID = watchAcceleration(wrapSuccessListener_(listener), wrapErrorListener_(listener), options);
    _listeners.add(new WatchIDInfo(listener, watchID));
  }

  void removeEventListener(String type, AccelerationEventListener listener) {
    for(int j = 0; j < _listeners.length; ++j) {
      if (_listeners[j]._listener == listener) {
        var watchID = _listeners[j]._watchID;
        if (watchID !== null) {
          clearWatch(watchID);
        }
        break;
      }
    }
  }
  
  bool isEventListened(String type) {
    return _listeners.isEmpty();
  }

  /** Returns the wrapped AccelerometerSuccessCallback from the given AccelerationEventListener */
  abstract AccelerometerSuccessCallback wrapSuccessListener_(AccelerationEventListener listener);
  
  /** Returns the wrapped AccelerometerErrorCallback from the given AccelerationEventListener */
  abstract AccelerometerErrorCallback wrapErrorListener_(AccelerationEventListener listener);
  
  /**
  * Returns the motion Acceleration along x, y, and z axis at a specified(optional) regular interval.
  * The Acceleration is returned via the onSuccess callback function at a regular interval.
  * options = {"frequency" : 3000}; //update every 3 seconds
  * @return a watchID that can be used to stop this watching later by #clearWatch() method.
  */  
  abstract watchAcceleration(AccelerometerSuccessCallback onSuccess, AccelerometerErrorCallback onError, [Map options]);
  
  /**
  * Stop watching the motion Acceleration.
  */
  abstract void clearWatch(var watchID);
}
