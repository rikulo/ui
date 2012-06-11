//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  09:17:04 AM
// Author: henrichen

abstract class AbstractGeolocation implements XGeolocation {
  PositionEvents _on;
  List<WatchIDInfo> _listeners;
  
  AbstractGeolocation() {
    _listeners = new List<WatchIDInfo>();
  }

  PositionEvents get on() {
    if (_on === null)
      _on = new PositionEvents(this);
    return _on;
  }

  void addEventListener(String type, PositionEventListener listener, [Map options]) {
    removeEventListener(type, listener);
    var watchID = watchPosition(wrapSuccessListener_(listener), wrapErrorListener_(listener), options);
    _listeners.add(new WatchIDInfo(listener, watchID));
  }
  
  void removeEventListener(String type, PositionEventListener listener) {
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
  
  /** Returns the wrapped GeolocationSuccessCallback from the given PositionEventListener */
  abstract GeolocationSuccessCallback wrapSuccessListener_(PositionEventListener listener);

  /** Returns the wrapped GeolocationErrorCallback from the given PositionEventListener */
  abstract GeolocationErrorCallback wrapErrorListener_(PositionEventListener listener);

  /**
  * Watches for position changes of this device.
  * The Position is returned via the onSuccess callback function.
  * @return a watchID that can be used to stop this watching later by #clearWatch() method.
  */  
  abstract watchPosition(GeolocationSuccessCallback onSuccess, [GeolocationErrorCallback onError, Map options]);
  
  /**
  * Stop watching the motion Position.
  */
  abstract void clearWatch(var watchID);
}
