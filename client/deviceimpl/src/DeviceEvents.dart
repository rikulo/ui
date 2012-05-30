//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  10:40:12 AM
// Author: henrichen

/**
 * Device events associated with a specific device.
 */
class DeviceEvents {
	//Device event target
	final _ptr;
	Map<String, DeviceEventListenerList> _listeners;

	DeviceEvents(this._ptr) {
		_listeners = {};
	}
	get_(String type, var listenerList) {
		_listeners[type] = listenerList;
		return listenerList;
	}
	DeviceEventTarget getEventTarget_() {
	  return _ptr;
	}

	/** Tests if the given event type is listened.
	*/
	bool isListened(String type) {
		final p = _listeners[type];
		return p !== null && p.isEventListened();
	}
	
}
