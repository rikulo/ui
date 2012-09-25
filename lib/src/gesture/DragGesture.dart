//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 20, 2012 11:37:32 AM
// Author: tomyeh

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
interface DragGestureState extends GestureState {
  
  /** The associated [DragGesture]. */
  DragGesture get gesture;
  
  /** The timestamp when the gesture starts. */
  int get startTime;
  
  /** The initial touch/cursor position. */
  Offset get startPosition;
  
  /** The current touch/cursor position. */
  Offset get position;
  
  /** The displacement of the touch/cursor position of this dragging. */
  Offset get transition;
  
  /** The current estimated velocity of touched/cursor position movement. */
  Offset get velocity;
  
}

/** A touch-and-drag gesture handler
 */
interface DragGesture extends Gesture default _DragGesture {
  
  /** Constructor.
   *
   * + [owner] is the owner of this drag gesture.
   * + [start] is the callback before starting dragging. The returned element
   * will be the element being moved.
   * If it returns false, the dragging won't be activated.
   * + [end] is the callback when the dragging is ended. Unlike other callbacks,
   * it must be specified.
   * + [movement] is the allowed movement to consider if a user is dragging a touch.
   * The user has to drag more than this number to activate the dragging.
   * If negative, it is ignored, i.e., it is considered as dragging as long
   * as the touch starts.
   * Default: -1 (unit: pixels)
   */
  DragGesture(Element owner, [DragGestureStart start, DragGestureMove move, 
    DragGestureEnd end]);
  
  /** The element that owns this drag gesture (never null).
   */
  Element get owner;
  
}

class _DragGestureState implements DragGestureState {
  final _DragGesture _gesture;
  final VelocityProvider _vp;
  final EventTarget eventTarget;
  final Offset startPosition;
  final int startTime;
  Offset _position;
  int _time;
  var data;
  
  _DragGestureState(DragGesture gesture, this.eventTarget, Offset position, int time):
  _gesture = gesture, startPosition = position, _position = position, 
  startTime = time, _time = time, _vp = new VelocityProvider(position, time);
  
  DragGesture get gesture => _gesture;
  
  Offset get position => _position;
  
  Offset get transition => _position - startPosition;
  
  Offset get velocity => _vp.velocity;
  
  int get time => _time;
  
  void snapshot(Offset position, int time) {
    _vp.snapshot(position, time);
    _position = position;
    _time = time;
  }
  
}

//abstract
class _DragGesture implements DragGesture {
  final Element _owner;
  final DragGestureStart _start;
  final DragGestureMove _move;
  final DragGestureEnd _end;
  _DragGestureState _state;
  bool _disabled = false;
  
  factory _DragGesture(Element owner, [DragGestureStart start, 
  DragGestureMove move, DragGestureEnd end]) {
    return browser.touch ?
      new _TouchDragGesture(owner, start, move, end) :
      new _MouseDragGesture(owner, start, move, end);
  }
  
  _DragGesture._init(Element this._owner, DragGestureStart this._start, 
  DragGestureMove this._move, DragGestureEnd this._end) {
    _listen();
  }
  
  void destroy() {
    stop();
    _unlisten();
  }
  
  void disable() {
    stop();
    _disabled = true;
  }
  
  void enable() {
    _disabled = false;
  }
  
  void stop() {
    _state = null;
  }
  
  Element get owner => _owner;
  
  abstract void _listen();
  abstract void _unlisten();
  
  void _touchStart(Element target, Offset position, int time) {
    if (_disabled)
      return;
    stop();

    _state = new _DragGestureState(this, target, position, time);
    if (_start != null && _start(_state) === false)
      stop();
  }
  
  void _touchMove(Offset position, int time) {
    if (_state != null) {
      _state.snapshot(position, time);
      
      if (_move != null && _move(_state) === false)
        stop();
    }
  }
  
  void _touchEnd() {
    if (_state != null && _end != null)
      _end(_state);
    stop();
  }
  
}

class _TouchDragGesture extends _DragGesture {
  EventListener _elStart, _elMove, _elEnd;
  
  _TouchDragGesture(Element owner, [DragGestureStart start, 
  DragGestureMove move, DragGestureEnd end]):
    super._init(owner, start, move, end);

  void _listen() {
    final ElementEvents on = _owner.on;
    on.touchStart.add(_elStart = (TouchEvent event) {
      if (event.touches.length > 1)
        _touchEnd(); //ignore multiple fingers
      else {
        Touch t = event.touches[0];
        _touchStart(event.target, new Offset(t.pageX, t.pageY), event.timeStamp);
        if (!new DOMQuery(event.target).isInput())
          event.preventDefault();
      }
    });
    on.touchMove.add(_elMove = (TouchEvent event) {
      Touch t = event.touches[0];
      _touchMove(new Offset(t.pageX, t.pageY), event.timeStamp);
    });
    on.touchEnd.add(_elEnd = (TouchEvent event) {
      _touchEnd();
    });
  }
  void _unlisten() {
    final ElementEvents on = _owner.on;
    if (_elStart != null) on.touchStart.remove(_elStart);
    if (_elMove != null) on.touchMove.remove(_elMove);
    if (_elEnd != null) on.touchEnd.remove(_elEnd);
  }
}

class _MouseDragGesture extends _DragGesture {
  EventListener _elStart, _elMove, _elEnd;
  bool _captured = false;

  _MouseDragGesture(Element owner, [DragGestureStart start, 
  DragGestureMove move, DragGestureEnd end]):
    super._init(owner, start, move, end);

  void stop() {
    if (_captured) {
      _captured = false;
      final ElementEvents on = document.on;
      if (_elMove != null)
        on.mouseMove.remove(_elMove);
      if (_elEnd != null)
        on.mouseUp.remove(_elEnd);
    }
    super.stop();
  }
  void _capture() {
    _captured = true;
    final ElementEvents on = document.on;
    on.mouseMove.add(_elMove = (MouseEvent event) {
      _touchMove(new Offset(event.pageX, event.pageY), event.timeStamp);
    });
    on.mouseUp.add(_elEnd = (MouseEvent event) {
      _touchEnd();
    });
  }
  void _listen() {
    _owner.on.mouseDown.add(_elStart = (MouseEvent event) {
      _touchStart(event.target, new Offset(event.pageX, event.pageY), event.timeStamp);
      _capture();
      if (!new DOMQuery(event.target).isInput())
        event.preventDefault();
    });
  }
  void _unlisten() {
    if (_elStart != null)
      _owner.on.mouseDown.remove(_elStart);
  }
}