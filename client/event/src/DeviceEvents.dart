//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  10:40:12 AM
// Author: henrichen

/** DeviceEvent target */
interface DeviceEventTarget {
  /** Register event listener into this event target.
   */
  void addEventListener(String type, Function listener, [Map options]);

  /** Dispatch event to registered event listener for this event target.
   * @return true if dispatched to any registered listener.
   */
  bool dispatchEvent(DeviceEvent event, [String type]);

  /** Unregister event listener from this event target.
   */
  void removeEventListener(String type, Function listener);

  /** Tests if any listener is registered in this event target.
   */
  bool isEventListened(String type);
}

/** DeviceEvent listener list */
interface DeviceEventListenerList {
  /** Register event listener into this event listener list.
   */
  DeviceEventListenerList add(Function listener, [Map options]);

  /** Unregister event listener from this event listener list.
   */
  DeviceEventListenerList remove(Function listener);

  /** Dispatch event to registered event listener.
   * @return true if dispatched to any registered listener.
   */
  bool dispatch(DeviceEvent event);
  
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
  DeviceEventListenerList _get(String type, DeviceEventListenerList listenerList) {
  print("DeviceEventListenerList._get(): type:"+type);
    _listeners[type] = listenerList;
	return listenerList;
  }

  /** Tests if the given event type is listened.
   */
  bool isListened(String type) {
    final p = _listeners[type];
    return p !== null && !p.isEmpty();
  }
}

/** Generic Error listener */
typedef void ErrorListener();

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
  bool dispatch(DeviceEvent event) {
    return _ptr.dispatchEvent(event, type: _type);
  }
  DeviceEventListenerList remove(Function listener) {
    _ptr.removeEventListener(_type, listener);
    return this;
  }
  bool isEventListened() {
    return !_ptr.isEventListened(_type);
  }
}

/* A generic implementation of DeviceEvent dispatcher */
class DeviceEventDispatcher {
	Map<String, List<Function>> _listeners;
	
	DeviceEventDispatcher() {
		_listeners = {};
	}
	
	void addEventListener(String type, Function listener) {
		List<Function> lst = _listeners[type];
		if (lst === null) {
			lst = [];
			_listeners[type] = lst;
		}
		lst.add(listener);
	}
	
	bool dispatchEvent(DeviceEvent event, [String type]) {
		List<Function> lst = _listeners[type];
		bool dispatched = false;
		if (lst !== null) {
			for(final Function listener in lst){
				dispatched = true;
				listener(event);
				if (event.propagationStopped)
					return true; //done
			}
		}
		return dispatched;
	}
	
	void removeEventListener(String type, Function listener) {
		final List<Function> lst = _listeners[type];
		if (lst !== null) {
			for(int j = 0; j < lst.length; ++j) {
				if (lst[j] == listener) {
					lst.removeRange(j, 1);
					break;
				}
			}
		}
	}
	
	bool isEventListened(String type) {
		final List<Function> lst = _listeners[type];
		return lst != null && !lst.isEmpty();
	}
}
