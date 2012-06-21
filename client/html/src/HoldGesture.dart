//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 09, 2012 12:46:09 PM
// Author: tomyeh

/** The action for the touch-and-hold gesture.
 */
typedef HoldGestureCallback(HoldGesture gesture, int pageX, int pageY);

/**
 * A touch-and-hold gesture handler.
 */
interface HoldGesture default _HoldGesture {
  /** Constructor.
   *
   * + [start] is the callback before starting monitoring the touch-and-hold
   * gesture. If it returns false, the monitoring will be cancelled.
   * + [duration] is the duration that a user has to hold before calling the action.
   * Default: 1000 (unit: milliseconds)
   * + [movement] is the allowed movement to consider if a user is holding a touch.
   * Default: 3 (unit: pixels)
   */
  HoldGesture(Element owner, HoldGestureCallback action,
  [HoldGestureCallback start, int duration, int movement]);

  /** Destroys the handler.
   * It shall be called to clean up the handler, if it is no longer used.
   */
  void destroy();

  /** The element that owns this handler.
   */
  Element get owner();
  /** The element that the scrolling starts with, or null if the scrolling
   * is not taking place.
   */
  Element get touched();
}

abstract class _HoldGesture implements HoldGesture {
  final Element _owner;
  final int _duration;
  final int _movement;
  final HoldGestureCallback _start, _action;
  Element _touched;
  int _pageX, _pageY;
  int _timer;

  factory _HoldGesture(Element owner, HoldGestureCallback action,
  [HoldGestureCallback start, int duration, int movement]) {
    if (duration === null) duration = 1000;
    if (movement === null) movement = 3;
    return browser.touch ?
      new _TouchHoldGesture(owner, action, start, duration, movement):
      new _MouseHoldGesture(owner, action, start, duration, movement);
  }
  _HoldGesture._init(Element this._owner, HoldGestureCallback this._action,
  HoldGestureCallback this._start, int this._duration, int this._movement) {
    _listen();
  }

  void destroy() {
    _stop();
    _unlisten();
  }

  Element get owner() => _owner;
  Element get touched() => _touched;

  abstract void _listen();
  abstract void _unlisten();

  bool _touchStart(Element touched, int pageX, int pageY) {
    _stop();

    _touched = touched;
    if (_start !== null) {
      bool c = _start(this, pageX, pageY);
      if (c !== null && !c) {
        _touched = null; //not started
        return false; //don't start it
      }
    }

    _pageX = pageX;
    _pageY = pageY;
    _timer = window.setTimeout(_call, _duration);
    return true; //started
  }
  void _touchMove(int pageX, int pageY) {
    if (_touched !== null
    && (pageX - _pageX > _movement || pageY - _pageY > _movement))
      _stop();
  }
  void _touchEnd() {
    if (_touched !== null)
      _stop();
  }
  void _call() {
    _stop();
    _action(this, _pageX, _pageY);
  }
  void _stop() {
    if (_timer !== null) {
      window.clearTimeout(_timer);
      _timer = null;
    }
    _touched = null;
  }
}

/** The touch-and-hold handler for touch devices.
 */
class _TouchHoldGesture extends _HoldGesture {
  EventListener _elStart, _elMove, _elEnd;

  _TouchHoldGesture(Element owner, HoldGestureCallback action,
  HoldGestureCallback start, int duration, int movement)
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

  _MouseHoldGesture(Element owner, HoldGestureCallback action,
  HoldGestureCallback start, int duration, int movement)
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