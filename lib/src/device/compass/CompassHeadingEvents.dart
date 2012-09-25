//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  11:22:40 AM
// Author: henrichen, tomyeh

/** Compass heading events */
interface CompassHeadingEvents default _CompassHeadingEvents {
  CompassHeadingEvents._init(AbstractCompass owner);

  /** Returns the list of [CompassHeadingEvent] listeners for the given type.
   */
  CompassHeadingEventListenerList operator [](String type);

  /** A list of event listeners for the heading event.
   */
  CompassHeadingEventListenerList get heading;

  /** Tests if the given event type is listened.
   */
  bool isListened(String type);
}
/** A list of [CompassHeadingEvent] listeners.
 */
interface CompassHeadingEventListenerList default _CompassHeadingEventListenerList {
  /** Adds an event listener to this list.
   */
  CompassHeadingEventListenerList add(CompassHeadingEventListener success,
  [CompassHeadingErrorEventListener error, CompassOptions options]);
  /** Removes an event listener from this list.
   */
  CompassHeadingEventListenerList remove(CompassHeadingEventListener success);
  /** Tests if no event listener is registered.
   */
  bool isEmpty();
}

/** An implementation of [CompassHeadingEventListenerList].
 */
class _CompassHeadingEventListenerList implements CompassHeadingEventListenerList {
  final AbstractCompass _owner;
  final String _type;
  final List<_WatchIDInfo> _listeners;

  _CompassHeadingEventListenerList(AbstractCompass this._owner, String this._type):
  _listeners = new List<_WatchIDInfo>();

  CompassHeadingEventListenerList add(CompassHeadingEventListener success,
  [CompassHeadingErrorEventListener error, CompassOptions options]) {
    final watchID = _owner.watchHeading_(
      _owner.wrapSuccessListener_(success), _owner.wrapErrorListener_(error),
      {"frequency" : options == null || options.frequency == null ? 100 : options.frequency,
       "filter" : options == null || options.filter == null ? 10 : options.filter});
    _listeners.add(new _WatchIDInfo(success, watchID));
    return this;
  }
  CompassHeadingEventListenerList remove(CompassHeadingEventListener success) {
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
class _CompassHeadingEvents implements CompassHeadingEvents {
  final AbstractCompass _owner;
  final Map<String, CompassHeadingEventListenerList> _lnlist;

  _CompassHeadingEvents._init(AbstractCompass this._owner): _lnlist = {};

  CompassHeadingEventListenerList operator [](String type) => _get(type); 
  _CompassHeadingEventListenerList _get(String type) {
    return _lnlist.putIfAbsent(type, () => new _CompassHeadingEventListenerList(_owner, type));
  }
  bool isListened(String type) {
    final p = _lnlist[type];
    return p == null || p.isEmpty();
  }
  CompassHeadingEventListenerList get heading => _get("heading");
}
class _WatchIDInfo {
  final listener;
  final watchID;
  _WatchIDInfo(this.listener, this.watchID);
}
