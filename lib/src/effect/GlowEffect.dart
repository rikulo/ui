//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Aug 30, 2012 18:31:52 AM
//Author: simonpai

/**
 * A glowing effect to apply on element.
 */
class GlowEffect extends EasingMotion {
  
  /** The element to which this effect applies.
   */
  final Element element;
  
  String _shadowPrefix;
  
  /** Create a GlowEffect of given [period] in milliseconds, which assigns
   * a CSS white shadow on the element.
   * 
   * + [period]: The period of the effect. Default: 1000 milliseconds
   * + [start]: Called when the effect starts.
   * + [end]: Called when the effect ends.
   */
  GlowEffect(Element element, [int period = 1000, num tempo = 0.3, 
  Color color, int blur = 10, int spread = 2, 
  MotionStart start, MotionEnd end, bool autorun = true]) : 
  this.element = element, 
  super(null, start: (MotionState state) {
    if (start != null)
      start(state);
    state.data = element.style.boxShadow;
    
  }, end: (MotionState state) {
    element.style.boxShadow = state.data == null ? "" : state.data;
    if (end != null)
      end(state);
    
  }, period: period, autorun: autorun, 
  easing: (num t) => t < tempo ? (t * t / tempo / tempo) : (1 - t) / (1 - tempo)) {
    
    final int r = color == null ? 255 : color.red.toInt();
    final int g = color == null ? 255 : color.green.toInt();
    final int b = color == null ? 255 : color.blue.toInt();
    _shadowPrefix = "0 0 ${blur}px ${spread}px rgba($r, $g, $b, ";
  }
  
  bool doAction_(num x, MotionState state) {
    element.style.boxShadow = "$_shadowPrefix$x)";
  }
  
}
