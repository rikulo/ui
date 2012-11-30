//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Apr 26, 2012  6:20:13 PM
// Author: tomyeh
part of rikulo_view_impl;

/** Utilities for implemnetation.
 */
class ViewImpl {
  ///Clears the width set by layout handler, if any
  static void clearWidthByLayout(View view) {
    if (!ViewImpl.isWidthByApp(view))
      view.width = null;
  }
  ///Clears the width set by layout handler, if any
  static void clearHeightByLayout(View view) {
    if (!ViewImpl.isHeightByApp(view))
      view.height = null;
  }
  /** Called to indicate the view's left has been changed.
   * It is called automatically if [View]'s left has been set.
   */
  static void leftUpdated(View view) {
    final nm = _sbaAttr(0);
    if (layoutManager.inLayout)
      view.dataAttributes[nm] = _sbaVal(view, 0);
    else
      view.dataAttributes.remove(nm);
  }
  /** Called to indicate the view's top has been changed.
   * It is called automatically if [View]'s top has been set.
   */
  static void topUpdated(View view) {
    final nm = _sbaAttr(1);
    if (layoutManager.inLayout)
      view.dataAttributes[nm] = _sbaVal(view, 1);
    else
      view.dataAttributes.remove(nm);
  }
  /** Called to indicate the view's width has been changed.
   * It is called automatically if [View]'s width has been set.
   */
  static void widthUpdated(View view) {
    final nm = _sbaAttr(2);
    if (layoutManager.inLayout)
      view.dataAttributes[nm] = _sbaVal(view, 2);
    else
      view.dataAttributes.remove(nm);
  }
  /** Called to indicate the view's height has been changed.
   * It is called automatically if [View]'s height has been set.
   */
  static void heightUpdated(View view) {
    final nm = _sbaAttr(3);
    if (layoutManager.inLayout)
      view.dataAttributes[nm] = _sbaVal(view, 3);
    else
      view.dataAttributes.remove(nm);
  }
  /** Returns true if [View]'s left is set by the application.
   */
  static bool isLeftByApp(View view) {
    final v1 = _sbaVal(view, 0), v2 = view.dataAttributes[_sbaAttr(0)];
    return v1 != v2 && (v1 != 0 || v2 != null);
      //Note: left is default to 0, while dataAttributes is default null => not app
  }
  /** Returns true if [View]'s top is set by the application.
   */
  static bool isTopByApp(View view) {
    final v1 = _sbaVal(view, 1), v2 = view.dataAttributes[_sbaAttr(1)];
    return v1 != v2 && (v1 != 0 || v2 != null);
      //Note: left is default to 0, while dataAttributes is default null => not app
  }
  /** Returns true if [View]'s width is set by the application.
   */
  static bool isWidthByApp(View view) {
    final val = _sbaVal(view, 2);
    return val != null && val != view.dataAttributes[_sbaAttr(2)];
      //Note: if null is assigned, it is considered as set-internally
  }
  /** Returns true if [View]'s height is set by the application.
   */
  static bool isHeightByApp(View view) {
    final val = _sbaVal(view, 3);
    return val != null && val != view.dataAttributes[_sbaAttr(3)];
      //Note: if null is assigned, it is considered as set-internally
  }
  static int _sbaVal(View view, int type) {
    switch (type) {
      case 0: return view.left;
      case 1: return view.top;
      case 2: return view.width;
      case 3: return view.height;
    }
  }
  static String _sbaAttr(int type) => 'rk.layout.$type';
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
      browser.size: new DomAgent(p).innerSize;
    mask.style
      ..width = Css.px(size.width)
      ..height = Css.px(size.height);
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
