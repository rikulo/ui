//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Sep 12, 2012 10:53:16 AM
//Author: simonpai
part of rikulo_effect;

/** A skeleton implementation of transition effect to show an element. It is
 * assumed the element's CSS visibility attribute is 'hidden' before the effect 
 * starts, and the element will be shown when the effect ends.
 */
class ShowEffect extends EasingMotion {
  
  /// The element to which this effect applies.
  final Element element;
  
  /** Create an effect on [element] that applies [action] with easing input
   * value from 0 to 1. The element's CSS visibility attribute will be set to
   * 'visible' at the very beginning of the effect.
   * 
   * + [period] determines how long the effect will take.
   * + [easing] the easing function of the effect
   * + [start] is called when the effect starts.
   * + [end] is called when the effect ends.
   */
  ShowEffect(Element element, MotionAction action, {int period: 500, 
  EasingFunction easing, MotionStart start, MotionEnd end}) :
  this.element = element, 
  super(action, start: _showEffectStart(element, action, start), end: end, 
  period: period, easing: easing);
  
  // dart2js bug: closure in intializer doesn't compile
  static MotionStart _showEffectStart(Element element, MotionAction action, MotionStart start) {
    return (MotionState state) {
      if (start != null)
        start(state);
      action(0, state);
      element.style.visibility = "";
    };
  }
  
}

/** A skeleton implementation of transition effect to show an element. It is 
 * assumed the element's CSS visibility attribute is 'visible' (default value) 
 * before the effect starts, and the element will be hidden when the effect ends.
 */
class HideEffect extends EasingMotion {
  
  /// The element to which this effect applies.
  final Element element;
  
  /** Create an effect on [element] that applies [action] with easing input
   * value from 0 to 1. The element's CSS visibility attribute will be set to 
   * 'hidden' when the effect ends.
   * 
   * + [period] determines how long the effect will take.
   * + [easing] the easing function of the effect
   * + [start] is called when the effect starts.
   * + [end] is called when the effect ends.
   */
  HideEffect(Element element, MotionAction action, {int period: 500, 
  EasingFunction easing, MotionStart start, MotionEnd end}) :
  this.element = element, 
  super(action, start: start, end: _hideEffectEnd(element, action, end), 
  period: period, easing: easing);
  
  // dart2js bug: closure in intializer doesn't compile
  static MotionEnd _hideEffectEnd(Element element, MotionAction action, MotionEnd end) {
    return (MotionState state) {
      element.style.visibility = 'hidden';
      action(0, state);
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
  FadeInEffect(Element element, {int period: 500, EasingFunction easing,
  num minOpacity: 0, num maxOpacity: 1, MotionStart start, MotionEnd end}) :
  super(element, createAction(element, minOpacity, maxOpacity), 
  start: start, end: end, period: period, easing: easing);
  
  /** Create a MotionAction for fade-in effect on the [element].
   */
  static MotionAction createAction(Element element, num min, num max) {
    final num diff = max - min;
    return (num x, MotionState state) {
      element.style.opacity = "${min + diff * x}";
    };
  }
  
}

/** A fade-out effect. See also [HideEffect].
 */
class FadeOutEffect extends HideEffect {
  
  /** Create a fade-out effect on the [element].
   */
  FadeOutEffect(Element element, {int period: 500, EasingFunction easing, 
  num minOpacity: 0, num maxOpacity: 1, MotionStart start, MotionEnd end}) : 
  super(element, createAction(element, minOpacity, maxOpacity), 
  start: start, end: end, period: period, easing: easing);
  
  /** Create a MotionAction for fade-out effect on the [element].
   */
  static MotionAction createAction(Element element, num min, num max) {
    final num diff = max - min;
    return (num x, MotionState state) {
      element.style.opacity = "${max - diff * x}";
    };
  }
  
}

/** A zoom-in effect to show an element. See [ShowEffect].
 */
class ZoomInEffect extends ShowEffect {
  
  /** Create a zoom-in effect on the [element].
   */
  ZoomInEffect(Element element, {int period: 500, EasingFunction easing, 
  bool fade: true, MotionStart start, MotionEnd end}) : 
  super(element, createAction(element, fade), 
  start: start, end: end, period: period, easing: easing);
  
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
  ZoomOutEffect(Element element, {int period: 500, EasingFunction easing, 
  bool fade: true, MotionStart start, MotionEnd end}) : 
  super(element, createAction(element, fade), 
  start: start, end: end, period: period, easing: easing);
  
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
