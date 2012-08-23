//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 25, 2012  3:52:43 PM
// Author: tomyeh

/**
 * The information of a view that has been cut from another view by
 * [View.cut]. It is used to implement the so-called 'cut-and-paste' feature.
 * Cut-and-paste is used to speed up the detachment and attachment
 * of a view.
 *
 * ##Use
 *
 * To cut and paste a view, you can invoke [View.cut] first, and then
 * invoke [pasteTo] to paste it to a parent view you like. For example,
 *
 *     view.cut().pasteTo(newParent);
 *
 * The reason that cut-and-paste is more efficiently is the view's DOM elements
 * won't be removed, so [View.unmount_], [View.mount_] and
 * other detaching and attaching tasks have no need to take place.
 *
 * If you decide not to paste it to another place, it is better to invoke
 * [drop] to remove DOM elements. It will invoke [View.unmount_] such that
 * your application or utility can clean up if necessary. After dropped, the view
 * can be used normally as if they are removed normally (with [View.removeFromParent]).
 *
 * Notice that there is one limitation:
 * the view being cut (i.e., [view]) cannot be modified until
 * [pasteTo] or [drop] is called.
 * Furthermore, once [pasteTo] or [drop] is called, the [ViewCut] object can't be used
 * anymore.
 *
 */
interface ViewCut {
  /** The view being cut.
   */
  View get view;

  /** Pastes the view kept in this [Viewcut] to the given parent view.
   * The view kept in this object will become a child of the given parent view.
   *
   * If [beforeChild] is specified, it must be a child of the given parent,
   * and the view kept in this object will be inserted before it.
   *
   * Notice that this method can be called only once.
   */
  void pasteTo(View parent, [View beforeChild]);
  /** Drops the cut.
   * It will invoke [unmount_] and other detaching tasks such
   * that your application or utilties depending on the unmount event
   * can clean up correctly.
   * Furthermore, the view can be accessed normall as if the view is removed
   * by [View.removeFromParent].
   */
  void drop();
}
class _ViewCut implements ViewCut {
  final View view;

  _ViewCut(View this.view) {
    if (!view.inDocument) //note: it is cached to View._node
      throw new UIException("Not in document: $view");

    final View parent = view.parent;
    if (parent == null)
      throw new UIException("Root not allowed: $view");

    parent._removeChild(view, exit: false); //not to exit
  }
  void pasteTo(View parent, [View beforeChild]) {
    if (!parent.inDocument)
      throw new UIException("Not in document: $parent");
    _check();

    parent._addChild(view, beforeChild, view.node);
  }
  void drop() {
    _check();
    view._unmount();
  }
  void _check() {
    if (view.parent != null || !view.inDocument)
      throw const UIException("Unable to paste or drop twice");
  }
}
