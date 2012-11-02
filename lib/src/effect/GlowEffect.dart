//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Aug 30, 2012 18:31:52 AM
//Author: simonpai
part of rikulo_effect;

/**
 * A glowing effect to apply on element.
 */
class GlowEffect extends EasingMotion {
  
  /** The element to which this effect applies.
   */
  final Element element;
  
  /** Create a GlowEffect of given [period] in milliseconds, which assigns
   * a CSS white shadow on the element.
   * 
   * + [period]: The period of the effect. Default: 1000 milliseconds
   * + [start]: Called when the effect starts.
   * + [end]: Called when the effect ends.
   */
  GlowEffect(Element element, {int period: 1000, num tempo: 0.3, 
  Color color, int blur: 10, int spread: 2, MotionStart start, MotionEnd end}) : 
  this.element = element, 
  super(createAction(element, color, blur, spread), start: (MotionState state) {
    if (start != null)
      start(state);
    state.data = element.style.boxShadow;
    
  }, end: (MotionState state) {
    element.style.boxShadow = state.data == null ? "" : state.data;
    if (end != null)
      end(state);
    
  }, period: period, 
  easing: (num t) => t < tempo ? (t * t / tempo / tempo) : (1 - t) / (1 - tempo));
  
  /** Create a glowing MotionAction by applying a color shadow on [element].
   */
  static MotionAction createAction(Element element, Color color, int blur, int spread) {
    final int r = color == null ? 255 : color.red.toInt();
    final int g = color == null ? 255 : color.green.toInt();
    final int b = color == null ? 255 : color.blue.toInt();
    final String pref = "0 0 ${blur}px ${spread}px rgba($r, $g, $b, ";
    return (num x, MotionState state) {
      element.style.boxShadow = "$pref$x)";
    };
  }
  
}
