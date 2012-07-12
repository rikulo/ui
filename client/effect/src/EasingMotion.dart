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
class EasingMotion extends Motion {
  
  // TODO: support mode: run-once, alternate, repeat
  final MotionAction action;
  final EasingFunction easing;
  final int duration;
  
  /**
   * Construct an EasingMotion.
   */
  EasingMotion(this.action, [EasingFunction easing, int duration = 500, 
    MotionStart start, MotionMoving moving, MotionEnd end, bool autorun = true]) : 
    this.duration = duration, this.easing = easing, 
    super(start, moving, end, autorun);
  
  /**
   * 
   */
  num getEasingValue(num t) => easing != null ? easing(t) : t;
  
  /**
   * 
   */
  void applyMotionAction(num x) => action(x);
  
  bool onMoving(int time, int elapsed, int paused) {
    int curr = Math.min(time - _startTime - paused, duration);
    if (_movingCB != null && !_movingCB(time, elapsed, paused)) // TODO: null should be true
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
