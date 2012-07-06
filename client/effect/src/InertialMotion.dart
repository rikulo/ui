//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 25, 2012  11:34:48 PM
//Author: simon

/**
 * A constant deceleration motion.
 */
class InertialMotion extends Motion {
  
  final Element element;
  final num deceleration;
  final Offset _direction;
  num _speed;
  Offset _pos;
  
  /**
   * Construct an InertialMotion.
   */
  InertialMotion(this.element, Offset velocity, [num deceleration = 0.0005, 
      MotionCallback start, MotionRunner moving, MotionCallback end, bool autorun = true]) : 
        _speed = VectorUtil.norm(velocity),
        _direction = velocity / VectorUtil.norm(velocity), // TODO: stupid, but what's a better way
        this.deceleration = deceleration, 
        super(start, moving, end, autorun);
  
  /**
   * Return the direction of this motion.
   */
  Offset get direction() => _direction;
  
  num get speed() => _speed;
  
  Offset get position() => _pos;
  
  /**
   * Override this function to determine updated speed.
   */
  num updateSpeed(int time, int elapsed, int paused) {
    return _speed - deceleration * elapsed;
  }
  
  /**
   * Override this function to determine updated position.
   */
  Offset updatePosition(int time, int elapsed, int paused) {
    return _pos += _direction * _speed * elapsed;
  }
  
  /**
   * Override this function to determine how new position is applied on the element.
   */
  void applyPosition(Offset pos) { // TODO: transform way
    element.style.left = CSS.px(pos.x);
    element.style.top = CSS.px(pos.y);
  }
  
  void onStart(int time, int elapsed) {
    _pos = new DOMQuery(element).offset;
    super.onStart(time, elapsed);
  }
  
  bool onMoving(int time, int elapsed, int paused) {
    if (_movingCB != null && !_movingCB(time, elapsed, paused))
      return false;
    applyPosition(updatePosition(time, elapsed, paused));
    _speed = updateSpeed(time, elapsed, paused);
    return _speed > 0;
  }
  
}
