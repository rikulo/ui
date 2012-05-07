//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  11:22:40 AM
// Author: henrichen

/** AcclerationEvent */
class AccelerationEvent extends DeviceEvent {
	final double x;
	final double y;
	final double z;
	final int timestamp;
	AccelerationEvent(DeviceEventTarget target, this.x, this.y, this.z, this.timestamp) : super(target, "accelerate");
}

/** AcclerationEvent listener function */
typedef void AccelerationEventListener(AccelerationEvent event);

/** AccelerationEvent listener list */
class AccelerationEventListenerList implements DeviceEventListenerList {
  _DeviceEventListenerList _delegate;
  AccelerationEventListenerList(var ptr, var type) {
	_delegate = new _DeviceEventListenerList(ptr, type);
  }
  
  AccelerationEventListenerList add(AccelerationEventListener listener, [Map options]) {
  print("AccelerationEventListenerList.add()");
    _delegate.add(listener, options);
    return this;
  }
  bool dispatch(DeviceEvent event) {
    return _delegate.dispatch(event);
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
}
  
/** Acceleration events */
class AccelerationEvents extends DeviceEvents {
	AccelerationEvents(ptr) : super(ptr);
	AccelerationEventListenerList get accelerate() 
		=> _get('accelerate', new AccelerationEventListenerList(this._ptr, 'accelerate'));
}
