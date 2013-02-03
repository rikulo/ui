//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 17, 2012
// Author: tomyeh
part of rikulo_event;

//View Event Streams//
const ViewEventStreamProvider<ActivateEvent> activateEvent = const ViewEventStreamProvider<ActivateEvent>('activate');
const ViewEventStreamProvider<ViewEvent> dismissEvent = const ViewEventStreamProvider<ViewEvent>('dismiss');
const ViewEventStreamProvider<LayoutEvent> layoutEvent = const ViewEventStreamProvider<LayoutEvent>('layout');
const ViewEventStreamProvider<ViewEvent> mountEvent = const ViewEventStreamProvider<ViewEvent>('mount');
const ViewEventStreamProvider<LayoutEvent> preLayoutEvent = const ViewEventStreamProvider<LayoutEvent>('preLayout');
const ViewEventStreamProvider<ViewEvent> renderEvent = const ViewEventStreamProvider<ViewEvent>('render');
const ViewEventStreamProvider<ScrollEvent> scrollEndEvent = const ViewEventStreamProvider<ScrollEvent>('scrollEnd');
const ViewEventStreamProvider<ScrollEvent> scrollMoveEvent = const ViewEventStreamProvider<ScrollEvent>('scrollMove');
const ViewEventStreamProvider<ScrollEvent> scrollStartEvent = const ViewEventStreamProvider<ScrollEvent>('scrollStart');
const ViewEventStreamProvider<SelectEvent> selectEvent = const ViewEventStreamProvider<SelectEvent>('select');
const ViewEventStreamProvider<ViewEvent> unmountEvent = const ViewEventStreamProvider<ViewEvent>('unmount');

//DOM Event Proxy Streams//
const ViewEventStreamProvider<DomEvent> abortEvent = const ViewEventStreamProvider<DomEvent>('abort');
const ViewEventStreamProvider<DomEvent> beforeCopyEvent = const ViewEventStreamProvider<DomEvent>('beforecopy');
const ViewEventStreamProvider<DomEvent> beforeCutEvent = const ViewEventStreamProvider<DomEvent>('beforecut');
const ViewEventStreamProvider<DomEvent> beforePasteEvent = const ViewEventStreamProvider<DomEvent>('beforepaste');
const ViewEventStreamProvider<DomEvent> blurEvent = const ViewEventStreamProvider<DomEvent>('blur');
const ViewEventStreamProvider<ChangeEvent> changeEvent = const ViewEventStreamProvider<ChangeEvent>('change');
const ViewEventStreamProvider<DomEvent> clickEvent = const ViewEventStreamProvider<DomEvent>('click');
const ViewEventStreamProvider<DomEvent> contextMenuEvent = const ViewEventStreamProvider<DomEvent>('contextmenu');
const ViewEventStreamProvider<DomEvent> copyEvent = const ViewEventStreamProvider<DomEvent>('copy');
const ViewEventStreamProvider<DomEvent> cutEvent = const ViewEventStreamProvider<DomEvent>('cut');
const ViewEventStreamProvider<DomEvent> doubleClickEvent = const ViewEventStreamProvider<DomEvent>('dblclick');
const ViewEventStreamProvider<DomEvent> dragEvent = const ViewEventStreamProvider<DomEvent>('drag');
const ViewEventStreamProvider<DomEvent> dragEndEvent = const ViewEventStreamProvider<DomEvent>('dragend');
const ViewEventStreamProvider<DomEvent> dragEnterEvent = const ViewEventStreamProvider<DomEvent>('dragenter');
const ViewEventStreamProvider<DomEvent> dragLeaveEvent = const ViewEventStreamProvider<DomEvent>('dragleave');
const ViewEventStreamProvider<DomEvent> dragOverEvent = const ViewEventStreamProvider<DomEvent>('dragover');
const ViewEventStreamProvider<DomEvent> dragStartEvent = const ViewEventStreamProvider<DomEvent>('dragstart');
const ViewEventStreamProvider<DomEvent> dropEvent = const ViewEventStreamProvider<DomEvent>('drop');
const ViewEventStreamProvider<DomEvent> errorEvent = const ViewEventStreamProvider<DomEvent>('error');
const ViewEventStreamProvider<DomEvent> focusEvent = const ViewEventStreamProvider<DomEvent>('focus');
const ViewEventStreamProvider<DomEvent> inputEvent = const ViewEventStreamProvider<DomEvent>('input');
const ViewEventStreamProvider<DomEvent> invalidEvent = const ViewEventStreamProvider<DomEvent>('invalid');
const ViewEventStreamProvider<DomEvent> keyDownEvent = const ViewEventStreamProvider<DomEvent>('keydown');
const ViewEventStreamProvider<DomEvent> keyPressEvent = const ViewEventStreamProvider<DomEvent>('keypress');
const ViewEventStreamProvider<DomEvent> keyUpEvent = const ViewEventStreamProvider<DomEvent>('keyup');
const ViewEventStreamProvider<DomEvent> loadEvent = const ViewEventStreamProvider<DomEvent>('load');
const ViewEventStreamProvider<DomEvent> mouseDownEvent = const ViewEventStreamProvider<DomEvent>('mousedown');
const ViewEventStreamProvider<DomEvent> mouseMoveEvent = const ViewEventStreamProvider<DomEvent>('mousemove');
const ViewEventStreamProvider<DomEvent> mouseOutEvent = const ViewEventStreamProvider<DomEvent>('mouseout');
const ViewEventStreamProvider<DomEvent> mouseOverEvent = const ViewEventStreamProvider<DomEvent>('mouseover');
const ViewEventStreamProvider<DomEvent> mouseUpEvent = const ViewEventStreamProvider<DomEvent>('mouseup');
const ViewEventStreamProvider<DomEvent> mouseWheelEvent = const ViewEventStreamProvider<DomEvent>('mousewheel');
const ViewEventStreamProvider<DomEvent> pasteEvent = const ViewEventStreamProvider<DomEvent>('paste');
const ViewEventStreamProvider<DomEvent> resetEvent = const ViewEventStreamProvider<DomEvent>('reset');
const ViewEventStreamProvider<DomEvent> scrollEvent = const ViewEventStreamProvider<DomEvent>('scroll');
const ViewEventStreamProvider<DomEvent> searchEvent = const ViewEventStreamProvider<DomEvent>('search');
//const ViewEventStreamProvider<DomEvent> selectEvent = const ViewEventStreamProvider<DomEvent>('select');
const ViewEventStreamProvider<DomEvent> selectStartEvent = const ViewEventStreamProvider<DomEvent>('selectstart');
const ViewEventStreamProvider<DomEvent> submitEvent = const ViewEventStreamProvider<DomEvent>('submit');
const ViewEventStreamProvider<DomEvent> touchCancelEvent = const ViewEventStreamProvider<DomEvent>('touchcancel');
const ViewEventStreamProvider<DomEvent> touchEndEvent = const ViewEventStreamProvider<DomEvent>('touchend');
const ViewEventStreamProvider<DomEvent> touchEnterEvent = const ViewEventStreamProvider<DomEvent>('touchenter');
const ViewEventStreamProvider<DomEvent> touchLeaveEvent = const ViewEventStreamProvider<DomEvent>('touchleave');
const ViewEventStreamProvider<DomEvent> touchMoveEvent = const ViewEventStreamProvider<DomEvent>('touchmove');
const ViewEventStreamProvider<DomEvent> touchStartEvent = const ViewEventStreamProvider<DomEvent>('touchstart');
const ViewEventStreamProvider<DomEvent> transitionEndEvent = const ViewEventStreamProvider<DomEvent>('webkitTransitionEnd');
const ViewEventStreamProvider<DomEvent> fullscreenChangeEvent = const ViewEventStreamProvider<DomEvent>('webkitfullscreenchange');
const ViewEventStreamProvider<DomEvent> fullscreenErrorEvent = const ViewEventStreamProvider<DomEvent>('webkitfullscreenerror');

/**
 * A factory to expose [View]'s events as Streams.
 */
class ViewEventStreamProvider<T extends ViewEvent> {
  final String _eventType;

  const ViewEventStreamProvider(this._eventType);

  /**
   * Gets a [Stream] for this event type, on the specified target.
   *
   * * [useCapture] is applicable only if the view event is caused by a DOM event.
   */
  Stream<T> forTarget(View target, {bool useCapture: false}) {
    return new _EventStream(target, _eventType, useCapture);
  }
}

class _EventStream<T extends ViewEvent> extends Stream<T> {
  final View _target;
  final String _eventType;
  final bool _useCapture;

  _EventStream(this._target, this._eventType, this._useCapture);

  // events are inherently multi-subscribers.
  Stream<T> asMultiSubscriberStream() => this;

  StreamSubscription<T> listen(void onData(T event),
      { void onError(AsyncError error),
      void onDone(),
      bool unsubscribeOnError}) {

    return new _EventStreamSubscription<T>(
        this._target, this._eventType, onData, this._useCapture);
  }
}

class _EventStreamSubscription<T extends ViewEvent> extends StreamSubscription<T> {
  int _pauseCount = 0;
  View _target;
  final String _eventType;
  var _onData;
  final bool _useCapture;

  _EventStreamSubscription(this._target, this._eventType, this._onData,
      this._useCapture) {
    _tryResume();
  }

  void cancel() {
    if (_canceled) {
      throw new StateError("Subscription has been canceled.");
    }

    _unlisten();
    // Clear out the target to indicate this is complete.
    _target = null;
    _onData = null;
  }

  bool get _canceled => _target == null;

  void onData(void handleData(T event)) {
    if (_canceled) {
      throw new StateError("Subscription has been canceled.");
    }
    // Remove current event listener.
    _unlisten();

    _onData = handleData;
    _tryResume();
  }

  /// Has no effect.
  void onError(void handleError(AsyncError error)) {}

  /// Has no effect.
  void onDone(void handleDone()) {}

  void pause([Future resumeSignal]) {
    if (_canceled) {
      throw new StateError("Subscription has been canceled.");
    }
    ++_pauseCount;
    _unlisten();

    if (resumeSignal != null) {
      resumeSignal.whenComplete(resume);
    }
  }

  bool get _paused => _pauseCount > 0;

  void resume() {
    if (_canceled) {
      throw new StateError("Subscription has been canceled.");
    }
    if (!_paused) {
      throw new StateError("Subscription is not paused.");
    }
    --_pauseCount;
    _tryResume();
  }

  void _tryResume() {
    if (_onData != null && !_paused) {
      _target.on[_eventType].add(_onData, useCapture: _useCapture);
    }
  }

  void _unlisten() {
    if (_onData != null) {
      _target.on[_eventType].remove(_onData, useCapture: _useCapture);
    }
  }
}

/** A list of [ViewEvent] listeners.
 */
class ViewEventListenerList {
  final _ptr;
  final String _type;

  ViewEventListenerList(this._ptr, this._type);

  /** Adds an event listener to this list.
   *
   * * [useCapture] is applicable only if the view event is caused by a DOM event.
   */
  ViewEventListenerList add(ViewEventListener handler, {bool useCapture: false}) {
    _ptr.add(_type, handler, useCapture);
    return this;
  }
  /** Removes an event listener from this list.
   *
   * * [useCapture] is applicable only if the view event is caused by a DOM event.
   */
  ViewEventListenerList remove(ViewEventListener handler, {bool useCapture: false}) {
    _ptr.remove(_type, handler, useCapture);
    return this;
  }
  /** Sends the event to the listeners in this list.
   */
  bool send(ViewEvent event) => _ptr.send(event, _type);
  /** Tests if no event listener is registered.
   */
  bool get isEmpty => _ptr.isEmpty(_type);
}
/** A map of [ViewEvent] listeners.
 */
class ViewEventListenerMap {
  final _ptr;
  final Map<String, ViewEventListenerList> _lnlist;

  ViewEventListenerMap(this._ptr): _lnlist = new Map();
  /** Returns the list of [ViewEvent] listeners for the given type.
   */
  ViewEventListenerList operator [](String type) => _get(type); 
  /** Tests if the given event type is listened.
   */
  bool isListened(String type) {
    final p = _lnlist[type];
    return p == null || p.isEmpty;
  }

  ViewEventListenerList _get(String type) {
    return _lnlist.putIfAbsent(type, () => new ViewEventListenerList(_ptr, type));
  }
}
/** A map of [ViewEvent] listeners that [View] accepts.
 */
class ViewEvents extends ViewEventListenerMap {
  ViewEvents(var ptr): super(ptr);

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

  /** Listeners for the activate event ([ActivateEvent]).
   */
  ViewEventListenerList get activate => _get("activate");
  /** A list of event listeners for indicating
   * the selection state of a view is changed.
   *
   * The event is an instance of [SelectEvent].
   */
  ViewEventListenerList get select => _get("select");
  /** A list of event listeners for indicating
   * a view has re-rendered itself because
   * its data model has been changed.
   * It is used with views that support the data model, such as
   * [DropDownList].
   *
   * The event is an instance of [ViewEvent].
   *
   * Application usually listens to this event to invoke [View.requestLayout],
   * if the re-rending of a data model might change the layout.
   * For example, the height of [DropDownList] will be changed if
   * the multiple state is changed.
   */
  ViewEventListenerList get render => _get("render");

  /** A list of event listeners for indicating a popup is about to be dismessed.
   * The event is sent to the popup being dismissed.
   *
   * The event is an instance of [ViewEvent].
   */
  ViewEventListenerList get dismiss => _get("dismiss");

  /** A list of event listeners for indicating
   * the layout of a view and all of its descendant views
   * have been changed.
   *
   * The event is an instance of [LayoutEvent].
   */
  ViewEventListenerList get layout => _get("layout");
  /** A list of event listeners for indicating
   * the layout of a view is going to be handled.
   * It is sent before handling this view and any of its descendant views.
   *
   * The event is an instance of [LayoutEvent].
   */
  ViewEventListenerList get preLayout => _get("preLayout");
  /** A list of event listeners for indicating
   * a view has been attached to a document.
   *
   * The event is an instance of [ViewEvent].
   */
  ViewEventListenerList get mount => _get("mount");
  /** A list of event listeners for indicating
   * a view has been detached from a document.
   *
   * The event is an instance of [ViewEvent].
   */
  ViewEventListenerList get unmount => _get("unmount");

  /** A list of event listeners for indicating the start of a scrolling.
   * The event is an instance of [ScrollEvent].
   */
  ViewEventListenerList get scrollStart => _get("scrollStart");
  /** A list of event listeners for indicating the move of a scrolling.
   * The event is an instance of [ScrollEvent]. This event will be continuously
   * fired at each iteration where the scroll position is updated.
   */
  ViewEventListenerList get scrollMove => _get("scrollMove");
  /** A list of event listeners for indicating the end of a scrolling.
   * The event is an instance of [ScrollEvent].
   */
  ViewEventListenerList get scrollEnd => _get("scrollEnd");
}
