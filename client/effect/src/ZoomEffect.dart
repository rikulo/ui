//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Sep 12, 2012 10:53:16 AM
//Author: simonpai

/** 
 */
class ZoomInEffect extends ShowEffect {
  
  /** 
   */
  ZoomInEffect(Element element, [int period = 500, bool fade = true, 
  MotionStart start, MotionEnd end, bool autorun = true]) : 
  super(element, _zoomInAction(element, fade), 
  start: start, end: end, period: period, autorun: autorun);
  
  // dart2js bug: closure in intializer doesn't compile
  static MotionAction _zoomInAction(Element element, bool fade) =>
      (num x, MotionState state) {
    if (fade)
      element.style.opacity = "$x";
    element.style.transform = "scale($x)";
  };
  
}

/** 
 */
class ZoomOutEffect extends HideEffect {
  
  /** 
   */
  ZoomOutEffect(Element element, [int period = 500, bool fade = true, 
  MotionStart start, MotionEnd end, bool autorun = true]) : 
  super(element, _zoomOutAction(element, fade), 
  start: start, end: end, period: period, autorun: autorun);
  
  // dart2js bug: closure in intializer doesn't compile
  static MotionAction _zoomOutAction(Element element, bool fade) =>
      (num x, MotionState state) {
    if (fade)
      element.style.opacity = "${1-x}";
    element.style.transform = "scale(${1-x})";
  };
  
}
