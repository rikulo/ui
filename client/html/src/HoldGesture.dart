//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 09, 2012 12:46:09 PM
// Author: tomyeh

/** The callback before starting monitoring the touch-and-hold
 * gesture. If it returns false, the monitoring will be cancelled.
 */
typedef bool HoldGestureStart(HoldGestureState state);
/**
 * The callback when the touch-and-hold gesture is recognized and executed.
 */
typedef void HoldGestureAction(HoldGestureState state);

/** The state of [HoldGesture].
 */
interface HoldGestureState {
  HoldGesture get gesture();
  /** The element that the user touches at the beginning.
   */
  Element get touched();

  /** The touch point's offset relative to
   * the left-top corner of the owner element.
   */
  Offset get offset();
  /** The touch point's offset relative to the whole document.
   */
  Offset get documentOffset();

  /** Any data that the caller stores.
   */
  var data;
}

/**
 * A touch-and-hold gesture handler.
 */
interface HoldGesture default _HoldGesture {
  /** Constructor.
   *
   * + [start] is the callback before starting monitoring the touch-and-hold
   * gesture. If it returns false, the monitoring will be cancelled.
   * + [action] is the callback when the touch-and-hold gesture is executed.
   * + [duration] is the duration that a user has to hold before calling the action.
   * Default: 1000 (unit: milliseconds)
   * + [movement] is the allowed movement to consider if a user is holding a touch.
   * Default: 3 (unit: pixels)
   */
  HoldGesture(Element owner, HoldGestureAction action,
  [HoldGestureStart start, int duration, int movement]);

  /** Destroys the handler.
   * It shall be called to clean up the handler, if it is no longer used.
   */
  void destroy();

  /** The element that owns this handler.
   */
  Element get owner();
}

class _HoldGestureState implements HoldGestureState {
  final _HoldGesture _gesture;
  final Element _touched;
  Offset _ofs, _docOfs;
  int _timer;
  var data;

  _HoldGestureState(_HoldGesture this._gesture,
    Element this._touched, int pageX, int pageY) {
    _docOfs = new Offset(pageX, pageY);
    _ofs = _docOfs - new DOMQuery(gesture.owner).documentOffset;
  }

  HoldGesture get gesture() => _gesture;
  Element get touched() => _touched;
  Offset get offset() => _ofs;
  Offset get documentOffset() => _docOfs;
}

//abstract
class _HoldGesture implements HoldGesture {
  final Element _owner;
  final int _duration;
  final int _movement;
  final HoldGestureStart _start;
  final HoldGestureAction _action;
  _HoldGestureState _state;

  factory _HoldGesture(Element owner, HoldGestureAction action,
  [HoldGestureStart start, int duration=1000, int movement=3]) {
    return browser.touch ?
      new _TouchHoldGesture(owner, action, start, duration, movement):
      new _MouseHoldGesture(owner, action, start, duration, movement);
  }
  _HoldGesture._init(Element this._owner, HoldGestureAction this._action,
  HoldGestureStart this._start, int this._duration, int this._movement) {
    _listen();
  }

  void destroy() {
    _stop();
    _unlisten();
  }

  Element get owner() => _owner;

  abstract void _listen();
  abstract void _unlisten();

  bool _touchStart(Element touched, int pageX, int pageY) {
    _stop();

    _state = new _HoldGestureState(this, touched, pageX, pageY);
    if (_start !== null) {
      final bool c = _start(_state);
      if (c !== null && !c) {
        _stop();
        return false; //don't start it
      }
    }

    _state._timer = window.setTimeout(_call, _duration);
    return true; //started
  }
  void _touchMove(int pageX, int pageY) {
    if (_state !== null
    && (pageX - _state._docOfs.x > _movement
    ||  pageY - _state._docOfs.y > _movement))
      _stop();
  }
  void _touchEnd() {
    _stop();
  }
  void _call() {
    final HoldGestureState state = _state;
    _stop();
    _action(state);
  }
  void _stop() {
    if (_state !== null) {
      if (_state._timer !== null) {
        window.clearTimeout(_state._timer);
        _state._timer = null;
      }
      _state = null;
    }
  }
}

/** The touch-and-hold handler for touch devices.
 */
class _TouchHoldGesture extends _HoldGesture {
  EventListener _elStart, _elMove, _elEnd;

  _TouchHoldGesture(Element owner, HoldGestureAction action,
  HoldGestureStart start, int duration, int movement)
  : super._init(owner, action, start, duration, movement) {
  }

  void _listen() {
    final ElementEvents on = owner.on;
    on.touchStart.add(_elStart = (TouchEvent event) {
      if (event.touches.length > 1)
        _touchEnd(); //ignore multiple fingers
      else
        _touchStart(event.target, event.pageX, event.pageY);
    });
    on.touchMove.add(_elMove = (TouchEvent event) {
      _touchMove(event.pageX, event.pageY);
    });
    on.touchEnd.add(_elEnd = (event) {
      _touchEnd();
    });
  }
  void _unlisten() {
    final ElementEvents on = owner.on;
    if (_elStart !== null) on.touchStart.remove(_elStart);
    if (_elMove !== null) on.touchMove.remove(_elMove);
    if (_elEnd !== null) on.touchEnd.remove(_elEnd);
  }
}
/** The touch-and-hold handler for mouse-based devices.
 */
class _MouseHoldGesture extends _HoldGesture {
  EventListener _elStart, _elMove, _elEnd;

  _MouseHoldGesture(Element owner, HoldGestureAction action,
  HoldGestureStart start, int duration, int movement)
  : super._init(owner, action, start, duration, movement) {
  }

  void _listen() {
    final ElementEvents on = owner.on;
    on.mouseDown.add(_elStart = (MouseEvent event) {
      _touchStart(event.target, event.pageX, event.pageY);
    });
    on.mouseMove.add(_elMove = (MouseEvent event) {
      _touchMove(event.pageX, event.pageY);
    });
    on.mouseUp.add(_elEnd = (event) {
      _touchEnd();
    });
  }
  void _unlisten() {
    final ElementEvents on = owner.on;
    if (_elStart !== null) on.mouseDown.remove(_elStart);
    if (_elMove !== null) on.mouseMove.remove(_elMove);
    if (_elEnd !== null) on.mouseUp.remove(_elEnd);
  }
}