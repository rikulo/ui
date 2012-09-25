//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu Feb 16 15:10:39 TST 2012
// Author: tomyeh

/** A listener for handling [DataEvent].
 */
typedef void DataEventListener(DataEvent event);

/** A data event.
 */
interface DataEvent default _DataEvent {
  DataEvent(DataModel model, String type);

  /** Returns the type of this event.
   */
  String get type;
  /** Returns the data model of this event.
   */
  DataModel get model;
}

/** A list of [DataEvent] listeners.
 */
interface DataEventListenerList default _DataEventListenerList {
  /** Adds an event listener to this list.
   */
  DataEventListenerList add(DataEventListener handler);
  /** Removes an event listener from this list.
   */
  DataEventListenerList remove(DataEventListener handler);
  /** Dispatches the event to the listeners in this list.
   */
  bool dispatch(DataEvent event);
  /** Tests if any event listener is registered.
   */
  bool isEmpty();
}
/** A map of [DataEvent] listeners.
 * It is a skeletal interface for any object that handles events,
 * such as [View] and [Broadcaster].
 */
interface DataEventListenerMap default _DataEventListenerMap {
  /** Returns the list of [DataEvent] listeners for the given type.
   */
  DataEventListenerList operator [](String type);

  /** Tests if the given event type is listened.
   */
  bool isListened(String type);
}
/** A map of [DataEvent] listeners that [View] accepts.
 */
interface DataEvents extends DataEventListenerMap default _DataEvents {
  DataEvents(var ptr);

  /** Identifies listeners for all kind of data event type.
   * Listeners added here will be invoked no matter what [DataEvent] is received.
   */
  DataEventListenerList get all;
  /** Identifies the addition of one or more contiguous items to the model.
   *
   * The event is an instance of [ListDataEvent] or [TreeDataEvent], depending
   * on the model.
   */
  DataEventListenerList get add;
  /** Identifies the removal of one or more contiguous items from the model.
   *
   * The event is an instance of [ListDataEvent] or [TreeDataEvent], depending
   * on the model.
   */
  DataEventListenerList get remove;
  /** Identifies the structure of the lists has changed.
   *
   * The event is an instance of [DataEvent].
   */
  DataEventListenerList get structure;
  /** Identifies the selection of the lists has changed.
   *
   * It is applicable only if the model supports [Selection].
   * The event is an instance of [DataEvent].
   */
  DataEventListenerList get select;
  /** Identified the change of whether the model allows mutiple selection.
   *
   * It is applicable only if the model supports [Selection].
   * The event is an instance of [DataEvent].
   */
  DataEventListenerList get multiple;
  /** Identifies the list of disabled objects has changed.
   *
   * It is applicable only if the model supports [Disables].
   * The event is an instance of [DataEvent].
   */
  DataEventListenerList get disable;
  /** Identifies the change of the open statuses.
   *
   * It is applicable only if the model supports [Opens].
   * The event is an instance of [DataEvent].
   */
  DataEventListenerList get open;
}

/** An implementation of [DataEvent].
 */
class _DataEvent implements DataEvent {
  final String _type;
  final DataModel _model;

  _DataEvent(DataModel this._model, String this._type);

  /** Returns the type of this event.
   */
  String get type => _type;
  /** Returns the data model of this event.
   */
  DataModel get model => _model;

  String toString() => "$type()";
}

/** An implementation of [DataEventListenerList].
 */
class _DataEventListenerList implements DataEventListenerList {
  final _ptr;
  final String _type;

  _DataEventListenerList(this._ptr, this._type);

  DataEventListenerList add(DataEventListener handler) {
    _ptr.addEventListener(_type, handler);
    return this;
  }
  DataEventListenerList remove(DataEventListener handler) {
    _ptr.removeEventListener(_type, handler);
    return this;
  }
  bool dispatch(DataEvent event) {
    return _ptr.sendEvent(event, type: _type);
  }
  bool isEmpty() {
    return _ptr.isEventListened(_type);
  }
}
/** An implementation of [DataEventListenerMap].
 */
class _DataEventListenerMap implements DataEventListenerMap {
  //raw event target
  final _ptr;
  final Map<String, DataEventListenerList> _lnlist;

  _DataEventListenerMap(this._ptr): _lnlist = new Map() {
  }

  DataEventListenerList operator [](String type) => _get(type); 
  _DataEventListenerList _get(String type) {
    return _lnlist.putIfAbsent(type, () => new _DataEventListenerList(_ptr, type));
  }

  bool isListened(String type) {
    final p = _lnlist[type];
    return p == null || p.isEmpty();
  }
}

/** An implementation of [DataEvents].
 */
class _DataEvents extends _DataEventListenerMap implements DataEvents {
  _DataEvents(var ptr): super(ptr) {
  }

  DataEventListenerList get all => _get('all');
  DataEventListenerList get change => _get('change');
  DataEventListenerList get add => _get('add');
  DataEventListenerList get remove => _get('remove');
  DataEventListenerList get structure => _get('structure');
  DataEventListenerList get select => _get('select');
  DataEventListenerList get multiple => _get('multiple');
  DataEventListenerList get disable => _get('disable');
  DataEventListenerList get open => _get('open');
}
