//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  06:03:45 PM
// Author: henrichen

abstract class AbstractCompass implements Compass {
  CompassHeadingEvents _on;
  List<WatchIDInfo> _listeners;
  
  AbstractCompass() {
    _listeners = new List<WatchIDInfo>();
  }

  CompassHeadingEvents get on() {
    if (_on === null)
      _on = new CompassHeadingEvents(this);
    return _on;
  }

  void addEventListener(String type, CompassHeadingEventListener listener, [Map options]) {
    removeEventListener(type, listener);
    var watchID = watchHeading(wrapSuccessListener_(listener), wrapErrorListener_(listener), options);
    _listeners.add(new WatchIDInfo(listener, watchID));
  }
  
  void removeEventListener(String type, CompassHeadingEventListener listener) {
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
  
  /** Returns the wrapped CompassSuccessCallback from the given CompassHeadingEventListener */
  abstract CompassSuccessCallback wrapSuccessListener_(CompassHeadingEventListener listener);

  /** Returns the wrapped CompassErrorCallback from the given CompassHeadingEventListener */
  abstract CompassErrorCallback wrapErrorListener_(CompassHeadingEventListener listener);

  /**
  * Returns the direction this device pointing in degree at a specified(optional) regular interval.
  * The CompassHeading is returned via the onSuccess callback function at a regular interval.
  * options = {"frequency" : 100}; //update every 0.1 second
  * @return a watchID that can be used to stop this watching later by #clearWatch() method.
  */  
  abstract watchHeading(CompassSuccessCallback onSuccess, CompassErrorCallback onError, [Map options]);
  
  /**
  * Stop watching the heading.
  */
  abstract void clearWatch(var watchID);
}
