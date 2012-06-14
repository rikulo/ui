//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 17, 2012

/** A list of [ViewEvent] listeners.
 */
interface ViewEventListenerList default _ViewEventListenerList {
  /** Adds an event listener to this list.
   */
  ViewEventListenerList add(ViewEventListener handler);
  /** Removes an event listener from this list.
   */
  ViewEventListenerList remove(ViewEventListener handler);
  /** Dispatches the event to the listeners in this list.
   */
  bool dispatch(ViewEvent event);
  /** Tests if any event listener is registered.
   */
  bool isEmpty();
}
/** A map of [ViewEvent] listeners.
 * It is a skeletal interface for any object that handles events,
 * such as [View] and [Broadcaster].
 */
interface ViewEventListenerMap default _ViewEventListenerMap {
  /** Returns the list of [ViewEvent] listeners for the given type.
   */
  ViewEventListenerList operator [](String type);

  /** Tests if the given event type is listened.
   */
  bool isListened(String type);
}
/** A map of [ViewEvent] listeners that [View] accepts.
 */
interface ViewEvents extends ViewEventListenerMap default _ViewEvents {
  ViewEvents(var ptr);

  ViewEventListenerList get blur();
  ViewEventListenerList get change();
  ViewEventListenerList get click();
  ViewEventListenerList get focus();
  ViewEventListenerList get keyDown();
  ViewEventListenerList get keyPress();
  ViewEventListenerList get keyUp();
  ViewEventListenerList get mouseDown();
  ViewEventListenerList get mouseMove();
  ViewEventListenerList get mouseOut();
  ViewEventListenerList get mouseOver();
  ViewEventListenerList get mouseUp();
  ViewEventListenerList get mouseWheel();
  ViewEventListenerList get scroll();

  /** Indicates the check state of a view is changed.
   *
   * The event is an instance of [CheckEvent].
   */
  ViewEventListenerList get check();
  /** Indicates the selection state of a view is changed.
   *
   * The event is an instance of [SelectEvent].
   */
  ViewEventListenerList get select();

  /** Indicates the layout of a view is changed.
   *
   * The event is an instance of [Event].
   */
  ViewEventListenerList get layout();
  /** Indicates a view has been attached to a document.
   *
   * The event is an instance of [Event].
   */
  ViewEventListenerList get enterDocument();
  /** Indicates a view has been detached from a document.
   *
   * The event is an instance of [Event].
   */
  ViewEventListenerList get exitDocument();
}

/** An implementation of [ViewEventListenerList].
 */
class _ViewEventListenerList implements ViewEventListenerList {
  final _ptr;
  final String _type;

  _ViewEventListenerList(this._ptr, this._type);

  ViewEventListenerList add(ViewEventListener handler) {
    _ptr.addEventListener(_type, handler);
    return this;
  }
  ViewEventListenerList remove(ViewEventListener handler) {
    _ptr.removeEventListener(_type, handler);
    return this;
  }
  bool dispatch(ViewEvent event) {
    return _ptr.sendEvent(event, type: _type);
  }
  bool isEmpty() {
    return _ptr.isEventListened(_type);
  }
}
/** An implementation of [ViewEventListenerMap].
 */
class _ViewEventListenerMap implements ViewEventListenerMap {
  //raw event target
  final _ptr;
  final Map<String, ViewEventListenerList> _lnlist;

  _ViewEventListenerMap(this._ptr): _lnlist = new Map() {
  }

  ViewEventListenerList operator [](String type) => _get(type); 
  _ViewEventListenerList _get(String type) {
    return _lnlist.putIfAbsent(type, () => new _ViewEventListenerList(_ptr, type));
  }

  bool isListened(String type) {
    final p = _lnlist[type];
    return p == null || p.isEmpty();
  }
}

/** An implementation of [ViewEvents].
 */
class _ViewEvents extends _ViewEventListenerMap implements ViewEvents {
  _ViewEvents(var ptr): super(ptr) {
  }

  ViewEventListenerList get blur() => _get('blur');
  ViewEventListenerList get change() => _get('change');
  ViewEventListenerList get click() => _get('click');
  ViewEventListenerList get focus() => _get('focus');
  ViewEventListenerList get keyDown() => _get('keyDown');
  ViewEventListenerList get keyPress() => _get('keyPress');
  ViewEventListenerList get keyUp() => _get('keyUp');
  ViewEventListenerList get mouseDown() => _get('mouseDown');
  ViewEventListenerList get mouseMove() => _get('mouseMove');
  ViewEventListenerList get mouseOut() => _get('mouseOut');
  ViewEventListenerList get mouseOver() => _get('mouseOver');
  ViewEventListenerList get mouseUp() => _get('mouseUp');
  ViewEventListenerList get mouseWheel() => _get('mouseWheel');
  ViewEventListenerList get scroll() => _get('scroll');

  ViewEventListenerList get layout() => _get("layout");
  ViewEventListenerList get enterDocument() => _get("enterDocument");
  ViewEventListenerList get exitDocument() => _get("exitDocument");

  ViewEventListenerList get check() => _get("check");
  ViewEventListenerList get select() => _get("select");
}
