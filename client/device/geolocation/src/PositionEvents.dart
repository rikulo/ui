//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  09:19:11 AM
// Author: henrichen, tomyeh

/** Position events */
interface PositionEvents default _PositionEvents {
  PositionEvents._init(AbstractGeolocation owner);

  /** Returns the list of [PositionEvent] listeners for the given type.
   */
  PositionEventListenerList operator [](String type);

  /** A list of event listeners for the position event.
   */
  PositionEventListenerList get position;

  /** Tests if the given event type is listened.
   */
  bool isListened(String type);
}
/** A list of [PositionEvent] listeners.
 */
interface PositionEventListenerList default _PositionEventListenerList {
  /** Adds an event listener to this list.
   */
  PositionEventListenerList add(PositionEventListener success,
  [PositionErrorEventListener error, GeolocationOptions options]);
  /** Removes an event listener from this list.
   */
  PositionEventListenerList remove(PositionEventListener success);
  /** Tests if no event listener is registered.
   */
  bool isEmpty();
}

/** An implementation of [PositionEventListenerList].
 */
class _PositionEventListenerList implements PositionEventListenerList {
  final AbstractGeolocation _owner;
  final String _type;
  final List<_WatchIDInfo> _listeners;

  _PositionEventListenerList(AbstractGeolocation this._owner, String this._type):
  _listeners = new List<_WatchIDInfo>();

  PositionEventListenerList add(PositionEventListener success,
  [PositionErrorEventListener error, GeolocationOptions options]) {
    final watchID = _owner.watchPosition_(
      _owner.wrapSuccessListener_(success), _owner.wrapErrorListener_(error),
        options == null ? {
          "frequency" : 10000,
          "enableHighAccuracy" : true,
          "timeout" : 10000,
          "maximumAge" : 10000
        }: {
          "frequency":
            options.frequency == null ? 10000 : options.frequency,
          "enableHighAccuracy":
            options.enableHighAccuracy == null ? true : options.enableHighAccuracy,
          "timeout":
            options.timeout == null ? 10000 : options.timeout,
          "maximumAge":
            options.maximumAge == null ? 10000 : options.maximumAge
        });
    _listeners.add(new _WatchIDInfo(success, watchID));
    return this;
  }
  PositionEventListenerList remove(PositionEventListener success) {
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
class _PositionEvents implements PositionEvents {
  final AbstractGeolocation _owner;
  final Map<String, PositionEventListenerList> _lnlist;

  _PositionEvents._init(AbstractGeolocation this._owner): _lnlist = {};

  PositionEventListenerList operator [](String type) => _get(type); 
  _PositionEventListenerList _get(String type) {
    return _lnlist.putIfAbsent(type, () => new _PositionEventListenerList(_owner, type));
  }
  bool isListened(String type) {
    final p = _lnlist[type];
    return p == null || p.isEmpty();
  }
  PositionEventListenerList get position => _get("position");
}
class _WatchIDInfo {
  final listener;
  final watchID;
  _WatchIDInfo(this.listener, this.watchID);
}
