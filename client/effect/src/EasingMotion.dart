//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 25, 2012  11:34:48 PM
//Author: simon

/**
 * An easing function, which supplies a position number based on a time from 0 
 * to 1. The return value should be inclusively between 0 and 1.
 */
typedef num EasingFunction(num time);

/**
 * A fixed-duration motion constructed by an EasingFunction and a MotionAction.
 */
class EasingMotion extends _Motion {
  
  final MotionAction action;
  final EasingFunction easing;
  final int duration;
  
  /**
   * Construct an EasingMotion.
   */
  EasingMotion(this.action, [EasingFunction easing, int duration = 500, 
    MotionRunner run, MotionCallback init, MotionCallback end, bool autorun = true]) : 
    this.duration = duration, this.easing = easing, 
    super(run, init, end, autorun);
  
  /**
   * 
   */
  num getEasingValue(num t) => easing != null ? easing(t) : t;
  
  /**
   * 
   */
  void applyMotionAction(num x) => action(x);
  
  bool onRunning(int time, int elapsed, int paused) {
    int curr = Math.min(time - _initTime - paused, duration);
    if (_runner != null && !_runner(time, elapsed, paused))
      return false;
    applyMotionAction(getEasingValue(curr / duration));
    return curr < duration;
  }
  
  /**
   * Skip to the end of motion.
   */
  void skip() {
    super.stop();
    applyMotionAction(1);
  }
  
}
