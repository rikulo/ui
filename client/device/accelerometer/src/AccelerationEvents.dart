//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  11:22:40 AM
// Author: henrichen, tomyeh

/** Acceleration events */
interface AccelerationEvents default _AccelerationEvents {
  AccelerationEvents._init(AbstractAccelerometer owner);

  /** Returns the list of [AccelerationEvent] listeners for the given type.
   */
  AccelerationEventListenerList operator [](String type);

  /** A list of event listeners for the accelerate event.
   */
  AccelerationEventListenerList get accelerate;

  /** Tests if the given event type is listened.
   */
  bool isListened(String type);
}
/** A list of [AccelerationEvent] listeners.
 */
interface AccelerationEventListenerList default _AccelerationEventListenerList {
  /** Adds an event listener to this list.
   */
  AccelerationEventListenerList add(AccelerationEventListener success,
  [AccelerationErrorEventListener error, AccelerometerOptions options]);
  /** Removes an event listener from this list.
   */
  AccelerationEventListenerList remove(AccelerationEventListener success);
  /** Tests if no event listener is registered.
   */
  bool isEmpty();
}

/** An implementation of [AccelerationEventListenerList].
 */
class _AccelerationEventListenerList implements AccelerationEventListenerList {
  final AbstractAccelerometer _owner;
  final String _type;
  final List<_WatchIDInfo> _listeners;

  _AccelerationEventListenerList(AbstractAccelerometer this._owner, String this._type):
  _listeners = new List<_WatchIDInfo>();

  AccelerationEventListenerList add(AccelerationEventListener success,
  [AccelerationErrorEventListener error, AccelerometerOptions options]) {
    final watchID = _owner.watchAcceleration_(
      _owner.wrapSuccessListener_(success), _owner.wrapErrorListener_(error),
      {"frequency" : options == null || options.frequency == null ? 3000 : options.frequency});
    _listeners.add(new _WatchIDInfo(success, watchID));
    return this;
  }
  AccelerationEventListenerList remove(AccelerationEventListener success) {
    for(int j = 0; j < _listeners.length; ++j) {
      if (_listeners[j].listener == success) {
        var watchID = _listeners[j].watchID;
        if (watchID != null) {
          _owner.clearWatch_(watchID);
        }
        break;
      }
    }
    return this;
  }
  bool isEmpty() => _listeners.isEmpty();
}
class _AccelerationEvents implements AccelerationEvents {
  final AbstractAccelerometer _owner;
  final Map<String, AccelerationEventListenerList> _lnlist;

  _AccelerationEvents._init(AbstractAccelerometer this._owner): _lnlist = {};

  AccelerationEventListenerList operator [](String type) => _get(type); 
  _AccelerationEventListenerList _get(String type) {
    return _lnlist.putIfAbsent(type, () => new _AccelerationEventListenerList(_owner, type));
  }
  bool isListened(String type) {
    final p = _lnlist[type];
    return p == null || p.isEmpty();
  }
  AccelerationEventListenerList get accelerate => _get("accelerate");
}
class _WatchIDInfo {
  final listener;
  final watchID;
  _WatchIDInfo(this.listener, this.watchID);
}
