//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 09, 2012 12:46:09 PM
// Author: tomyeh
part of rikulo_gesture;

/** The callback before starting monitoring the touch-and-hold
 * gesture. If it returns false, the monitoring will be cancelled.
 */
typedef bool HoldGestureStart(HoldGestureState state);

/** The callback when the touch-and-hold gesture is recognized and executed.
 */
typedef void HoldGestureAction(HoldGestureState state);

/** The state of [HoldGesture].
 */
class HoldGestureState extends GestureState {
  final int startTime;
  Timer _timer;
  int _time;
  
  HoldGestureState._(this.gesture, this.eventTarget, int time, this.position) : 
  _time = time, this.startTime = time;

  @override
  final EventTarget eventTarget;
  @override
  int get time => _time;

  /** The associated [HoldGesture]. */
  final HoldGesture gesture;
  
  /** The touch point's offset relative to the whole document.
   */
  final Point position;
}

/**
 * A touch-and-hold gesture handler.
 */
abstract class HoldGesture extends Gesture {
  final int _duration;
  final int _movementLimit;
  final HoldGestureStart _start;
  final HoldGestureAction _action;
  HoldGestureState _state;
  bool _disabled = false;
  
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
  factory HoldGesture(Element owner, HoldGestureAction action,
  {HoldGestureStart start, int duration: 1000, num movementLimit: 3}) {
    return browser.touch ?
      new _TouchHoldGesture(owner, action, start, duration, movementLimit):
      new _MouseHoldGesture(owner, action, start, duration, movementLimit);
  }
  
  HoldGesture._init(this.owner, this._action, this._start, this._duration, 
  this._movementLimit) {
    _listen();
  }
  
  /** The element that owns this handler.
   */
  final Element owner;

  @override  
  void destroy() {
    _stop();
    _unlisten();
  }
  @override  
  void stop() {
    _stop();
  }
  @override  
  void disable() {
    _stop();
    _disabled = true;
  }
  @override  
  void enable() {
    _disabled = false;
  }
  
  void _listen();
  void _unlisten();
  
  void _touchStart(EventTarget target, int time, Point position) {
    if (_disabled)
      return;
    
    _stop();
    _state = new HoldGestureState._(this, target, time, position);
    
    if (_start != null && identical(_start(_state), false)) {
      _stop();
      return;
    }
    
    _state._timer = new Timer(new Duration(milliseconds: _duration), _call);
  }
  void _touchMove(int time, Point position) {
    if (_state != null && Points.norm(position - _state.position) > _movementLimit)
      _stop();
  }
  void _touchEnd() => _stop();
  
  void _call() {
    final HoldGestureState state = _state;
    _stop();
    if (_action != null && state != null) {
      state._time = new DateTime.now().millisecondsSinceEpoch;
      _action(state);
    }
  }
  void _stop() {
    if (_state != null) {
      if (_state._timer != null) {
        _state._timer.cancel();
        _state._timer = null;
      }
      _state = null;
    }
  }
}

/** The touch-and-hold handler for touch devices.
 */
class _TouchHoldGesture extends HoldGesture {
  StreamSubscription<Event> _subStart, _subMove, _subEnd;

  _TouchHoldGesture(Element owner, HoldGestureAction action,
  HoldGestureStart start, int duration, num movementLimit) : 
  super._init(owner, action, start, duration, movementLimit);
  
  void _listen() {
    _subStart = owner.onTouchStart.listen((TouchEvent event) {
      if (event.touches.length > 1)
        _touchEnd(); //ignore multiple fingers
      else
        _touchStart(event.target, event.timeStamp, event.page);
    });
    _subMove = document.onTouchMove.listen((TouchEvent event) {
      _touchMove(event.timeStamp, event.page);
    });
    _subEnd = document.onTouchEnd.listen((event) {
      _touchEnd();
    });
  }
  void _unlisten() {
    if (_subStart != null) {
      _subStart.cancel();
      _subStart = null;
    }
    if (_subMove != null) {
      _subMove.cancel();
      _subMove = null;
    }
    if (_subEnd != null) {
      _subEnd.cancel();
      _subEnd = null;
    }
  }
}
/** The touch-and-hold handler for mouse-based devices.
 */
class _MouseHoldGesture extends HoldGesture {
  StreamSubscription<Event> _subStart, _subMove, _subEnd;
  
  _MouseHoldGesture(Element owner, HoldGestureAction action,
  HoldGestureStart start, int duration, num movementLimit) : 
  super._init(owner, action, start, duration, movementLimit);
  
  void _listen() {
    _subStart = owner.onMouseDown.listen((MouseEvent event) {
      _touchStart(event.target, event.timeStamp, event.page);
    });
    _subMove = document.onMouseMove.listen((MouseEvent event) {
      _touchMove(event.timeStamp, event.page);
    });
    _subEnd = document.onMouseUp.listen((event) {
      _touchEnd();
    });
  }
  void _unlisten() {
    if (_subStart != null) {
      _subStart.cancel();
      _subStart = null;
    }
    if (_subMove != null) {
      _subMove.cancel();
      _subMove = null;
    }
    if (_subEnd != null) {
      _subEnd.cancel();
      _subEnd = null;
    }
  }
}
