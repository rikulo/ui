//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  09:19:11 AM
// Author: henrichen

/** Position events */
class PositionEvents extends DeviceEvents {
	PositionEvents(ptr) : super(ptr);
	PositionEventListenerList get position() 
		=> get_('position', new PositionEventListenerList(this.getEventTarget_(), 'position'));
}

/** PositionEvent listener list */
class PositionEventListenerList implements DeviceEventListenerList {
	DeviceEventListenerList _delegate;
	PositionEventListenerList(var ptr, var type) {
		_delegate = new DeviceEventListenerList(ptr, type);
	}

	PositionEventListenerList add(PositionEventListener listener, [GeolocationOptions options]) {
		print("PositionEventListenerList.add()");
		_delegate.add(listener, _toMap(options));
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
				"enableHighAccuracy" : true,
				"timeout" : 10000,
				"maximumAge" : 10000
			};
		} else {
			Map map = new Map();
			map["enableHighAccuracy"] = (opts.enableHighAccuracy === null ? true : opts.enableHighAccuracy);
			map["timeout"] = (opts.timeout === null ? 10000 : opts.timeout);
			map["maximumAge"] = (opts.maximumAge === null ? 10000 : opts.maximumAge);
			return map;
		}
	}
}

