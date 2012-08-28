//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Aug 10, 2012 12:34:17 AM
//Author: simonpai

/** The state of a [ZoomGesture].
 */
interface ZoomGestureState extends GestureState {
  
  /** The associated [ZoomGesture].
   */
  _ZoomGesture get gesture;
  
  /** The initial touch positions.
   */
  List<Offset> get startPositions;
  
  /** The midpoint of the two initial touch positions.
   */
  Offset get startMidpoint;
  
  /** The timestamp at which the gesture starts.
   */
  int get startTime;
  
  /** The current positions of gesture touches.
   */
  List<Offset> get positions;
  
  /** The midpoint of the two current touch positions.
   */
  Offset get midpoint;
  
  /** The transition component in the gesture, which is defined by the 
   * displacement of the middle point of the two fingers.
   */
  Offset get transition;
  
  /** The scalar component in the gesture, which is defined by the ratio
   * between the current finger distance and the initial finger distance.
   */
  num get scalar;
  
  /** The rotation component in the gesture, which is defined as the unit 
   * vector representing the relative angular change between the fingers.
   */
  Offset get rotation;
  
  /** The rotation component in terms of angle, in the unit of radian.
   */
  num get angle;
  
  /** The CSS-compatible martix representing the linear transformation of the
   * gesture state. The transformation origin is the midpoint of the start
   * positions.
   */
  Transformation get transformation; // TODO: shall supply better assistance
  
}

/** Default implementation of [ZoomGestureState].
 */
class _ZoomGestureState implements ZoomGestureState {
  
  final _ZoomGesture gesture;
  final EventTarget eventTarget;
  final Offset _startPos0, _startPos1, _startMid, _startDiff;
  Offset _startDir;
  num _scaleBase;
  final int startTime;
  var data;
  
  Offset _pos0, _pos1;
  int _time;
  
  _ZoomGestureState(this.gesture, this.eventTarget, Offset pos0, Offset pos1, int time) :
  _startPos0 = pos0, _startPos1 = pos1, _pos0 = pos0, _pos1 = pos1,
  startTime = time, _time = time, _startMid = (pos0 + pos1) / 2, 
  _startDiff = pos1 - pos0 {
    _scaleBase = _startDiff.norm();
    _startDir = _startDiff / _scaleBase;
  }
  
  void snapshot(Offset pos0, Offset pos1, int time) {
    if (time > _time) {
      _pos0 = pos0;
      _pos1 = pos1;
      _time = time;
    }
  }
  
  List<Offset> get startPositions => [_startPos0, _startPos1];
  
  List<Offset> get positions => [_pos0, _pos1];
  
  Offset get startMidpoint => _startMid;
  
  Offset get midpoint => (_pos0 + _pos1) / 2;
  
  int get time => _time;
  
  Offset get transition => midpoint - _startMid;
  
  num get scalar => (_pos1 - _pos0).norm() / _scaleBase;
  
  num get angle {
    Offset r = rotation;
    return r.x.abs() < r.y.abs() ? 
        (r.y < 0 ? -acos(r.x) : acos(r.x)) : 
        (r.x < 0 ? r.y < 0 ? -PI - asin(r.y) : PI - asin(r.y) : asin(r.y));
  }
  
  Offset get rotation {
    final Offset diff = _pos1 - _pos0;
    final num cx = diff.x, cy = diff.y, ix = _startDir.x, iy = _startDir.y;
    return new Offset(cx*ix + cy*iy, cy*ix - cx*iy).unit();
  }
  
  Transformation get transformation {
    final Offset tr = transition, ro = rotation * scalar;
    return new Transformation(ro.x, -ro.y, tr.x, ro.y, ro.x, tr.y);
  }
  
}

/** Called when the [ZoomGesture] starts.
 * 
 * + If [false] is returned, the gesture will cancel; in other cases ([true] or 
 * [null]), the gesture will proceed.
 */
typedef bool ZoomGestureStart(ZoomGestureState state);

/** Called continuously during the [ZoomGesture].
 * 
 * + If [false] is returned, the gesture will stop; in other cases ([true] or 
 * [null]), the gesture will proceed.
 */
typedef bool ZoomGestureMove(ZoomGestureState state);

/** Called when the [ZoomGesture] ends.
 */
typedef void ZoomGestureEnd(ZoomGestureState state);

/** A gesture defined by touch events of two fingers, as an angle-preserving
 * linear transforamtion, which can be naturally decomposed into the following
 * aspects:
 * + Scalar: the ratio of change of the distance between two fingers.
 * + Rotation: the angular change of relative direction of the two fingers.
 * + Transition: the displacement of the midpoint of two fingers.
 */
interface ZoomGesture extends Gesture default _ZoomGesture {
  
  /** Create a zoom gesture.
   * 
   * + [owner] is the owner who shall listen to touch event.
   * + [start] is called when the second finger involves in the touch events.
   * + [move] is called continuously during the movement of the two fingers.
   * + [end] is called when a finger leaves, or when a third finger joins in 
   * the touch events.
   */
  ZoomGesture(Element owner, [ZoomGestureStart start, ZoomGestureMove move, 
    ZoomGestureEnd end]);
  
  /** The element to which the gesture applies.
   */
  Element get owner;
  
}

/** Default implementation of [ZoomGesture].
 */
class _ZoomGesture implements ZoomGesture {
  
  final ZoomGestureStart _start;
  final ZoomGestureMove _move;
  final ZoomGestureEnd _end;
  
  EventListener _elStart, _elMove, _elEnd;
  _ZoomGestureState _state;
  bool _disabled = false;
  
  final Element owner;
  
  _ZoomGesture(this.owner, [ZoomGestureStart start, ZoomGestureMove move, 
  ZoomGestureEnd end]) : _start = start, _move = move, _end = end {
    
    // listen
    final ElementEvents on = owner.on;
    on.touchStart.add(_elStart = (TouchEvent event) {
      int fingers = event.touches.length;
      if (fingers > 2) {
        onEnd(event.timeStamp);
      
      } else if (fingers == 2) {
        Touch t0 = event.touches[0];
        Touch t1 = event.touches[1];
        // t0 and t1 have to be different
        if (t0.pageX != t1.pageX || t0.pageY != t1.pageY) {
          onStart(event.target, new Offset(t0.pageX, t0.pageY), 
            new Offset(t1.pageX, t1.pageY), event.timeStamp);
          event.preventDefault();
        }
      }
    });
    on.touchMove.add(_elMove = (TouchEvent event) {
      if (event.touches.length == 2) {
        Touch t0 = event.touches[0];
        Touch t1 = event.touches[1];
        onMove(new Offset(t0.pageX, t0.pageY), 
          new Offset(t1.pageX, t1.pageY), event.timeStamp);
      }
    });
    on.touchEnd.add(_elEnd = (TouchEvent event) => onEnd(event.timeStamp));
  }
  
  void stop() {
    _state = null;
  }
  
  void destroy() {
    stop();
    
    // unlisten
    final ElementEvents on = owner.on;
    if (_elStart != null)
      on.touchStart.remove(_elStart);
    if (_elMove != null)
      on.touchMove.remove(_elMove);
    if (_elEnd != null)
      on.touchEnd.remove(_elEnd);
  }
  
  void disable() {
    stop();
    _disabled = true;
  }
  
  void enable() {
    _disabled = false;
  }
  
  void onStart(EventTarget target, Offset pos0, Offset pos1, int time) {
    if (_disabled)
      return;
    
    stop();
    _state = new _ZoomGestureState(this, target, pos0, pos1, time);
    
    if (_start != null && _start(_state) === false)
      stop();
  }
  
  void onMove(Offset pos0, Offset pos1, int time) {
    if (_state != null) {
      _state.snapshot(pos0, pos1, time);
      if (_move != null && _move(_state) === false)
        stop();
    }
  }
  
  void onEnd(int time) {
    if (_state != null && _end != null)
      _end(_state);
    stop();
  }
  
}
