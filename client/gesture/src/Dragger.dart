//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Aug 16, 2012 15:54:31 AM
//Author: simonpai

/** The callback invoked by [Dragger] when dragging starts.
 * 
 * + If false is returned, the dragging will be cancelled. In other cases (true
 * or null) the dragging will proceed.
 */
typedef bool DraggerStart(DraggerState state);

/** The callback invoked continuously by [Dragger] during dragging.
 * 
 * + [updateElementPosition] applies the position to the dragged Element. You
 * shall call it to attain the default behavior of Dragger.
 * + If false is returned, the dragging will be stopped. In other cases (true
 * or null) the dragging will continue.
 */
typedef bool DraggerMove(DraggerState state, void updateElementPosition());

/** The callback invoked by [Dragger] when dragging ends. 
 */
typedef void DraggerEnd(DraggerState state);

/** The state of a dragging movement of [Dragger].
 */
interface DraggerState extends GestureState {
  
  /** The associated [Dragger]. */
  Dragger get dragger();
  
  /** The dragged Element. */
  Element get target();
  
  /** The [DragGestureState] of the underlying [DragGesture], which supplies 
   * information of touch/cursor position, rather than element positions.
   */
  DragGestureState get gestureState();
  
  /** The timestamp when this dragging movement starts. */
  int get startTime();
  
  /** The initial element position (offset with respect to parent). */
  Offset get elementStartPosition();
  
  /** The current element position (offset with respect to parent). */
  Offset get elementPosition();
  
  /** The displacement of the touch/cursor position of this dragging. */
  Offset get elementTransition();
  
  /** The current estimated velocity of touch/cursor position movement. */
  Offset get elementVelocity();
  
}

/** Default implementation of [DraggerState].
 */
class _DraggerState implements DraggerState {
  
  final Dragger dragger;
  final DragGestureState gestureState;
  final Offset elementStartPosition;
  final int startTime;
  final Element target;
  VelocityProvider _vp;
  Offset _elementPosition;
  int _time;
  var data;
  
  _DraggerState(this.dragger, Element target, Offset targetPosition, 
  DragGestureState gstate) :
  this.target = target, gestureState = gstate, startTime = gstate.startTime,
  elementStartPosition = targetPosition {
    _vp = new VelocityProvider(elementStartPosition, startTime);
  }
  
  int get time() => _time;
  
  Offset get elementPosition() => _elementPosition;
  
  Offset get elementTransition() => _elementPosition - elementStartPosition;
  
  Offset get elementVelocity() => _vp.velocity;
  
  void snapshot(Offset position, int time) {
    _vp.snapshot(position, time);
    _elementPosition = position;
    _time = time;
  }
  
}

/** An utility to allow user dragging an Element. The dragging is triggered by
 * single-touch dragging on touch device or mouse dragging on PC.
 */
interface Dragger extends Gesture default _Dragger {
  
  /** Construct a Dragger.
   * + [owner] is the Element which receives drag gesture.
   * + if provided, [dragged] will determine the actual dragged Element. This 
   * is useful when you need to create a ghost Element for dragging instead of
   * moving the original one.
   * + if provided, [snap] will patch the position applied to the Element. You
   * can use it to restrict the movement of the dragged Element.
   * + [threshold] TODO
   * + [transform] if true, the Element position will be updated by setting
   * its CSS transform attribute, rather than by left/top attributes.
   * + [start] Callback invoked when dragging starts.
   * + [move] Callback invoked continuously during dragging.
   * + [end] Callback invoked when dragging ends.
   */
  Dragger(Element owner, [Element dragged(), 
  Offset snap(Offset previousPosition, Offset position), 
  num threshold, bool transform, 
  DraggerStart start, DraggerMove move, DraggerEnd end]);
  
  /** The owner of this Dragger. */
  Element get owner();
  
}

/** Default implementation of [Dragger].
 */
class _Dragger implements Dragger {
  
  final Element _owner;
  final DraggerStart _start;
  final DraggerMove _move;
  final DraggerEnd _end;
  DragGesture _drag;
  
  bool _disabled = false;
  _DraggerState _state;
  
  _Dragger(this._owner, [Element dragged(), 
  Offset snap(Offset previousPosition, Offset position), 
  num threshold = -1, bool transform,
  DraggerStart start, DraggerMove move, DraggerEnd end]) :
  _start = start, _move = move, _end = end {
    
    _drag = new DragGesture(owner, start: (DragGestureState state) {
      if (_disabled)
        return false; 
      _stop();
      
      Element tar = dragged != null ? dragged() : owner;
      if (tar == null)
        return false;
      
      // TODO: threshold
      _state = new _DraggerState(this, tar, _getElementPosition(tar), state);
      if (_start != null && _start(_state) === false) {
        _stop();
        return false;
      }
      
    }, move: (DragGestureState state) {
      if (_state != null) {
        // calculate element position
        Offset oldElemPos = _state.elementPosition;
        Offset elemPos = _state.elementStartPosition + state.transition;
        if (snap != null)
          elemPos = snap(oldElemPos, elemPos);
        
        // update state
        _state.snapshot(elemPos, state.time);
        
        // callback, update element position
        if (_move != null) {
          if (_move(_state, () => _setElementPosition(_state.target, elemPos)) === false) {
            _stop();
            return false; // stop gesture
          }
        } else
          _setElementPosition(_state.target, elemPos);
        
      }
      
    }, end: (DragGestureState state) {
      if (_state != null && _end != null)
        _end(_state);
      
    });
    
  }
  
  Offset _getElementPosition(Element target) => new DOMQuery(target).offset; // TODO: transform
  
  void _setElementPosition(Element target, Offset position) {
    // TODO: transform
    target.style.left = CSS.px(position.left);
    target.style.top = CSS.px(position.top);
  }
  
  void stop() {
    if (_drag != null)
      _drag.stop();
    _stop();
  }
  
  void _stop() { // stop locally
    _state = null;
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
  
  Element get owner() => _owner;
  
}
