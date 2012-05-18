//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  10:40:12 AM
// Author: henrichen

/** DeviceEvent target */
interface DeviceEventTarget {
	/** Register event listener into this event target.
	*/
	void addEventListener(String type, Function listener, [Map options]);

	/** Unregister event listener from this event target.
	*/
	void removeEventListener(String type, Function listener);

	/** Tests if any listener is registered in this event target.
	*/
	bool isEventListened(String type);
}

/** DeviceEvent listener list */
interface DeviceEventListenerList default _DeviceEventListenerList {
	/** Default constructor */
	DeviceEventListenerList(DeviceEventTarget ptr, String Type);
	
	/** Register event listener into this event listener list.
	*/
	DeviceEventListenerList add(Function listener, [Object options]);

	/** Unregister event listener from this event listener list.
	*/
	DeviceEventListenerList remove(Function listener);

	/** Tests if any listener is registered.
	*/
	bool isEventListened();
}

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
	DeviceEventListenerList get_(String type, DeviceEventListenerList listenerList) {
		print("DeviceEventListenerList._get(): type:"+type);
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
		return p !== null && !p.isEmpty();
	}
	
}

/** A generic implementation of [DeviceEventListenerList].
 */
class _DeviceEventListenerList implements DeviceEventListenerList {
	final DeviceEventTarget _ptr;
	final String _type;

	_DeviceEventListenerList(this._ptr, this._type);

	DeviceEventListenerList add(Function listener, [Map options]) {
		print("DeviceEventListenerList, add(): type"+_type);
		_ptr.addEventListener(_type, listener, options);
		return this;
	}
	DeviceEventListenerList remove(Function listener) {
		_ptr.removeEventListener(_type, listener);
		return this;
	}
	bool isEventListened() {
		return !_ptr.isEventListened(_type);
	}
}

/** Internal class for maintain the watchID */
class WatchIDInfo {
	final _listener;
	final _watchID;
	WatchIDInfo(this._listener, this._watchID);
}
