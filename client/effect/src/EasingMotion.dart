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
  
  final MotionAction action;
  final EasingFunction easing;
  final String mode;
  final int duration;
  
  /** Construct an EasingMotion.
   */
  EasingMotion(this.action, [EasingFunction easing, String mode = "once", 
    int duration = 500, MotionStart start, MotionEnd end, bool autorun = true]) : 
    this.mode = mode, this.duration = duration, this.easing = easing, 
    super(start, null, end, autorun);
  
  /** Compute position value by [EasingFunction].
   */
  num doEasing_(num t) => easing != null ? easing(t) : t;
  
  /** Apply the position by [MotionAction];
   */
  bool doAction_(num x, MotionState state) => action(x);
  
  bool onMove(MotionState state) {
    int curr = _easingInput(state.runningTime);
    final bool result = doAction_(doEasing_(curr / duration), state);
    return (mode == "alternate" || mode == "repeat" || curr < duration) && (result == null || result);
  }
  
  num _easingInput(num runningTime) {
    switch(mode) {
      case "alternate":
        final num d2 = 2 * duration;
        final num t = runningTime % d2;
        return t <= duration ? t : d2 - t;
      case "repeat":
        return runningTime % duration;
      case "once":
      default:
        return Math.min(runningTime, duration);
    }
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
