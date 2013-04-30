//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 20, 2012 11:37:32 AM
// Author: tomyeh
part of rikulo_gesture;

/** The callback when [DragGesture] tries to start the dragging.
 * + If false is returned, the gesture will be cancelled. In other cases (true
 * or null), the gesture will proceed.
 */
typedef bool DragGestureStart(DragGestureState state);

/** The callback invoked continuously during a [DragGesture].
 * + If false is returned, the gesture will be stopped. In other cases (true
 * or null) the gesture will continue.
 */
typedef bool DragGestureMove(DragGestureState state);

/** The callback invoked when [DragGesture] ends. (i.e. finger/mouse released)
 */
typedef void DragGestureEnd(DragGestureState state);

/** The state of dragging.
 */
class DragGestureState extends GestureState {
  final DragGesture _gesture;
  final VelocityProvider _vp;
  Point _position;
  int _time;

  DragGestureState._(DragGesture gesture, this.eventTarget, Point position, int time):
  _gesture = gesture, startPosition = position, _position = position, 
  startTime = time, _time = time, _vp = new VelocityProvider(position, time);

  @override
  final EventTarget eventTarget;
  @override
  int get time => _time;

  /** The associated [DragGesture]. */
  DragGesture get gesture => _gesture;

  /** The timestamp when the gesture starts. */
  final int startTime;
  
  /** The initial touch/cursor position. */
  final Point startPosition;
  
  /** The current touch/cursor position. */
  Point get position => _position;
  
  /** The displacement of the touch/cursor position of this dragging. */
  Point get transition => _position - startPosition;

  /** The current estimated velocity of touched/cursor position movement. */
  Point get velocity => _vp.velocity;

  void snapshot(Point position, int time) {
    _vp.snapshot(position, time);
    _position = position;
    _time = time;
  }
}

/** A touch-and-drag gesture handler
 */
abstract class DragGesture extends Gesture {
  final DragGestureStart _start;
  final DragGestureMove _move;
  final DragGestureEnd _end;
  DragGestureState _state;
  bool _disabled = false;

  /** Constructor.
   *
   * + [owner] is the owner of this drag gesture.
   * + [start] is the callback before starting dragging. The returned element
   * will be the element being moved.
   * If it returns false, the dragging won't be activated.
   * + [end] is the callback when the dragging is ended. Unlike other callbacks,
   * it must be specified.
   * + [move] is the allowed movement to consider if a user is dragging a touch.
   * The user has to drag more than this number to activate the dragging.
   * If negative, it is ignored, i.e., it is considered as dragging as long
   * as the touch starts.
   * Default: -1 (unit: pixels)
   */
  factory DragGesture(Element owner, {DragGestureStart start, 
  DragGestureMove move, DragGestureEnd end})
  => browser.touch ?
      new _TouchDragGesture(owner, start: start, move: move, end: end) :
      new _MouseDragGesture(owner, start: start, move: move, end: end);
  //for subclass to call
  DragGesture._init(this.owner, this._start, this._move, this._end) {
    _listen();
  }
  /** The element that owns this drag gesture (never null).
   */
  final Element owner;

  @override
  void destroy() {
    stop();
    _unlisten();
  }
  @override
  void disable() {
    stop();
    _disabled = true;
  }
  @override
  void enable() {
    _disabled = false;
  }
  @override
  void stop() {
    _state = null;
  }
  
  void _listen();
  void _unlisten();
  
  void _touchStart(Element target, Point position, int time) {
    if (_disabled)
      return;
    stop();

    _state = new DragGestureState._(this, target, position, time);
    if (_start != null && identical(_start(_state), false))
      stop();
  }
  void _touchMove(Point position, int time) {
    if (_state != null) {
      _state.snapshot(position, time);
      
      if (_move != null && identical(_move(_state), false))
        stop();
    }
  }
  void _touchEnd() {
    if (_state != null && _end != null)
      _end(_state);
    stop();
  }
}

class _TouchDragGesture extends DragGesture {
  StreamSubscription<Event> _subStart, _subMove, _subEnd;
  
  _TouchDragGesture(Element owner, {DragGestureStart start, 
  DragGestureMove move, DragGestureEnd end}):
    super._init(owner, start, move, end);

  void _listen() {
    _subStart = owner.onTouchStart.listen((TouchEvent event) {
      if (event.touches.length > 1)
        _touchEnd(); //ignore multiple fingers
      else {
        _touchStart(event.target, event.touches[0].page, event.timeStamp);
        if (!DomUtil.isInput(event.target))
          event.preventDefault();
      }
    });
    _subMove = owner.onTouchMove.listen((TouchEvent event) {
      _touchMove(event.touches[0].page, event.timeStamp);
    });
    _subEnd = owner.onTouchEnd.listen((TouchEvent event) {
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

class _MouseDragGesture extends DragGesture {
  StreamSubscription<Event> _subStart, _subMove, _subEnd;
  bool _captured = false;

  _MouseDragGesture(Element owner, {DragGestureStart start, 
  DragGestureMove move, DragGestureEnd end}):
    super._init(owner, start, move, end);

  void stop() {
    if (_captured)
      _captured = false;
    if (_subMove != null) {
      _subMove.cancel();
      _subMove = null;
    }
    if (_subEnd != null) {
      _subEnd.cancel();
      _subEnd = null;
    }
    super.stop();
  }
  void _capture() {
    _captured = true;
    _subMove = document.onMouseMove.listen((MouseEvent event) {
      _touchMove(event.page, event.timeStamp);
    });
    _subEnd = document.onMouseUp.listen((MouseEvent event) {
      _touchEnd();
    });
  }
  void _listen() {
    _subStart = owner.onMouseDown.listen((MouseEvent event) {
      _touchStart(event.target, event.page, event.timeStamp);
      _capture();
      if (!DomUtil.isInput(event.target))
        event.preventDefault();
    });
  }
  void _unlisten() {
    if (_subStart != null) {
      _subStart.cancel();
      _subStart = null;
    }
  }
}