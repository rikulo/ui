//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 09, 2012 12:46:09 PM
// Author: tomyeh

/** The callback before starting monitoring the touch-and-hold
 * gesture. If it returns false, the monitoring will be cancelled.
 */
typedef bool HoldGestureStart(HoldGestureState state);

/** The callback when the touch-and-hold gesture is recognized and executed.
 */
typedef void HoldGestureAction(HoldGestureState state);

/** The state of [HoldGesture].
 */
interface HoldGestureState extends GestureState {
  
  /** The associated [HoldGesture]. */
  HoldGesture get gesture;
  
  /** The touch point's offset relative to the whole document.
   */
  Offset get position;
  
}

class _HoldGestureState implements HoldGestureState {
  
  final HoldGesture gesture;
  final EventTarget eventTarget;
  final int startTime;
  int _timer, _time;
  final Offset position;
  var data;
  
  _HoldGestureState(this.gesture, this.eventTarget, int time, this.position) : 
  _time = time, this.startTime = time;
  
  int get time => _time;
  
}

/**
 * A touch-and-hold gesture handler.
 */
interface HoldGesture extends Gesture default _HoldGesture {
  
  /** Constructor.
   *
   * + [start] is the callback before starting monitoring the touch-and-hold
   * gesture. If it returns false, the monitoring will be cancelled.
   * + [action] is the callback when the touch-and-hold gesture is executed.
   * + [duration] is the duration that a user has to hold before calling the action.
   * Default: 1000 (unit: milliseconds)
   * + [movementLimit] is the allowed movement to consider if a user is holding a touch.
   * Default: 3 (unit: pixels)
   */
  HoldGesture(Element owner, HoldGestureAction action,
  [HoldGestureStart start, int duration, num movementLimit]);
  
  /** The element that owns this handler.
   */
  Element get owner;
  
}

//abstract
class _HoldGesture implements HoldGesture {
  
  final Element owner;
  final int _duration;
  final int _movementLimit;
  final HoldGestureStart _start;
  final HoldGestureAction _action;
  _HoldGestureState _state;
  bool _disabled = false;

  factory _HoldGesture(Element owner, HoldGestureAction action,
  [HoldGestureStart start, int duration = 1000, num movementLimit = 3]) {
    return browser.touch ?
      new _TouchHoldGesture(owner, action, start, duration, movementLimit):
      new _MouseHoldGesture(owner, action, start, duration, movementLimit);
  }
  
  _HoldGesture._init(this.owner, this._action, this._start, this._duration, 
  this._movementLimit) {
    _listen();
  }
  
  void destroy() {
    _stop();
    _unlisten();
  }
  
  void stop() {
    _stop();
  }
  
  void disable() {
    _stop();
    _disabled = true;
  }
  
  void enable() {
    _disabled = false;
  }
  
  abstract void _listen();
  abstract void _unlisten();
  
  void _touchStart(EventTarget target, int time, Offset position) {
    if (_disabled)
      return;
    
    _stop();
    _state = new _HoldGestureState(this, target, time, position);
    
    if (_start != null && _start(_state) === false) {
      _stop();
      return;
    }
    
    _state._timer = window.setTimeout(_call, _duration);
  }
  void _touchMove(int time, Offset position) {
    if (_state != null && (position - _state.position).norm() > _movementLimit)
      _stop();
  }
  void _touchEnd() => _stop();
  
  void _call() {
    final _HoldGestureState state = _state;
    _stop();
    if (_action != null && state != null) {
      state._time = new Date.now().millisecondsSinceEpoch;
      _action(state);
    }
  }
  void _stop() {
    if (_state != null) {
      if (_state._timer != null) {
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
  HoldGestureStart start, int duration, num movementLimit) : 
  super._init(owner, action, start, duration, movementLimit);
  
  void _listen() {
    owner.on.touchStart.add(_elStart = (TouchEvent event) {
      if (event.touches.length > 1)
        _touchEnd(); //ignore multiple fingers
      else
        _touchStart(event.target, event.timeStamp, new Offset(event.pageX, event.pageY));
    });
    document.on.touchMove.add(_elMove = (TouchEvent event) {
      _touchMove(event.timeStamp, new Offset(event.pageX, event.pageY));
    });
    document.on.touchEnd.add(_elEnd = (event) {
      _touchEnd();
    });
  }
  void _unlisten() {
    final ElementEvents on = owner.on;
    if (_elStart != null) on.touchStart.remove(_elStart);
    if (_elMove != null) on.touchMove.remove(_elMove);
    if (_elEnd != null) on.touchEnd.remove(_elEnd);
  }
}
/** The touch-and-hold handler for mouse-based devices.
 */
class _MouseHoldGesture extends _HoldGesture {
  EventListener _elStart, _elMove, _elEnd;
  
  _MouseHoldGesture(Element owner, HoldGestureAction action,
  HoldGestureStart start, int duration, num movementLimit) : 
  super._init(owner, action, start, duration, movementLimit);
  
  void _listen() {
    owner.on.mouseDown.add(_elStart = (MouseEvent event) {
      _touchStart(event.target, event.timeStamp, new Offset(event.pageX, event.pageY));
    });
    document.on.mouseMove.add(_elMove = (MouseEvent event) {
      _touchMove(event.timeStamp, new Offset(event.pageX, event.pageY));
    });
    document.on.mouseUp.add(_elEnd = (event) {
      _touchEnd();
    });
  }
  void _unlisten() {
    final ElementEvents on = owner.on;
    if (_elStart != null) on.mouseDown.remove(_elStart);
    if (_elMove != null) on.mouseMove.remove(_elMove);
    if (_elEnd != null) on.mouseUp.remove(_elEnd);
  }
}