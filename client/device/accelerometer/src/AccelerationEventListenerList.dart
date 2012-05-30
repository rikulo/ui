//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  11:22:40 AM
// Author: henrichen

/** AcclerationEvent listener function */
typedef void AccelerationEventListener(AccelerationEvent event);

/** AccelerationEvent listener list */
class AccelerationEventListenerList {
  DeviceEventListenerList _delegate;
  AccelerationEventListenerList(Accelerometer ptr, String type) {
    _delegate = new DeviceEventListenerList(ptr, type);
  }

  AccelerationEventListenerList add(AccelerationEventListener listener, [AccelerometerOptions options]) {
    _delegate.add(listener, _toMap(options));
    return this;
  }
  AccelerationEventListenerList remove(AccelerationEventListener listener) {
    _delegate.remove(listener);
    return this;
  }
  /** Tests if any listener is registered.
  */
  bool isEventListened() {
    return _delegate.isEventListened();
  }
  Map _toMap(AccelerometerOptions opts) {
    return {"frequency" : opts === null || opts.frequency === null ? 3000 : opts.frequency};
  }
}
