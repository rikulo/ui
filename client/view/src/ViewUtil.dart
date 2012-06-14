//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  6:16:53 PM
// Author: tomyeh

/**
 * A collection of [View] utitiles.
 */
class ViewUtil {
  /** Redraws the invalidated views queued by [View.invalidate].
   *
   * Notice that it is static, i.e., all queued invalidation will be redrawn.
   */
  static void flushInvalidated() {
    _invalidator.flush();
  }
  /** Handles the layouts of views queued by [View.requestLayout].
   *
   * Notice that it is static, i.e., all queued requests will be handled.
   */
  static void flushRequestedLayouts() {
    layoutManager.flush();
  }

  /** Returns the rectangle enclosing all views in the given list.
   *Views in [children] must belong to the same parent.
   */
  static Rectangle getRectangle(List<View> children) {
    final Rectangle r = new Rectangle(0,0,0,0);
    for (final View child in children) {
      final String pos = child.style.position;
      if (pos != "static" && pos != "fixed") {
        if (child.left < r.left) r.left = child.left;
        int val = child.width;
        if (val !== null && (val += child.left) > r.right)
          r.right = val;

        if (child.top < r.top) r.top = child.top;
        val = child.height;
        if (val !== null && (val += child.top) > r.bottom)
          r.bottom = val;
      }
    }
    return r;
  }

  /** Returns the view of the given UUID.
   *
   * Notice that, if a view is not attached to the document, it won't
   * be returned
   * (i.e., it is considered as not found and `null` is returned).
   */
//  static View getView(String uuid) => _views[uuid];
//  static Map<String, View> _views = new Map();
//Note supported because the memory overhead to maintain _views
}
