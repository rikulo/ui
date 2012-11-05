//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 25, 2012  11:34:48 PM
//Author: simon
part of rikulo_effect;

/** An easing function, which supplies a position number based on a time from 0 
 * to 1. The return value should be inclusively between 0 and 1.
 */
typedef num EasingFunction(num time);

/** The callback type that realizes an abstract position number. 
 */
typedef bool MotionAction(num x, MotionState state);

/** A fixed-duration motion constructed by an EasingFunction and a MotionAction.
 */
class EasingMotion extends Motion {
  
  final MotionAction action;
  final EasingFunction easing;
  final int period, repeat, duration;
  
  /** Construct an EasingMotion.
   * 
   * + [easing] is the easing function. Default: linear.
   * + [period] is how long it takes to bring easing input from 0 to 1, in terms
   * of milliseconds. Default: 500 milliseconds.
   * + [repeat] is the number of times the motion repeats. If negative, the 
   * motion loops forever until [MotionAction] returns false. Default: 1.
   * + [start] is invoked when the motion starts.
   * + [end] is invoked when the motion ends.
   */
  EasingMotion(this.action, {EasingFunction easing, int period: 500, 
    int repeat: 1, MotionStart start, MotionEnd end}) : 
    this.easing = easing, this.period = period, this.repeat = repeat, 
    duration = repeat * period, super(start: start, end: end);
  
  /** Construct an EasingMotion by joining multiple EasingMotion.
   */
  EasingMotion.join(List<EasingMotion> motions, {EasingFunction easing, 
  int period: 500, int repeat: 1, MotionStart start, MotionEnd end}) :
  this(_jointAction(motions), easing: easing, period: period, repeat: repeat,
  start: _jointStart(motions, start), end: _jointEnd(motions, end));
  
  static MotionAction _jointAction(List<EasingMotion> motions) {
    return (num x, MotionState state) {
      for (EasingMotion em in motions)
        if (identical(em.action(x, state), false))
          return false;
    };
  }
  
  static MotionStart _jointStart(List<EasingMotion> motions, MotionStart start) {
    return (MotionState state) {
      if (start != null)
        start(state);
      for (EasingMotion em in motions)
        if (em._start != null)
          em._start(state);
    };
  }
  
  static MotionEnd _jointEnd(List<EasingMotion> motions, MotionEnd end) {
    return (MotionState state) {
      for (EasingMotion em in motions)
        if (em._end != null)
          em._end(state);
      if (end != null)
        end(state);
    };
  }
  
  /** Compute position value by [EasingFunction].
   */
  num doEasing_(num t) => easing != null ? easing(t) : t;
  
  /** Apply the position by [MotionAction];
   */
  bool doAction_(num x, MotionState state) => action(x, state);
  
  bool onMove(MotionState state) {
    final int runningTime = state.runningTime;
    final bool result = doAction_(doEasing_(_easingInput(runningTime)), state);
    return (repeat < 0 || runningTime < duration) && !identical(result, false);
  }
  
  num _easingInput(num runningTime) => 
      (duration < 0 || runningTime < duration) ? (runningTime / period) % 1 : 1;
  
  /** Skip to the end of motion.
   */
  void skip() {
    if (_state != null)
      doAction_(1, _state.._snapshot(new Date.now().millisecondsSinceEpoch));
    super.stop();
  }
  
}
