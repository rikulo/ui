//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  11:22:40 AM
// Author: henrichen

class AccelerometerOptions {
  /** interval in milliseconds to retrieve Accleration back */
  int frequency;
}

/** Acceleration events */
class AccelerationEvents extends DeviceEvents {
	AccelerationEvents(ptr) : super(ptr);
	AccelerationEventListenerList get accelerate() 
		=> _get('accelerate', new AccelerationEventListenerList(this._ptr, 'accelerate'));
}

/** AccelerationEvent listener list */
class AccelerationEventListenerList implements DeviceEventListenerList {
	DeviceEventListenerList _delegate;
	AccelerationEventListenerList(var ptr, var type) {
		_delegate = new DeviceEventListenerList(ptr, type);
	}

	AccelerationEventListenerList add(AccelerationEventListener listener, [AccelerometerOptions options]) {
		print("AccelerationEventListenerList.add()");
		_delegate.add(listener, _toMap(options));
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
	Map _toMap(AccelerometerOptions opts) {
		return {"frequency" : opts === null || opts.frequency === null ? 3000 : opts.frequency};
	}
}

