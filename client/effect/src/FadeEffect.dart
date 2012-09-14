//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Sep 12, 2012 10:53:16 AM
//Author: simonpai

/**
 */
class FadeInEffect extends ShowEffect {
  
  /** 
   */
  FadeInEffect(Element element, [int period = 500, 
  MotionStart start, MotionEnd end, bool autorun = true]) : 
  super(element, _fadeInAction(element), 
  start: start, end: end, period: period, autorun: autorun);
  
  // dart2js bug: closure in intializer doesn't compile
  static MotionAction _fadeInAction(Element element) =>
      (num x, MotionState state) { element.style.opacity = "$x"; };
  
}

/**
 */
class FadeOutEffect extends HideEffect {
  
  /**
   */
  FadeOutEffect(Element element, [int period = 500, 
  MotionStart start, MotionEnd end, bool autorun = true]) : 
  super(element, _fadeOutAction(element), 
  start: start, end: end, period: period, autorun: autorun);
  
  // dart2js bug: closure in intializer doesn't compile
  static MotionAction _fadeOutAction(Element element) =>
      (num x, MotionState state) { element.style.opacity = "${1-x}"; };
  
}

