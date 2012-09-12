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

/** 
 */
class SlideInEffect extends ShowEffect {
  
  /** 
   */
  SlideInEffect(Element element, int size, [int period = 500, bool fade = true, // TODO: direction, align?
  MotionStart start, MotionEnd end, bool autorun = true]) :
  super(element, _slideInAction(element, size, fade), 
  start: start, end: end, period: period, autorun: autorun);
  
  static MotionAction _slideInAction(Element element, int size, bool fade) =>
      (num x, MotionState state) {
    if (fade)
      element.style.opacity = "$x";
    element.style.height = CSS.px((x * size).toInt());
  };
  
}

/** 
 */
class SlideOutEffect extends HideEffect {
  
  /** 
   */
  SlideOutEffect(Element element, [int period = 500, bool fade = true, // TODO: direction, align?
  MotionStart start, MotionEnd end, bool autorun = true]) :
  super(element, _slideOutAction(element, fade), 
  start: start, end: end, period: period, autorun: autorun);
  
  static MotionAction _slideOutAction(Element element, bool fade) {
    final int size = new DOMQuery(element).outerHeight;
    return (num x, MotionState state) {
      if (fade)
        element.style.opacity = "${1-x}";
      element.style.height = CSS.px(((1-x) * size).toInt());
    };
  }
  
}
