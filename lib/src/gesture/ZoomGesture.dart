//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Aug 10, 2012 12:34:17 AM
//Author: simonpai
part of rikulo_gesture;

/** The state of a [ZoomGesture].
 */
class ZoomGestureState extends GestureState {
  final Point _startPos0, _startPos1, _startMid, _startDiff;
  Point _startDir;
  num _scaleBase;
  Point _pos0, _pos1;
  int _time;

  ZoomGestureState._(this.gesture, this.eventTarget, Point pos0, Point pos1, int time) :
  _startPos0 = pos0, _startPos1 = pos1, _pos0 = pos0, _pos1 = pos1,
  startTime = time, _time = time, _startMid = Points.divide(pos0 + pos1, 2), 
  _startDiff = pos1 - pos0 {
    _scaleBase = Points.norm(_startDiff);
    _startDir = Points.divide(_startDiff, _scaleBase);
  }

  //@onverride
  final EventTarget eventTarget;
  //@onverride
  int get time => _time;

  /** The associated [ZoomGesture].
   */
  final ZoomGesture gesture;
  
  /** The initial touch positions.
   */
  List<Point> get startPositions => [_startPos0, _startPos1];
  
  /** The midpoint of the two initial touch positions.
   */
  Point get startMidpoint => _startMid;
  
  /** The timestamp at which the gesture starts.
   */
  final int startTime;
  
  /** The current positions of gesture touches.
   */
  List<Point> get positions => [_pos0, _pos1];
  
  /** The midpoint of the two current touch positions.
   */
  Point get midpoint => Points.divide(_pos0 + _pos1, 2);
  
  /** The transition component in the gesture, which is defined by the 
   * displacement of the middle point of the two fingers.
   */
  Point get transition => midpoint - _startMid;
  
  /** The scalar component in the gesture, which is defined by the ratio
   * between the current finger distance and the initial finger distance.
   */
  num get scalar => Points.norm(_pos1 - _pos0) / _scaleBase;
  
  /** The rotation component in the gesture, which is defined as the unit 
   * vector representing the relative angular change between the fingers.
   */
  Point get rotation {
    final Point diff = _pos1 - _pos0;
    final num cx = diff.x, cy = diff.y, ix = _startDir.x, iy = _startDir.y;
    return Points.unit(new Point(cx*ix + cy*iy, cy*ix - cx*iy));
  }
  
  /** The rotation component in terms of angle, in the unit of radian.
   */
  num get angle {
    Point r = rotation;
    return r.x.abs() < r.y.abs() ? 
        (r.y < 0 ? -acos(r.x) : acos(r.x)) : 
        (r.x < 0 ? r.y < 0 ? -PI - asin(r.y) : PI - asin(r.y) : asin(r.y));
  }
  
  /** The CSS-compatible martix representing the linear transformation of the
   * gesture state. The transformation origin is the midpoint of the start
   * positions.
   */
  Transformation get transformation { // TODO: shall supply better assistance
    final Point tr = transition, ro = rotation * scalar;
    return new Transformation(ro.x, -ro.y, tr.x, ro.y, ro.x, tr.y);
  }
  
  void snapshot(Point pos0, Point pos1, int time) {
    if (time > _time) {
      _pos0 = pos0;
      _pos1 = pos1;
      _time = time;
    }
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
class ZoomGesture extends Gesture {
  final ZoomGestureStart _start;
  final ZoomGestureMove _move;
  final ZoomGestureEnd _end;
  
  StreamSubscription<Event> _subStart, _subMove, _subEnd;
  ZoomGestureState _state;
  bool _disabled = false;
  
  /** Create a zoom gesture.
   * 
   * + [owner] is the owner who shall listen to touch event.
   * + [start] is called when the second finger involves in the touch events.
   * + [move] is called continuously during the movement of the two fingers.
   * + [end] is called when a finger leaves, or when a third finger joins in 
   * the touch events.
   */
  ZoomGesture(this.owner, {ZoomGestureStart start, ZoomGestureMove move, 
  ZoomGestureEnd end}) : _start = start, _move = move, _end = end {
    
    // listen
    _subStart = owner.onTouchStart.listen((TouchEvent event) {
      final touches = event.touches,
            fingers = touches.length;
      if (fingers > 2) {
        _onEnd(event.timeStamp);
      
      } else if (fingers == 2) {
        final pt0 = touches[0].page,
              pt1 = touches[1].page;
        // t0 and t1 have to be different
        if (pt0.x != pt1.x || pt0.y != pt1.y) {
          _onStart(event.target, pt0, pt1, event.timeStamp);
          event.preventDefault();
        }
      }
    });
    _subMove = owner.onTouchMove.listen((TouchEvent event) {
      final touches = event.touches;
      if (touches.length == 2) {
        _onMove(touches[0].page, touches[1].page, event.timeStamp);
      }
    });
    _subEnd = owner.onTouchEnd.listen((TouchEvent event) => _onEnd(event.timeStamp));
  }
  
  /** The element to which the gesture applies.
   */
  final Element owner;
  
  void stop() {
    _state = null;
  }
  
  void destroy() {
    stop();
    
    // unlisten
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
  
  void disable() {
    stop();
    _disabled = true;
  }
  
  void enable() {
    _disabled = false;
  }
  
  void _onStart(EventTarget target, Point pos0, Point pos1, int time) {
    if (_disabled)
      return;
    
    stop();
    _state = new ZoomGestureState._(this, target, pos0, pos1, time);
    
    if (_start != null && identical(_start(_state), false))
      stop();
  }
  
  void _onMove(Point pos0, Point pos1, int time) {
    if (_state != null) {
      _state.snapshot(pos0, pos1, time);
      if (_move != null && identical(_move(_state), false))
        stop();
    }
  }
  
  void _onEnd(int time) {
    if (_state != null && _end != null)
      _end(_state);
    stop();
  }
  
}
