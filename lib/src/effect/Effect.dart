//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Sep 12, 2012 10:53:16 AM
//Author: simonpai

/** A skeleton implementation of transition effect to show an element. It is
 * assumed the element is hidden before the effect starts, and the element will
 * be shown when the effect ends.
 */
class ShowEffect extends EasingMotion {
  
  /// The element to which this effect applies.
  final Element element;
  
  /** Create an effect on [element] that applies [action] with easing input
   * value from 0 to 1. The element will be shown at the very beginning of the
   * effect.
   * 
   * + [period] determines how long the effect will take.
   * + [easing] the easing function of the effect
   * + [start] is called when the effect starts.
   * + [end] is called when the effect ends.
   */
  ShowEffect(Element element, MotionAction action, [int period = 500, 
  EasingFunction easing, MotionStart start, MotionEnd end, bool autorun = true]) :
  this.element = element, 
  super(action, start: _showEffectStart(element, action, start), end: end, 
  period: period, easing: easing, autorun: autorun);
  
  // dart2js bug: closure in intializer doesn't compile
  static MotionStart _showEffectStart(Element element, MotionAction action, MotionStart start) {
    return (MotionState state) {
      if (start != null)
        start(state);
      action(0, state);
      new DOMQuery(element).show();
    };
  }
  
}

/** A skeleton implementation of transition effect to show an element. It is 
 * assuemd the element is visible before the effect starts, and the element
 * will be hidden when the effect ends.
 */
class HideEffect extends EasingMotion {
  
  /// The element to which this effect applies.
  final Element element;
  
  /** Create an effect on [element] that applies [action] with easing input
   * value from 0 to 1. The element will be hidden when the effect ends.
   * 
   * + [period] determines how long the effect will take.
   * + [easing] the easing function of the effect
   * + [start] is called when the effect starts.
   * + [end] is called when the effect ends.
   */
  HideEffect(Element element, MotionAction action, [int period = 500, 
  EasingFunction easing, MotionStart start, MotionEnd end, bool autorun = true]) :
  this.element = element, 
  super(action, start: start, end: _hideEffectEnd(element, end), 
  period: period, easing: easing, autorun: autorun);
  
  // dart2js bug: closure in intializer doesn't compile
  static MotionEnd _hideEffectEnd(Element element, MotionEnd end) {
    return (MotionState state) {
      new DOMQuery(element).hide();
      if (end != null)
        end(state);
    };
  }
  
}

/** A fade-in effect. See also [ShowEffect].
 */
class FadeInEffect extends ShowEffect {
  
  /** Create a fade-in effect on the [element].
   */
  FadeInEffect(Element element, [int period = 500, EasingFunction easing,
  MotionStart start, MotionEnd end, bool autorun = true]) : 
  super(element, createAction(element), 
  start: start, end: end, period: period, easing: easing, autorun: autorun);
  
  /** Create a MotionAction for fade-in effect on the [element].
   */
  static MotionAction createAction(Element element) {
    return (num x, MotionState state) {
      element.style.opacity = "$x";
    };
  }
  
}

/** A fade-out effect. See also [HideEffect].
 */
class FadeOutEffect extends HideEffect {
  
  /** Create a fade-out effect on the [element].
   */
  FadeOutEffect(Element element, [int period = 500, EasingFunction easing, 
  MotionStart start, MotionEnd end, bool autorun = true]) : 
  super(element, createAction(element), 
  start: start, end: end, period: period, easing: easing, autorun: autorun);
  
  /** Create a MotionAction for fade-out effect on the [element].
   */
  static MotionAction createAction(Element element) {
    return (num x, MotionState state) {
      element.style.opacity = "${1-x}";
    };
  }
  
}

/** A zoom-in effect to show an element. See [ShowEffect].
 */
class ZoomInEffect extends ShowEffect {
  
  /** Create a zoom-in effect on the [element].
   */
  ZoomInEffect(Element element, [int period = 500, EasingFunction easing, 
  bool fade = true, MotionStart start, MotionEnd end, bool autorun = true]) : 
  super(element, createAction(element, fade), 
  start: start, end: end, period: period, easing: easing, autorun: autorun);
  
  /** Create a MotionAction for zoom-in effect on the [element], with optional
   * fade-in if [fade] is true.
   */
  static MotionAction createAction(Element element, bool fade) {
    return (num x, MotionState state) {
      element.style.transform = "scale($x)";
      if (fade)
        element.style.opacity = "$x";
    };
  }
  
}

/** A zoom-out effect to hide an element. See [HideEffect].
 */
class ZoomOutEffect extends HideEffect {
  
  /** Create a zoom-out effect on the [element].
   */
  ZoomOutEffect(Element element, [int period = 500, EasingFunction easing, 
  bool fade = true, MotionStart start, MotionEnd end, bool autorun = true]) : 
  super(element, createAction(element, fade), 
  start: start, end: end, period: period, easing: easing, autorun: autorun);
  
  /** Create a MotionAction for zoom-out effect on the [element], with optional
   * fade-out if [fade] is true.
   */
  static MotionAction createAction(Element element, bool fade) {
    return (num x, MotionState state) {
      element.style.transform = "scale(${1-x})";
      if (fade)
        element.style.opacity = "${1-x}";
    };
  }
  
}
