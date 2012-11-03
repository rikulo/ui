//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Aug 3, 2012 12:56:15 AM
//Author: simonpai
part of rikulo_gesture;

/** The callback invoked by [SwipeGesture].
 */
typedef void SwipeGestureAction(SwipeGestureState state);

/** The state of a [SwipeGesture].
 */
class SwipeGestureState extends GestureState {

  SwipeGestureState._(this.gesture, DragGestureState ds) :
  eventTarget = ds.eventTarget, startTime = ds.startTime, time = ds.time,
  startPosition = ds.startPosition, position = ds.position,
  transition = ds.transition, velocity = ds.velocity;

  //@override  
  final EventTarget eventTarget;
  //@override
  final int time;

  /** Retrieve the associated [SwipeGesture].
   */
  final SwipeGesture gesture;
  
  /** The timestamp when the swipe starts.
   */
  final int startTime;
  
  /** The touched/cursor position at the start of swipe.
   */
  final Offset startPosition;
  
  /** The touched/cursor position at the end of swipe.
   */
  final Offset position;
  
  /** The displacement of the touched/cursor position of the swipe.
   */
  final Offset transition;
  
  /** The current estimated velocity of movement.
   */
  final Offset velocity;
}

/** The gesture of a swipe.
 */
class SwipeGesture extends Gesture {
  DragGesture _drag;

  /** Construct a swipe gesture on [owner] with the given callback [swipe].
   */
  SwipeGesture(this.owner, SwipeGestureAction action) {
    _drag = new DragGesture(owner, 
    end: (DragGestureState state) {
      if (action != null)
        action(new SwipeGestureState._(this, state));
    });
  }
  
  /** The element associated with this swipe gesture (never null).
   */
  final Element owner;

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
