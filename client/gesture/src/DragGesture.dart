//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 20, 2012 11:37:32 AM
// Author: tomyeh

/** The callback when [DragGesture] tries to start the dragging.
 *
 * If it returns null, the DragGesture won't be activated (i.e., ignored).
 * If not null, the returned element will be the element that the user
 * is dragging. If you'd like to move the owner directly, you can return
 * [DragGesture]'s `owner`. If you prefer to move a 'ghosted' element,
 * you can make a copy or create a different element depending on your
 * requirement.
 */
typedef Element DragGestureStart(DragGestureState state);

/** The callback invoked during a [DragGesture].
 *
 * If this method returns true, [DragGesture] won't move any element.
 * It is useful if you'd like use [DragGesture] to trigger something
 * rather than moving.
 */
typedef bool DragGestureMove(DragGestureState state);

/** The callback invoked when [DragGesture] ends. (i.e. finger released)
 */
typedef void DragGestureEnd(DragGestureState state);

/** The state of dragging.
 */
interface DragGestureState {
  
  /** The associated [DragGesture]. */
  DragGesture get gesture();
  
  /** The timestamp when the gesture starts. */
  int get startTime();
  
  /** The latest timestamp of this dragging. */
  int get time();
  
  /** The initial touch/cursor position. */
  Offset get startPosition();
  
  /** The current touch/cursor position. */
  Offset get position();
  
  /** The displacement of the touch/cursor position of this dragging. */
  Offset get transition();
  
  /** The current estimated velocity of touched/cursor position movement. */
  Offset get velocity();
  
  // TODO
  /** The element that was dragged, or null if the dragging is not started.
   * It is the element returned by [start], if specified.
   */
  Element get dragged();
  
  /** The range that the user is allowed to drag, or null if there
   * is no limitation.
   */
  Rectangle get range();
  
  /** The element that the users touches at the beginning.
   */
  Element get touched();

  /** Returns whether the user ever moved his finger.
   */
  bool get moved();
  
}

/**
 * A touch-and-drag gesture handler
 */
interface DragGesture default _DragGesture {
  /** Constructor.
   *
   * + [owner] is the owner of this drag gesture.
   * + [handle] specifies the element that the user can drag.
   * If not specified, [owner] is assumed.
   * + [range] specifies the range that the user is allowed to drag.
   * The coordinate is the same as [dragged]'s coordinate.
   * If the range's width is 0, the user can drag only vertically.
   * If height is 0, the user can drag only horizontally.
   * If not specified, the whole screen is assumed.
   * If you'd like to limit the dragging to a shape other than rectangle,
   * you have to specify [move] and move the dragged element in the shape
   * you want (and return true to ignore the default move).
   * Notice that if [transform] is true, the range's width and height shall
   * be negative (since the direction is opposite).
   * + [transform] specifies whether to move [owner] by adjusting the CSS style's
   * transform property (of [dragged]).
   * If not specified (false), it changes the owner's position directly.
   * + [start] is the callback before starting dragging. The returned element
   * will be the element being moved.
   * If it returns null, the dragging won't be activated.
   * + [end] is the callback when the dragging is ended. Unlike other callbacks,
   * it must be specified.
   * + [movement] is the allowed movement to consider if a user is dragging a touch.
   * The user has to drag more than this number to activate the dragging.
   * If negative, it is ignored, i.e., it is considered as dragging as long
   * as the touch starts.
   * Default: -1 (unit: pixels)
   */
  DragGesture(Element owner, [Element handle, bool transform,
    AsRectangle range,
    DragGestureStart start, DragGestureMove move, DragGestureEnd end]);

  /** Destroys this [DragGesture].
   * It shall be called to clean up the gesture, if it is no longer used.
   */
  void destroy();
  
  /** Disable the gesture.
   */
  void disable();
  
  /** Enable the gesture.
   */
  void enable();
  
  /** The element that owns this drag gesture (never null).
   */
  Element get owner();
  
  /** The element that the user can drag (never null).
   */
  Element get handle();
}

class _DragGestureState implements DragGestureState {
  final _DragGesture _gesture;
  final VelocityProvider _vp;
  final Offset _ownerOfs, startPosition;
  final int startTime;
  Offset _position, _initTxOfs;
  Rectangle _range;
  Element _dragged, _touched;
  var data;
  bool _moved = false;
  int _time;
  
  _DragGestureState(DragGesture gesture, Offset position, int time):
  _gesture = gesture, startPosition = position, _position = position, 
  startTime = time, _time = time, _vp = new VelocityProvider(position, time),
  _ownerOfs = new DOMQuery(gesture.owner).pageOffset;

  DragGesture get gesture() => _gesture;
  Offset get position() => _position;
  Offset get transition() => _position - startPosition;
  Offset get velocity() => _vp.velocity;
  bool get moved() => _moved;
  int get time() => _time;

  Element get dragged() => _dragged;
  Element get touched() => _touched;
  Rectangle get range() {
    if (_range == null && _gesture._fnRange != null)
      _range = _gesture._fnRange();
    return _range;
  }
  
  void snapshot(Offset position, int time) {
    _vp.snapshot(position, time);
    _position = position;
    _time = time;
  }
}

//abstract
class _DragGesture implements DragGesture {
  final Element _owner, _handle;
  final DragGestureStart _start;
  final DragGestureMove _move;
  final DragGestureEnd _end;
  final AsRectangle _fnRange;
  _DragGestureState _state;
  final bool _transform;
  bool _disabled = false;
  
  factory _DragGesture(Element owner, [Element handle, // TODO: handle, transform, range to remove
    bool transform=false, AsRectangle range,
    DragGestureStart start, DragGestureMove move, DragGestureEnd end]) {
    if (handle == null) handle = owner;
    return browser.touch ?
      new _TouchDragGesture(owner, handle, transform, range, start, move, end) :
      new _MouseDragGesture(owner, handle, transform, range, start, move, end);
  }
  _DragGesture._init(Element this._owner, Element this._handle,
    bool this._transform, AsRectangle this._fnRange,
    DragGestureStart this._start, DragGestureMove this._move, 
    DragGestureEnd this._end) {
    _listen();
  }

  void destroy() {
    _stop();
    _unlisten();
  }
  
  void disable() {
    _stop();
    _disabled = true;
  }
  
  void enable() {
    _disabled = false;
  }
  
  Element get owner() => _owner;
  Element get handle() => _handle;

  abstract void _listen();
  abstract void _unlisten();

  void _stop() {
    _state = null;
  }
  void _touchStart(Element touched, Offset position, int time) {
    if (_disabled)
      return;
    _stop();

    _state = new _DragGestureState(this, position, time);
    _state._touched = touched;
    final Element dragged =
      _state._dragged = _start != null ? _start(_state): owner;
    if (dragged == null) { //not allowed
      _stop();
    } else {
      _state._initTxOfs = _transform ? 
          CSS.offset3dOf(dragged.style.transform): new DOMQuery(dragged).offset;
    }
  }
  void _touchMove(Offset position, int time) {
    if (_state != null) {
      final Offset initPgOfs = _state.startPosition;
      _state.snapshot(position, time);
      
      if (_state._touched != null) {
        final int deltaX = position.x - initPgOfs.x;
        final int deltaY = position.y - initPgOfs.y;
        final Offset initofs = _state._initTxOfs,
            move = _constraint(deltaX + initofs.x, deltaY + initofs.y);
        
        if (_move != null) {
          _state._moved = _state._moved || deltaX != 0 || deltaY != 0;
          bool done = _move(_state);
          if (done != null && done)
            return; //no need to move
        }
        if (_transform) {
          _state._dragged.style.transform = CSS.translate3d(move.x, move.y);
        } else {
          _state._dragged.style.left = CSS.px(move.x);
          _state._dragged.style.top = CSS.px(move.y);
        }
      }
    }
  }
  void _touchEnd() {
    if (_state != null && _end != null)
      _end(_state);
    _stop();
  }
  Offset _constraint(int x, y) {
    final Rectangle range = _state.range;
    Offset off = new Offset(x, y);
    if (range != null)
      off = range.snap(off);
    return off;
  }
}

class _TouchDragGesture extends _DragGesture {
  EventListener _elStart, _elMove, _elEnd;
  
  _TouchDragGesture(Element owner, [Element handle,
    bool transform, AsRectangle range,
    DragGestureStart start, DragGestureMove move, DragGestureEnd end]):
    super._init(owner, handle, transform, range, start, move, end);

  void _listen() {
    final ElementEvents on = handle.on;
    on.touchStart.add(_elStart = (TouchEvent event) {
      if (event.touches.length > 1)
        _touchEnd(); //ignore multiple fingers
      else {
        Touch t = event.touches[0];
        _touchStart(event.target, new Offset(t.pageX, t.pageY), event.timeStamp);
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
    final ElementEvents on = handle.on;
    if (_elStart != null) on.touchStart.remove(_elStart);
    if (_elMove != null) on.touchMove.remove(_elMove);
    if (_elEnd != null) on.touchEnd.remove(_elEnd);
  }
}

class _MouseDragGesture extends _DragGesture {
  EventListener _elStart, _elMove, _elEnd;
  bool _captured = false;

  _MouseDragGesture(Element owner, [Element handle,
    bool transform, AsRectangle range,
    DragGestureStart start, DragGestureMove move, DragGestureEnd end]):
    super._init(owner, handle, transform, range, start, move, end);

  void _stop() {
    if (_captured) {
      _captured = false;
      final ElementEvents on = document.on;
      if (_elMove != null)
        on.mouseMove.remove(_elMove);
      if (_elEnd != null)
        on.mouseUp.remove(_elEnd);
    }
    super._stop();
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
    handle.on.mouseDown.add(_elStart = (MouseEvent event) {
      _touchStart(event.target, new Offset(event.pageX, event.pageY), event.timeStamp);
      _capture();
    });
  }
  void _unlisten() {
    if (_elStart != null)
      handle.on.mouseDown.remove(_elStart);
  }
}