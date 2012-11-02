//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Aug 30, 2012 18:31:52 AM
//Author: simonpai
part of rikulo_effect;

/**
 * A shaking effect implemented with CSS rotation on the element.
 */
class ShakeEffect extends EasingMotion {
  
  /** The element to which this effect applies.
   */
  final Element element;
  
  /** Create a ShakeEffect.
   * 
   * + [period]: The period of the effect in terms of millisecond. Default: 500 milliseconds.
   * + [repeat]: The number of times the effect repeats.
   * + [rotation]: The range of rotation in CSS transformation. Default: 10 degree.
   * + [start]: Called when the effect starts.
   * + [end]: Called when the effect ends.
   */
  ShakeEffect(Element element, {int period: 500, int repeat: 1, num rotation: 10,
  MotionStart start, MotionEnd end}) : 
  this.element = element, 
  super(createAction(element, rotation), start: (MotionState state) {
    if (start != null)
      start(state);
    state.data = element.style.transform;
    
  }, end: (MotionState state) {
    element.style.transform = state.data == null ? "" : state.data;
    if (end != null)
      end(state);
    
  }, period: period, repeat: repeat, easing: (num t) => -sin(t * PI * 2));
  
  /** Create a MotionAction which applies CSS rotation to [element].
   */
  static MotionAction createAction(Element element, num rotation) {
    return (num x, MotionState state) {
      element.style.transform = "rotate(${rotation * x}deg)";
    };
  }
  
}
