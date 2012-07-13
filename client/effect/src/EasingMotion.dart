//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 25, 2012  11:34:48 PM
//Author: simon

/** An easing function, which supplies a position number based on a time from 0 
 * to 1. The return value should be inclusively between 0 and 1.
 */
typedef num EasingFunction(num time);

/** The callback type that realizes an abstract position number. 
 */
typedef bool MotionAction(num x);

/** A fixed-duration motion constructed by an EasingFunction and a MotionAction.
 */
class EasingMotion extends Motion {
  
  // TODO: support mode: run-once, alternate, repeat
  final MotionAction action;
  final EasingFunction easing;
  final int duration;
  
  /** Construct an EasingMotion.
   */
  EasingMotion(this.action, [EasingFunction easing, int duration = 500, 
    MotionStart start, MotionEnd end, bool autorun = true]) : 
    this.duration = duration, this.easing = easing, 
    super(start, null, end, autorun);
  
  /** Compute position value by [EasingFunction].
   */
  num doEasing_(num t) => easing != null ? easing(t) : t;
  
  /** Apply the position by [MotionAction];
   */
  bool doAction_(num x, MotionState state) => action(x);
  
  bool onMoving(MotionState state) {
    int curr = Math.min(state.runningTime, duration);
    final bool result = doAction_(doEasing_(curr / duration), state);
    return curr < duration && (result == null || result);
  }
  
  /** Skip to the end of motion.
   */
  void skip() {
    if (_state != null) {
      final int t = new Date.now().millisecondsSinceEpoch;
      _state._snapshot(t, t - _state.currentTime);
      doAction_(1, _state);
    }
    super.stop();
  }
  
}
