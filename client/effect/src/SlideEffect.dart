//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Sep 12, 2012 10:53:16 AM
//Author: simonpai

/** The constant objects to represent the direction of [SlideInEffect] and
 * [SlideOutEffect].
 */
class SlideDirection {
  
  final String _name;
  
  const SlideDirection._init(this._name);
  
  String toString() => _name;
  
  /// North (top) side of the element.
  static const SlideDirection NORTH = const SlideDirection._init("North");
  
  /// South (bottom) side of the element.
  static const SlideDirection SOUTH = const SlideDirection._init("South");
  
  /// West (left) side of the element.
  static const SlideDirection WEST = const SlideDirection._init("West");
  
  /// East (right) side of the element.
  static const SlideDirection EAST = const SlideDirection._init("East");
  
}

/** A slide-in effect. See also [ShowEffect].
 */
class SlideInEffect extends ShowEffect {
  
  /** Create a slide-in effect on the [element].
   */
  SlideInEffect(Element element, [int size, int period = 500, EasingFunction easing, 
  bool fade = true, SlideDirection direction = SlideDirection.NORTH,
  MotionStart start, MotionEnd end, bool autorun = true]) :
  super(element, createAction(element, size, fade, direction), 
  start: start, end: end, period: period, easing: easing, autorun: autorun);
  
  /** Create a MotionAction for slide-in effect on the [element].
   */
  static MotionAction createAction(Element element, int size, bool fade, SlideDirection dir) {
    switch (dir) {
      case SlideDirection.EAST:
        final int destSize = size != null ? size : _SlideEffectUtil.widthOf(element);
        final int initLeft = _SlideEffectUtil.leftOf(element) + destSize;
        return (num x, MotionState state) {
          final int w = (x * destSize).toInt();
          element.style.left = CSS.px(initLeft - w);
          element.style.width = CSS.px(w);
          if (fade)
            element.style.opacity = "$x";
        };
      case SlideDirection.WEST:
        final int destSize = size != null ? size : _SlideEffectUtil.widthOf(element);
        return (num x, MotionState state) {
          element.style.width = CSS.px((x * destSize).toInt());
          if (fade)
            element.style.opacity = "$x";
        };
      case SlideDirection.SOUTH:
        final int destSize = size != null ? size : _SlideEffectUtil.heightOf(element);
        final int initTop = _SlideEffectUtil.topOf(element) + destSize;
        return (num x, MotionState state) {
          final int h = (x * destSize).toInt();
          element.style.top = CSS.px(initTop - h);
          element.style.height = CSS.px(h);
          if (fade)
            element.style.opacity = "$x";
        };
      case SlideDirection.NORTH:
      default:
        final int destSize = size != null ? size : _SlideEffectUtil.heightOf(element);
        return (num x, MotionState state) {
          element.style.height = CSS.px((x * destSize).toInt());
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
  SlideOutEffect(Element element, [int period = 500, EasingFunction easing, 
  bool fade = true, SlideDirection direction = SlideDirection.NORTH,
  MotionStart start, MotionEnd end, bool autorun = true]) :
  super(element, createAction(element, fade, direction), 
  start: start, end: end, period: period, easing: easing, autorun: autorun);
  
  /** Create a MotionAction for slide-out effect on the [element].
   */
  static MotionAction createAction(Element element, bool fade, SlideDirection dir) {
    switch (dir) {
      case SlideDirection.EAST:
        final int size = new DOMQuery(element).outerWidth;
        final int initLeft = new DOMQuery(element).offsetLeft;
        return (num x, MotionState state) {
          final int w = (x * size).toInt();
          element.style.left = CSS.px(initLeft + w);
          element.style.width = CSS.px(size - w);
          if (fade)
            element.style.opacity = "${1-x}";
        };
      case SlideDirection.WEST:
        final int size = new DOMQuery(element).outerWidth;
        return (num x, MotionState state) {
          element.style.width = CSS.px(((1-x) * size).toInt());
          if (fade)
            element.style.opacity = "${1-x}";
        };
      case SlideDirection.SOUTH:
        final int size = new DOMQuery(element).outerHeight;
        final int initTop = new DOMQuery(element).offsetTop;
        return (num x, MotionState state) {
          final int h = (x * size).toInt();
          element.style.top = CSS.px(initTop + h);
          element.style.height = CSS.px(size - h);
          if (fade)
            element.style.opacity = "${1-x}";
        };
      case SlideDirection.NORTH:
      default:
        final int size = new DOMQuery(element).outerHeight;
        return (num x, MotionState state) {
          element.style.height = CSS.px(((1-x) * size).toInt());
          if (fade)
            element.style.opacity = "${1-x}";
        };
    }
  }
  
}

class _SlideEffectUtil {
  
  static int leftOf(Element element) => 
      _valueOf(element, element.style.left, (DOMQuery dq) => dq.offsetLeft);
  
  static int topOf(Element element) => 
      _valueOf(element, element.style.top, (DOMQuery dq) => dq.offsetTop);
  
  static int widthOf(Element element) => 
      _valueOf(element, element.style.width, (DOMQuery dq) => dq.outerWidth);
  
  static int heightOf(Element element) => 
      _valueOf(element, element.style.height, (DOMQuery dq) => dq.outerHeight);
  
  static int _valueOf(Element elem, String stxt, int f(DOMQuery dq)) => 
      stxt != null && stxt.endsWith("px") ? CSS.intOf(stxt) : f(new DOMQuery(elem));
  
}
