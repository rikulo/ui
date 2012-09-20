//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Apr 26, 2012  6:20:13 PM
// Author: tomyeh

/** Returns a DOM-level event listener that converts a DOM event to a view event
 * ([ViewEvent]) and dispatch to the right target.
 */
typedef EventListener DOMEventDispatcher(View target);

/** Utilities for implemnetation.
 */
class ViewImpl {
  /** Called to indicate the width or height is updated by layouts
   * or other internal modules, rather than the application.
   *
   * Once called, [sizedByApp] will return true.
   */
  static void sizedInternally(View view, Dir dir) {
    view.dataAttributes[_sbaAttr(dir)] = _sbaVal(view, dir);
  }
  /** Called to indicate the width or height is updated by the application.
   *
   * Once called, [sizedByApp] will return false.
   */
  static void sizedByApp(View view, Dir dir) {
    view.dataAttributes.remove(_sbaAttr(dir));
  }
  /** Returns true if the width or height is set by the application.
   *
   * + [dir] can be either *HORIZONTAL* or *VERTICAL*. It can't be *BOTH*.
   */
  static bool isSizedByApp(View view, Dir dir) {
    final val = _sbaVal(view, dir);
    return val != null && val != view.dataAttributes[_sbaAttr(dir)];
      //Note: if null is assigned, it is considered as set-internally
  }
  static int _sbaVal(View view, Dir dir)
  => dir == Dir.HORIZONTAL ? view.width: view.height;
  static String _sbaAttr(Dir dir)
  => dir == Dir.HORIZONTAL ? 'rk.layout.hz': 'rk.layout.vt';
}

/**
 * The configuration of views.
 */
class ViewConfig {
  /** The prefix used for the default style class of a view.
   *
   * Default: "v-".
   */
  String classPrefix = "v-";
  /** The prefix used for [View.uuid].
   *
   * Default: an unique string in a window to avoid conficts among
   * multiple Rikulo applications in the same page, if any.
   */
  String uuidPrefix = "v_";

  ViewConfig() {
    final int appid = application.uuid;
    if (appid > 0)
      uuidPrefix = "${StringUtil.encodeId(appid, 'v')}_";
  }
  static final String _PREFIX_COUNT = "data-rikuloPrefixCount";
}
ViewConfig viewConfig;

/** Used with [View]'s `domAttrs_` to control which attributes to generate.
 */
class DOMAttrsCtrl {
  bool noId, noStyle, noClass, noVisible, noDraggable;

  DOMAttrsCtrl([bool this.noId=false, bool this.noStyle=false,
    bool this.noClass=false, bool this.noVisible=false, bool this.noDraggable=false]);
}
/** Used with [View]'s `domStyle_` to control which styles to generate.
 */
class DOMStyleCtrl {
  bool noLeft, noTop, noWidth, noHeight, noStyle, noVisible;

  DOMStyleCtrl([bool this.noLeft=false, bool this.noTop=false,
    bool this.noWidth=false, bool this.noHeight=false,
    bool this.noStyle=false, bool this.noVisible=false]);
}