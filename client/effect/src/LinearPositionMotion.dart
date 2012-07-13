//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Jul 13, 2012  09:32:28 AM
//Author: simon

/**
 * An [EasingMotion] with action of moving an [Element] along a linear trajectory.
 */
class LinearPositionMotion extends EasingMotion {
  
  final Element element;
  final Function _movingCB;
  final Offset origin, destination, _diff; 
  Offset _pos;
  
  /** Construct a linear position motion.
   * +[element] is the element to move.
   * +[origin] is the starting offset of the element.
   * +[destination] is the goal offset of the movement.
   */
  LinearPositionMotion(Element element, Offset origin, Offset destination, 
    [EasingFunction easing, mode = "once", int duration = 500, MotionStart start, 
    bool moving(MotionState state, Offset position, num x), 
    MotionEnd end, bool autorun = true]) :
    this.element = element, this.origin = origin, this.destination = destination, 
    _diff = destination - origin, _movingCB = moving, 
    super(null, easing, mode, duration, start, end, autorun);
  
  bool doAction_(num x, MotionState state) {
    _pos = _diff * x + origin;
    element.style.left = CSS.px(_pos.left);
    element.style.top = CSS.px(_pos.top);
    if (_movingCB == null)
      return true;
    bool result = _movingCB(state, _pos, x);
    return result == null || result;
  }
  
  /** Retrieve the current position of the element.
   */
  Offset get currentPosition() => _pos;
  
}
