//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Aug 16, 2012 15:54:31 AM
//Author: simonpai
part of rikulo_gesture;

/** The callback invoked by [Dragger] when dragging starts.
 * 
 * + If false is returned, the dragging will be cancelled. In other cases (true
 * or null) the dragging will proceed.
 */
typedef bool DraggerStart(DraggerState state);

/** The callback invoked continuously by [Dragger] during dragging.
 * 
 * + [defaultAction] applies the position to the dragged Element. You
 * shall call it to attain the default behavior of Dragger.
 * + If false is returned, the dragging will be stopped. In other cases (true
 * or null) the dragging will continue.
 */
typedef bool DraggerMove(DraggerState state, void defaultAction());

/** The callback invoked by [Dragger] when dragging ends. 
 */
typedef void DraggerEnd(DraggerState state);

/** The state of a dragging movement of [Dragger].
 */
class DraggerState extends GestureState {
  final Point _gestureStartPosition;
  VelocityProvider _vp;
  Point _elementPosition;
  int _time;

  DraggerState._(this.dragger, this.draggedElement, Point targetPosition, 
  DragGestureState gstate) :
  gestureState = gstate, eventTarget = gstate.eventTarget, startTime = gstate.time,
  elementStartPosition = targetPosition,
  _gestureStartPosition = gstate.position {
    _vp = new VelocityProvider(elementStartPosition, startTime);
  }

  @override
  final EventTarget eventTarget;
  @override
  int get time => _time;

  /** The associated [Dragger]. */
  final Dragger dragger;
  
  /** The dragged Element. */
  final Element draggedElement;
  
  /** The [DragGestureState] of the underlying [DragGesture], which supplies 
   * information of touch/cursor position, rather than element positions.
   */
  final DragGestureState gestureState;
  
  /** The timestamp when this dragging movement starts. */
  final int startTime;
  
  /** The initial element position (offset with respect to parent). */
  final Point elementStartPosition;
  
  /** The current element position (offset with respect to parent). */
  Point get elementPosition => _elementPosition;
  /** The displacement of the touch/cursor position of this dragging. */
  Point get elementTransition => _elementPosition - elementStartPosition;
  /** The current estimated velocity of touch/cursor position movement. */
  Point get elementVelocity => _vp.velocity;

  void snapshot(Point position, int time) {
    _vp.snapshot(position, time);
    _elementPosition = position;
    _time = time;
  }
}

/** An utility to allow user dragging an Element. The dragging is triggered by
 * single-touch dragging on touch device or mouse dragging on PC.
 */
class Dragger extends Gesture {
  
  final DraggerStart _start;
  final DraggerMove _move;
  final DraggerEnd _end;
  DragGesture _drag;
  final bool _transform;
  
  bool _disabled = false, _pending = false;
  DraggerState _state;
  
  /** The owner of this Dragger. */
  final Element owner;

  /** Construct a Dragger.
   * + [owner] is the Element which receives drag gesture.
   * + If provided, [dragged] will determine the actual dragged Element. This 
   * is useful when you need to create a ghost Element for dragging instead of
   * moving the original one.
   * + If provided, [snap] will patch the position applied to the Element. You
   * can use it to restrict the movement of the dragged Element.
   * + [threshold] The minimal movement (away from starting potision) required
   * to activate dragging. 
   * + [transform] If true, the Element position will be updated by setting
   * its CSS transform attribute, rather than by left/top attributes.
   * + [start] Callback invoked when dragging starts.
   * + [move] Callback invoked continuously during dragging.
   * + [end] Callback invoked when dragging ends.
   */
  Dragger(this.owner, {Element dragged(), 
  Point snap(Point previousPosition, Point position), 
  num threshold: -1, bool transform: false,
  DraggerStart start, DraggerMove move, DraggerEnd end}) :
  _transform = transform, _start = start, _move = move, _end = end {
    
    _drag = new DragGesture(owner, start: (DragGestureState state) {
      if (_disabled)
        return false; 
      _stop();
      
      if (_pending = threshold > 0)
        return true;
      
      return _initState(dragged, state);
      
    }, move: (DragGestureState state) {
      if (_pending && Points.norm(state.transition) > threshold) {
        _pending = false;
        return _initState(dragged, state);
      }
      
      if (_state != null) {
        // calculate element position
        Point oldElemPos = _state.elementPosition;
        Point elemPos = 
            _state.elementStartPosition + state.position - _state._gestureStartPosition;
        if (snap != null)
          elemPos = snap(oldElemPos, elemPos);
        
        // update state
        _state.snapshot(elemPos, state.time);
        
        // callback, update element position
        if (_move != null) {
          if (identical(_move(_state, () => setElementPosition_(_state.draggedElement, elemPos)), false)) {
            _stop();
            return false; // stop gesture
          }
        } else
          setElementPosition_(_state.draggedElement, elemPos);
        
      }
      
    }, end: (DragGestureState state) {
      if (_state != null && _end != null)
        _end(_state);
      
    });
    
  }
  
  bool _initState(Element dragged(), DragGestureState state) {
    Element tar = dragged != null ? dragged() : owner;
    if (tar == null)
      return false;
    
    _state = new DraggerState._(this, tar, getElementPosition_(tar), state);
    if (_start != null && identical(_start(_state), false)) {
      _stop();
      return false;
    }
    
    return true;
  }
  
  Point getElementPosition_(Element target) {
    return _transform ? CssUtil.point3DOf(target.style.transform):
    		DomUtil.position(target);
  }
  
  void setElementPosition_(Element target, Point position) {
    if (_transform) {
      target.style.transform = CssUtil.translate3d(position.x, position.y);
    } else {
      target.style.left = CssUtil.px(position.x);
      target.style.top = CssUtil.px(position.y);
    }
  }
  
  void stop() {
    if (_drag != null)
      _drag.stop();
    _stop();
  }
  
  void _stop() { // stop locally
    _state = null;
    _pending = false;
  }
  
  void destroy() {
    if (_drag != null)
      _drag.destroy();
    _drag = null;
  }
  
  void disable() {
    _stop();
    if (_drag != null)
      _drag.disable();
  }
  
  void enable() {
    if (_drag != null)
      _drag.enable();
  }
}
