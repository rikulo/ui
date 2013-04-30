//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Jul 13, 2012  09:32:28 AM
//Author: simon
part of rikulo_effect;

/**
 * An [EasingMotion] with action of move an [Element] along a linear trajectory.
 */
class LinearPathMotion extends EasingMotion {
  
  final Element element;
  final Function _moveCB;
  final Point origin, destination, _diff; 
  Point _pos;
  
  /** Construct a linear position motion.
   * + [element] is the element to move.
   * + [origin] is the starting offset of the element.
   * + [destination] is the goal offset of the movement.
   * + [move] is invoked continuously during the motion, and if this callback is
   * provided, [defaultAction()] shall be called to attain the default 
   * behavior of LinearPathMotion.
   */
  LinearPathMotion(Element element, Point origin, Point destination, 
    {EasingFunction easing, int period: 500, MotionStart start, 
    bool move(MotionState state, Point position, num x, void defaultAction()), 
    MotionEnd end}) :
    this.element = element, this.origin = origin, this.destination = destination, 
    _diff = destination - origin, _moveCB = move, 
    super(null, easing: easing, period: period, start: start, end: end);
  
  bool doAction_(num x, MotionState state) {
    _pos = _diff * x + origin;
    if (_moveCB == null) {
      _applyPosition();
      return true;
    }
    return !identical(_moveCB(state, _pos, x, _applyPosition), false);
  }
  
  void _applyPosition() {
    element.style.left = CssUtil.px(_pos.x);
    element.style.top = CssUtil.px(_pos.y);
  }
  
  /** Retrieve the current position of the element.
   */
  Point get currentPosition => _pos;
  
}
