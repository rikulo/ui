//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu Feb 16 15:10:39 TST 2012
// Author: tomyeh
part of rikulo_model;

/** A listener for handling [DataEvent].
 */
typedef void DataEventListener(DataEvent event);

/** A data event.
 */
class DataEvent {
  final DataModel _model;
  final String _type;

  DataEvent(DataModel model, String type): _model = model, _type = type;

  /** Returns the type of this event.
   */
  String get type => _type;
  /** Returns the data model of this event.
   */
  DataModel get model => _model;
  String toString() => "$type()";
}

/** A list of [DataEvent] listeners.
 */
class DataEventListenerList {
  final _ptr;
  final String _type;

  DataEventListenerList(this._ptr, this._type);

  /** Adds an event listener to this list.
   */
  DataEventListenerList add(DataEventListener handler) {
    _ptr.addEventListener(_type, handler);
    return this;
  }
  /** Removes an event listener from this list.
   */
  DataEventListenerList remove(DataEventListener handler) {
    _ptr.removeEventListener(_type, handler);
    return this;
  }
  /** Dispatches the event to the listeners in this list.
   */
  bool dispatch(DataEvent event) => _ptr.sendEvent(event, type: _type);
  /** Tests if any event listener is registered.
   */
  bool get isEmpty => _ptr.isEventListened(_type);
}
/** A map of [DataEvent] listeners.
 * It is a skeletal interface for any object that handles events,
 * such as [View] and [Broadcaster].
 */
class DataEventListenerMap {
  //raw event target
  final _ptr;
  final Map<String, DataEventListenerList> _lnlist = new Map();

  DataEventListenerMap(this._ptr);

  /** Returns the list of [DataEvent] listeners for the given type.
   */
  DataEventListenerList operator [](String type) => _get(type); 

  /** Tests if the given event type is listened.
   */
  bool isListened(String type) {
    final p = _lnlist[type];
    return p == null || p.isEmpty;
  }

  DataEventListenerList _get(String type) {
    return _lnlist.putIfAbsent(type, () => new DataEventListenerList(_ptr, type));
  }
}
/** A map of [DataEvent] listeners that [View] accepts.
 */
class DataEvents extends DataEventListenerMap {
  DataEvents(var ptr): super(ptr);

  /** Identifies listeners for all kind of data event type.
   * Listeners added here will be invoked no matter what [DataEvent] is received.
   */
  DataEventListenerList get all => _get('all');
  /** Identifies the addition of one or more contiguous items to the model.
   *
   * The event is an instance of [ListDataEvent] or [TreeDataEvent], depending
   * on the model.
   */
  DataEventListenerList get add => _get('add');
  /** Identifies the removal of one or more contiguous items from the model.
   *
   * The event is an instance of [ListDataEvent] or [TreeDataEvent], depending
   * on the model.
   */
  DataEventListenerList get remove => _get('remove');
  /** Identifies the structure of the lists has changed.
   *
   * The event is an instance of [DataEvent].
   */
  DataEventListenerList get structure => _get('structure');
  /** Identifies the selection of the lists has changed.
   *
   * It is applicable only if the model supports [Selection].
   * The event is an instance of [DataEvent].
   */
  DataEventListenerList get select => _get('select');
  /** Identified the change of whether the model allows mutiple selection.
   *
   * It is applicable only if the model supports [Selection].
   * The event is an instance of [DataEvent].
   */
  DataEventListenerList get multiple => _get('multiple');
  /** Identifies the list of disabled objects has changed.
   *
   * It is applicable only if the model supports [Disables].
   * The event is an instance of [DataEvent].
   */
  DataEventListenerList get disable => _get('disable');
  /** Identifies the change of the open statuses.
   *
   * It is applicable only if the model supports [Opens].
   * The event is an instance of [DataEvent].
   */
  DataEventListenerList get open => _get('open');
}
