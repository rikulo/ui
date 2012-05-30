//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  10:48:26 AM
// Author: henrichen

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

/** A generic implementation of [DeviceEventListenerList].
 */
class _DeviceEventListenerList implements DeviceEventListenerList {
  final DeviceEventTarget _ptr;
  final String _type;

  _DeviceEventListenerList(this._ptr, this._type);

  DeviceEventListenerList add(Function listener, [Map options]) {
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
