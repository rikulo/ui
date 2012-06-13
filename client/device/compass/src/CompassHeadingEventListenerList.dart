//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  11:22:40 AM
// Author: henrichen

/** CompassHeadingEvent listener list */
class CompassHeadingEventListenerList /*implements DeviceEventListenerList*/ {
  DeviceEventListenerList _delegate;
  CompassHeadingEventListenerList(Compass ptr, String type) {
    _delegate = new DeviceEventListenerList(ptr, type);
  }

  CompassHeadingEventListenerList add(CompassHeadingEventListener listener, [CompassHeadingErrorEventListener errListener, CompassOptions options]) {
    _delegate.add(listener, errListener, _toMap(options));
    return this;
  }
  CompassHeadingEventListenerList remove(CompassHeadingEventListener listener) {
    _delegate.remove(listener);
    return this;
  }
  /** Tests if any listener is registered.
  */
  bool isEventListened() {
    return _delegate.isEventListened();
  }
  Map _toMap(CompassOptions opts) {
    return {"frequency" : opts === null || opts.frequency === null ? 100 : opts.frequency,
        "filter" : opts === null || opts.filter === null ? 10 : opts.filter};
  }
}