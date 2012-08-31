//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 17, 2012
// Author: tomyeh

/** A list of [ViewEvent] listeners.
 */
interface ViewEventListenerList default _ViewEventListenerList {
  /** Adds an event listener to this list.
   */
  ViewEventListenerList add(ViewEventListener handler);
  /** Removes an event listener from this list.
   */
  ViewEventListenerList remove(ViewEventListener handler);
  /** Sends the event to the listeners in this list.
   */
  bool send(ViewEvent event);
  /** Tests if no event listener is registered.
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

  ViewEventListenerList get blur;
  ViewEventListenerList get change;
  ViewEventListenerList get click;
  ViewEventListenerList get drag;
  ViewEventListenerList get dragEnd;
  ViewEventListenerList get dragEnter;
  ViewEventListenerList get dragLeave;
  ViewEventListenerList get dragOver;
  ViewEventListenerList get dragStart;
  ViewEventListenerList get drop;
  ViewEventListenerList get focus;
  ViewEventListenerList get keyDown;
  ViewEventListenerList get keyPress;
  ViewEventListenerList get keyUp;
  ViewEventListenerList get mouseDown;
  ViewEventListenerList get mouseMove;
  ViewEventListenerList get mouseOut;
  ViewEventListenerList get mouseOver;
  ViewEventListenerList get mouseUp;
  ViewEventListenerList get mouseWheel;
  ViewEventListenerList get scroll;

  /** A list of event listeners for indicating
   * the selection state of a view is changed.
   *
   * The event is an instance of [SelectEvent].
   */
  ViewEventListenerList get select;
  /** A list of event listeners for indicating
   * a view has re-rendered itself because
   * its data model has been changed.
   * It is used with views that support the data model, such as
   * [DropDownList] and [RadioGroup].
   *
   * The event is an instance of [ViewEvent].
   *
   * Application usually listens to this event to invoke [View.requestLayout],
   * if the re-rending of a data model might change the layout.
   * For example, the height of [DropDownList] will be changed if
   * the multiple state is changed.
   */
  ViewEventListenerList get render;

  /** A list of event listeners for indicating a popup is about to be dismessed.
   * The event is sent to the popup being dismissed.
   *
   * The event is an instance of [ViewEvent].
   */
  ViewEventListenerList get dismiss;

  /** A list of event listeners for indicating
   * the layout of a view and all of its descendant views
   * have been changed.
   *
   * The event is an instance of [LayoutEvent].
   */
  ViewEventListenerList get layout;
  /** A list of event listeners for indicating
   * the layout of a view is going to be handled.
   * It is sent before handling this view and any of its descendant views.
   *
   * The event is an instance of [LayoutEvent].
   */
  ViewEventListenerList get preLayout;
  /** A list of event listeners for indicating
   * a view has been attached to a document.
   *
   * The event is an instance of [ViewEvent].
   */
  ViewEventListenerList get mount;
  /** A list of event listeners for indicating
   * a view has been detached from a document.
   *
   * The event is an instance of [ViewEvent].
   */
  ViewEventListenerList get unmount;
  
  /** A list of event listeners for indicating the start of a scrolling.
   * The event is an instance of [ScrollEvent].
   */
  ViewEventListenerList get scrollStart;
  
  /** A list of event listeners for indicating the move of a scrolling.
   * The event is an instance of [ScrollEvent]. This event will be continuously
   * fired at each iteration where the scroll position is updated.
   */
  ViewEventListenerList get scrollMove;
  
  /** A list of event listeners for indicating the end of a scrolling.
   * The event is an instance of [ScrollEvent].
   */
  ViewEventListenerList get scrollEnd;
  
}

/** An implementation of [ViewEventListenerList].
 */
class _ViewEventListenerList implements ViewEventListenerList {
  final _ptr;
  final String _type;

  _ViewEventListenerList(this._ptr, this._type);

  ViewEventListenerList add(ViewEventListener handler) {
    _ptr.add(_type, handler);
    return this;
  }
  ViewEventListenerList remove(ViewEventListener handler) {
    _ptr.remove(_type, handler);
    return this;
  }
  bool send(ViewEvent event) => _ptr.send(event, _type);
  bool isEmpty() => _ptr.isEmpty(_type);
}
/** An implementation of [ViewEventListenerMap].
 */
class _ViewEventListenerMap implements ViewEventListenerMap {
  final _ptr;
  final Map<String, ViewEventListenerList> _lnlist;

  _ViewEventListenerMap(this._ptr): _lnlist = {};

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

  ViewEventListenerList get blur => _get('blur');
  ViewEventListenerList get change => _get('change');
  ViewEventListenerList get click => _get('click');
  ViewEventListenerList get drag => _get('drag');
  ViewEventListenerList get dragEnd => _get('dragEnd');
  ViewEventListenerList get dragEnter => _get('dragEnter');
  ViewEventListenerList get dragLeave => _get('dragLeave');
  ViewEventListenerList get dragOver => _get('dragOver');
  ViewEventListenerList get dragStart => _get('dragStart');
  ViewEventListenerList get drop => _get('drop');
  ViewEventListenerList get focus => _get('focus');
  ViewEventListenerList get keyDown => _get('keyDown');
  ViewEventListenerList get keyPress => _get('keyPress');
  ViewEventListenerList get keyUp => _get('keyUp');
  ViewEventListenerList get mouseDown => _get('mouseDown');
  ViewEventListenerList get mouseMove => _get('mouseMove');
  ViewEventListenerList get mouseOut => _get('mouseOut');
  ViewEventListenerList get mouseOver => _get('mouseOver');
  ViewEventListenerList get mouseUp => _get('mouseUp');
  ViewEventListenerList get mouseWheel => _get('mouseWheel');
  ViewEventListenerList get scroll => _get('scroll');

  ViewEventListenerList get dismiss => _get("dismiss");

  ViewEventListenerList get layout => _get("layout");
  ViewEventListenerList get preLayout => _get("preLayout");
  ViewEventListenerList get mount => _get("mount");
  ViewEventListenerList get unmount => _get("unmount");

  ViewEventListenerList get check => _get("check");
  ViewEventListenerList get select => _get("select");
  ViewEventListenerList get render => _get("render");
  
  ViewEventListenerList get scrollStart => _get("scrollStart");
  ViewEventListenerList get scrollMove => _get("scrollMove");
  ViewEventListenerList get scrollEnd => _get("scrollEnd");
  
}
