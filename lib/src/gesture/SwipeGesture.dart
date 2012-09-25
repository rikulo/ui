//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Aug 3, 2012 12:56:15 AM
//Author: simonpai

/** The callback invoked by [SwipeGesture].
 */
typedef void SwipeGestureAction(SwipeGestureState state);

/** The state of a [SwipeGesture].
 */
interface SwipeGestureState extends GestureState {
  
  /** Retrieve the associated [SwipeGesture].
   */
  SwipeGesture get gesture;
  
  /** The timestamp when the swipe starts.
   */
  int get startTime;
  
  /** The touched/cursor position at the start of swipe.
   */
  Offset get startPosition;
  
  /** The touched/cursor position at the end of swipe.
   */
  Offset get position;
  
  /** The displacement of the touched/cursor position of the swipe.
   */
  Offset get transition;
  
  /** The current estimated velocity of movement.
   */
  Offset get velocity;
  
}

class _SwipeGestureState implements SwipeGestureState {
  
  final SwipeGesture gesture;
  final EventTarget eventTarget;
  final Offset startPosition, position, transition, velocity;
  final int startTime, time;
  var data;
  
  _SwipeGestureState(this.gesture, DragGestureState ds) :
  eventTarget = ds.eventTarget, startTime = ds.startTime, time = ds.time,
  startPosition = ds.startPosition, position = ds.position,
  transition = ds.transition, velocity = ds.velocity;
  
}

/** The gesture of a swipe.
 */
interface SwipeGesture extends Gesture default _SwipeGesture {
  
  /** Construct a swipe gesture on [owner] with the given callback [swipe].
   */
  SwipeGesture(Element owner, SwipeGestureAction action);
  
  /** The element associated with this swipe gesture (never null).
   */
  Element get owner;
  
}

/** Default implementation of [SwipeGesture].
 */
class _SwipeGesture implements SwipeGesture {
  
  final Element owner;
  DragGesture _drag;
  
  _SwipeGesture(this.owner, SwipeGestureAction action) {
    _drag = new DragGesture(owner, 
    end: (DragGestureState state) {
      if (action != null)
        action(new _SwipeGestureState(this, state));
      
    });
  }
  
  void stop() {
    if (_drag != null)
      _drag.stop();
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
