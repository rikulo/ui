//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Sep 12, 2012 10:53:16 AM
//Author: simonpai

/**
 */
class ShowEffect extends EasingMotion {
  
  /// The element to which this effect applies.
  final Element element;
  
  /** 
   */
  ShowEffect(Element element, MotionAction action, [int period = 500, 
  MotionStart start, MotionEnd end, bool autorun = true]) :
  this.element = element, 
  super(action, start: _showEffectStart(element, action, start), end: end, 
  period: period, autorun: autorun);
  
  // dart2js bug: closure in intializer doesn't compile
  static MotionStart _showEffectStart(Element element, MotionAction action, MotionStart start) =>
      (MotionState state) {
    if (start != null)
      start(state);
    action(0, state);
    new DOMQuery(element).show();
  };
  
}

/**
 */
class HideEffect extends EasingMotion {
  
  /// The element to which this effect applies.
  final Element element;
  
  /** 
   */
  HideEffect(Element element, MotionAction action, [int period = 500, 
  MotionStart start, MotionEnd end, bool autorun = true]) :
  this.element = element, 
  super(action, start: start, end: _hideEffectEnd(element, end), 
  period: period, autorun: autorun);
  
  // dart2js bug: closure in intializer doesn't compile
  static MotionEnd _hideEffectEnd(Element element, MotionEnd end) =>
      (MotionState state) {
    new DOMQuery(element).hide();
    if (end != null)
      end(state);
  };
  
}
