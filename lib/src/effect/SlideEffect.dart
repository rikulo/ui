//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Sep 12, 2012 10:53:16 AM
//Author: simonpai
part of rikulo_effect;

/** The constant objects to represent the direction of [SlideInEffect] and
 * [SlideOutEffect].
 */
class SlideDirection {
  /** The name of the slide direction. */
  final String name;
  const SlideDirection._(this.name);
  
  String toString() => name;
  
  /// North (top) side of the element.
  static const SlideDirection NORTH = const SlideDirection._("North");
  
  /// South (bottom) side of the element.
  static const SlideDirection SOUTH = const SlideDirection._("South");
  
  /// West (left) side of the element.
  static const SlideDirection WEST = const SlideDirection._("West");
  
  /// East (right) side of the element.
  static const SlideDirection EAST = const SlideDirection._("East");
  
}

/** A slide-in effect. See also [ShowEffect].
 */
class SlideInEffect extends ShowEffect {
  
  /** Create a slide-in effect on the [element].
   */
  SlideInEffect(Element element, {int size, int period: 500, EasingFunction easing, 
  bool fade: true, SlideDirection direction: SlideDirection.NORTH,
  MotionStart start, MotionEnd end}) :
  super(element, createAction(element, size, fade, direction), 
  start: start, end: end, period: period, easing: easing);
  
  /** Create a MotionAction for slide-in effect on the [element].
   */
  static MotionAction createAction(Element element, int size, bool fade, SlideDirection dir) {
    switch (dir) {
      case SlideDirection.EAST:
        final int destSize = size != null ? size : _SlideEffectUtil.widthOf(element);
        final int initLeft = _SlideEffectUtil.leftOf(element) + destSize;
        return (num x, MotionState state) {
          final int w = (x * destSize).toInt();
          element.style.left = Css.px(initLeft - w);
          element.style.width = Css.px(w);
          if (fade)
            element.style.opacity = "$x";
        };
      case SlideDirection.WEST:
        final int destSize = size != null ? size : _SlideEffectUtil.widthOf(element);
        return (num x, MotionState state) {
          element.style.width = Css.px((x * destSize).toInt());
          if (fade)
            element.style.opacity = "$x";
        };
      case SlideDirection.SOUTH:
        final int destSize = size != null ? size : _SlideEffectUtil.heightOf(element);
        final int initTop = _SlideEffectUtil.topOf(element) + destSize;
        return (num x, MotionState state) {
          final int h = (x * destSize).toInt();
          element.style.top = Css.px(initTop - h);
          element.style.height = Css.px(h);
          if (fade)
            element.style.opacity = "$x";
        };
      case SlideDirection.NORTH:
      default:
        final int destSize = size != null ? size : _SlideEffectUtil.heightOf(element);
        return (num x, MotionState state) {
          element.style.height = Css.px((x * destSize).toInt());
          if (fade)
            element.style.opacity = "$x";
        };
    }
  }
  
}

/** A slide-out effect. See also [HideEffect].
 */
class SlideOutEffect extends HideEffect {
  
  /** Create a slide-out effect on the given [element].
   */
  SlideOutEffect(Element element, {int period: 500, EasingFunction easing, 
  bool fade: true, SlideDirection direction: SlideDirection.NORTH,
  MotionStart start, MotionEnd end}) :
  super(element, createAction(element, fade, direction), 
  start: start, end: end, period: period, easing: easing);
  
  /** Create a MotionAction for slide-out effect on the [element].
   */
  static MotionAction createAction(Element element, bool fade, SlideDirection dir) {
    switch (dir) {
      case SlideDirection.EAST:
        final int size = new DomAgent(element).width;
        final int initLeft = new DomAgent(element).offsetLeft;
        return (num x, MotionState state) {
          final int w = (x * size).toInt();
          element.style.left = Css.px(initLeft + w);
          element.style.width = Css.px(size - w);
          if (fade)
            element.style.opacity = "${1-x}";
        };
      case SlideDirection.WEST:
        final int size = new DomAgent(element).width;
        return (num x, MotionState state) {
          element.style.width = Css.px(((1-x) * size).toInt());
          if (fade)
            element.style.opacity = "${1-x}";
        };
      case SlideDirection.SOUTH:
        final int size = new DomAgent(element).height;
        final int initTop = new DomAgent(element).offsetTop;
        return (num x, MotionState state) {
          final int h = (x * size).toInt();
          element.style.top = Css.px(initTop + h);
          element.style.height = Css.px(size - h);
          if (fade)
            element.style.opacity = "${1-x}";
        };
      case SlideDirection.NORTH:
      default:
        final int size = new DomAgent(element).height;
        return (num x, MotionState state) {
          element.style.height = Css.px(((1-x) * size).toInt());
          if (fade)
            element.style.opacity = "${1-x}";
        };
    }
  }
  
}

class _SlideEffectUtil {
  
  static int leftOf(Element element) => 
      _valueOf(element, element.style.left, (DomAgent dq) => dq.offsetLeft);
  
  static int topOf(Element element) => 
      _valueOf(element, element.style.top, (DomAgent dq) => dq.offsetTop);
  
  static int widthOf(Element element) => 
      _valueOf(element, element.style.width, (DomAgent dq) => dq.width);
  
  static int heightOf(Element element) => 
      _valueOf(element, element.style.height, (DomAgent dq) => dq.height);
  
  static int _valueOf(Element elem, String stxt, int f(DomAgent dq)) => 
      stxt != null && stxt.endsWith("px") ? Css.intOf(stxt) : f(new DomAgent(elem));
  
}
