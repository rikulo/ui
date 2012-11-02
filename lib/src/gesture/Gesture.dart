//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Aug 16, 2012 15:54:31 AM
//Author: simonpai
part of rikulo_gesture;

/** The common interface of gestures.
 */
abstract class Gesture {
  
  /** Destroy the gesture. It shall be called to clean up, if it is no longer 
   * in use.
   */
  void destroy();
  
  /** Disable the gesture. The current action will be immediately stopped, if
   * any.
   */
  void disable();
  
  /** Enable the gesture. */
  void enable();
  
  /** Stop the current action, if any. */
  void stop();
}

/** The common interface of state of [Gesture].
 */
abstract class GestureState {
  
  /** The latest timestamp of gesture. */
  int get time;
  
  /** The element which receives the event. */
  EventTarget get eventTarget;
  
  /** Custom data. It is useful if you'd like to store something that
   * will be cleaned up automatically when the gesture is finished.
   */
  var data;
}
