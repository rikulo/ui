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

/** The dialog information.
 */
class DialogInfo {
  /** The cave node that contains the mask node and the view's node.
   */
  final Element cave;
  /** The mask node. */
  final Element mask;
  DialogInfo(this.cave, this.mask);

  void updateSize() {
    final p = cave.parent;
    final size = p == document.body || p == null ?
      browser.innerSize: new DOMAgent(p).innerSize;
    mask.style
      ..width = CSS.px(size.width)
      ..height = CSS.px(size.height);
  }

}
/** A map of dialog information.
 * If a root view is attached with `mode: "dialog"` (`View.addToDocument`),
 * it will be added to this map automatically.
 */
final Map<View, DialogInfo> dialogInfos = new Map();

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
    final int appid = ViewUtil.appId;
    if (appid > 0)
      uuidPrefix = "${StringUtil.encodeId(appid, 'v')}_";
  }
}
final ViewConfig viewConfig = new ViewConfig();
