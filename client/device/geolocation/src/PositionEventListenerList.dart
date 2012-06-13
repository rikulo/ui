//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  09:19:11 AM
// Author: henrichen

/** PositionEvent listener list */
class PositionEventListenerList {
  DeviceEventListenerList _delegate;
  PositionEventListenerList(XGeolocation ptr, String type) {
    _delegate = new DeviceEventListenerList(ptr, type);
  }

  PositionEventListenerList add(PositionEventListener listener, [PositionErrorEventListener errListener, GeolocationOptions options]) {
    _delegate.add(listener, errListener, _toMap(options));
    return this;
  }
  
  PositionEventListenerList remove(PositionEventListener listener) {
    _delegate.remove(listener);
    return this;
  }
  
  /** Tests if any listener is registered.
  */
  bool isEventListened() {
    return _delegate.isEventListened();
  }
  
  Map _toMap(GeolocationOptions opts) {
    if (opts === null) {
      return {
        "frequency" : 10000,
        "enableHighAccuracy" : true,
        "timeout" : 10000,
        "maximumAge" : 10000
      };
    } else {
      Map map = new Map();
      map["frequency"] = (opts.frequency === null ? 10000 : opts.frequency);
      map["enableHighAccuracy"] = (opts.enableHighAccuracy === null ? true : opts.enableHighAccuracy);
      map["timeout"] = (opts.timeout === null ? 10000 : opts.timeout);
      map["maximumAge"] = (opts.maximumAge === null ? 10000 : opts.maximumAge);
      return map;
    }
  }
}