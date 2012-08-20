//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Aug 3, 2012 12:56:15 AM
//Author: simonpai

/** 
 */
interface SwipeGestureState extends MovementState {
  
  /** Retrieve the associated [SwipeGesture].
   */
  SwipeGesture get gesture();
  
}

class _SwipeGestureState implements SwipeGestureState {
  
  final SwipeGesture gesture;
  final Offset offset, delta, velocity;
  final Element touched;
  final bool moved;
  final int time;
  
  var data;
  
  _SwipeGestureState.fromDrag(this.gesture, DragGestureState dragState) :
  offset = dragState.offset, delta = dragState.delta, 
  velocity = dragState.velocity, touched = dragState.touched,
  moved = dragState.moved, time = dragState.time;
  
}

/** 
 */
interface SwipeGesture default _SwipeGesture {
  
  /** Construct a swipe gesture on [owner] with the given callback [swipe].
   */
  SwipeGesture(Element owner, void swipe(SwipeGestureState state));
  
  /** Destroys this [SwipeGesture].
   * It shall be called to clean up the gesture, if it is no longer used.
   */
  void destroy();
  
  /** Disable the gesture.
   */
  void disable();
  
  /** Enable the gesture.
   */
  void enable();
  
  /** The element associated with this swipe gesture (never null).
   */
  Element get owner();
  
}

/** Default implementation of [SwipeGesture].
 */
class _SwipeGesture implements SwipeGesture {
  
  final Element owner;
  DragGesture _drag;
  
  _SwipeGesture(this.owner, void swipe(SwipeGestureState state)) {
    _drag = new DragGesture(owner, move: (DragGestureState state) => true, 
    end: (DragGestureState state) {
      if (swipe != null)
        swipe(new _SwipeGestureState.fromDrag(this, state));
    });
  }
  
  void disable() {
    if (_drag != null)
      _drag.disable();
  }
  
  void enable() {
    if (_drag != null)
      _drag.enable();
  }
  
  void destroy() {
    if (_drag != null) {
      _drag.destroy();
      _drag = null;
    }
  }
  
}
