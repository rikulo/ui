//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Aug 30, 2012 18:31:52 AM
//Author: simonpai

/**
 * A vibration effect to apply on element.
 */
class BuzzEffect extends EasingMotion {
  
  /** The element to which this effect applies.
   */
  final Element element;
  
  /** Create a BuzzEffect of given [duration] in milliseconds. During the effect,
   * the element will be given a CSS tranformation of random roation and 
   * transition, bounded by [rotation] (in degree) and [movement] (in pixel).
   * 
   * + [duration]: The duration of the effect. Default: 500 milliseconds
   * + [movement]: The range of transition in CSS transformation. Default: 3 px
   * + [rotation]: The range of rotation in CSS transformation. Defautl: 3 degree
   * + [start]: Called when the effect starts.
   * + [end]: Called when the effect ends.
   */
  BuzzEffect(Element element, [int period = 500, num movement = 3, num rotation = 3, 
  MotionStart start, MotionEnd end, bool autorun = true]) : 
  this.element = element, 
  super((num x, MotionState state) {
    element.style.transform = CSS.transform(_randomTransform(movement, rotation));
    
  }, start: (MotionState state) {
    if (start != null)
      start(state);
    state.data = element.style.transform;
    
  }, end: (MotionState state) {
    element.style.transform = state.data == null ? "" : state.data;
    if (end != null)
      end(state);
    
  }, period: period, autorun: autorun);
  
  static Random _rand;
  static num nextDouble(num max) {
    if (_rand == null)
      _rand = new Random();
    return (_rand.nextDouble() * 2 - 1) * max;
  }
  
  static Transformation _randomTransform(num move, num angle) {
    final num mx = nextDouble(move), my = nextDouble(move);
    final num a = nextDouble(angle * PI / 180), ca = cos(a), sa = sin(a);
    return new Transformation(ca, -sa, mx, sa, ca, my);
  }
  
}
