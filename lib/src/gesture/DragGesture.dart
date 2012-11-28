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
  Offset _position;
  int _time;

  DragGestureState._(DragGesture gesture, this.eventTarget, Offset position, int time):
  _gesture = gesture, startPosition = position, _position = position, 
  startTime = time, _time = time, _vp = new VelocityProvider(position, time);

  //@override
  final EventTarget eventTarget;
  //@override
  int get time => _time;

  /** The associated [DragGesture]. */
  DragGesture get gesture => _gesture;

  /** The timestamp when the gesture starts. */
  final int startTime;
  
  /** The initial touch/cursor position. */
  final Offset startPosition;
  
  /** The current touch/cursor position. */
  Offset get position => _position;
  
  /** The displacement of the touch/cursor position of this dragging. */
  Offset get transition => _position - startPosition;

  /** The current estimated velocity of touched/cursor position movement. */
  Offset get velocity => _vp.velocity;

  void snapshot(Offset position, int time) {
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
   * + [movement] is the allowed movement to consider if a user is dragging a touch.
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
  DragGesture._init(Element this.owner, DragGestureStart this._start, 
  DragGestureMove this._move, DragGestureEnd this._end) {
    _listen();
  }
  /** The element that owns this drag gesture (never null).
   */
  final Element owner;

  //@override  
  void destroy() {
    stop();
    _unlisten();
  }
  //@override  
  void disable() {
    stop();
    _disabled = true;
  }
  //@override  
  void enable() {
    _disabled = false;
  }
  //@override  
  void stop() {
    _state = null;
  }
  
  void _listen();
  void _unlisten();
  
  void _touchStart(Element target, Offset position, int time) {
    if (_disabled)
      return;
    stop();

    _state = new DragGestureState._(this, target, position, time);
    if (_start != null && identical(_start(_state), false))
      stop();
  }
  void _touchMove(Offset position, int time) {
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
  EventListener _elStart, _elMove, _elEnd;
  
  _TouchDragGesture(Element owner, {DragGestureStart start, 
  DragGestureMove move, DragGestureEnd end}):
    super._init(owner, start, move, end);

  void _listen() {
    final ElementEvents on = owner.on;
    on.touchStart.add(_elStart = (TouchEvent event) {
      if (event.touches.length > 1)
        _touchEnd(); //ignore multiple fingers
      else {
        Touch t = event.touches[0];
        _touchStart(event.target, new Offset(t.pageX, t.pageY), event.timeStamp);
        if (!new DomAgent(event.target).isInput)
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
    final ElementEvents on = owner.on;
    if (_elStart != null) on.touchStart.remove(_elStart);
    if (_elMove != null) on.touchMove.remove(_elMove);
    if (_elEnd != null) on.touchEnd.remove(_elEnd);
  }
}

class _MouseDragGesture extends DragGesture {
  EventListener _elStart, _elMove, _elEnd;
  bool _captured = false;

  _MouseDragGesture(Element owner, {DragGestureStart start, 
  DragGestureMove move, DragGestureEnd end}):
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
    owner.on.mouseDown.add(_elStart = (MouseEvent event) {
      _touchStart(event.target, new Offset(event.pageX, event.pageY), event.timeStamp);
      _capture();
      if (!new DomAgent(event.target).isInput)
        event.preventDefault();
    });
  }
  void _unlisten() {
    if (_elStart != null)
      owner.on.mouseDown.remove(_elStart);
  }
}