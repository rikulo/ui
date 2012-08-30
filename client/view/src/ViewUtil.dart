//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  6:16:53 PM
// Author: tomyeh

/** An UI exception.
 */
class UIException implements Exception {
  final String message;

  const UIException(String this.message);
  String toString() => "UIException($message)";
}

/**
 * A declaration of properties.
 */
interface Declaration default DeclarationImpl {
  Declaration();

  /** The text representation of the declaration block.
   * Setting this attribute will reset all properties.
   */
  String text;
  /** Returns a collection of properties that are assigned with
   * a non-empty value.
   */
  Collection<String> getPropertyNames();
  /** Retrieves the property's value.
   */
  String getPropertyValue(String propertyName);
  /** Removes the property of the given name.
   */
  String removeProperty(String propertyName);
  /** Sets the value of the given property.
   * If the given value is null or empty, the property will be removed.
   */
  void setProperty(String propertyName, String value);
}

/**
 * A collection of [View] utilities.
 */
class ViewUtil {
  /** Returns the view of the given UUID or element, or null if not found.
   *
   * Notice it searches only the mounted views, i.e.,
   * `inDocument` is true.
   *
   * + [uuid] specifies either UUID (a String instance)
   * or an element (an Element instance). Note it can contain the suffix, such as
   * *uuid-inner* (in fact, it will remove the suffix starting with dash).
   *
   * If an element is given, the nearest view containing it will be returned.
   * For example, if the given element is the content of an instance of [TextView],
   * the [TextView] instance will be returned.
   */
  static View getView(var uuid) {
    if (uuid is Element) {
      Element e = uuid as Element;
      do {
        if (e.id != null) {
          final v = _views[_noSuffix(e.id)];
          if (v != null)
            return v;
        }
      } while ((e = e.parent) != null && e is! Document);
      return null;
    }

    return _views[_noSuffix(uuid as String)];
  }
  static String _noSuffix(String uuid) {
    if (uuid != null) {
      final i = uuid.lastIndexOf('-');
      if (i > 0)
        uuid = uuid.substring(0, i);
    }
    return uuid;
  }
  static Map<String, View> _$views;
  static Map<String, View> get _views => _$views != null ? _$views: (_$views = {});

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
   * Views in [children] must belong to the same parent.
   *
   * It doesn't count the child views that are anchored or [View.shallLayout_]
   * returns false.
   */
  static Rectangle getRectangle(List<View> children) {
    final Rectangle r = new Rectangle(0,0,0,0);
    for (final View child in children) {
      if ((child.parent == null || child.parent.shallLayout_(child))
      && child.profile.anchorView == null) {
        final String pos = child.style.position;
        if (pos != "static" && pos != "fixed") {
          if (child.left < r.left) r.left = child.left;
          int val = child.width;
          if (val != null && (val += child.left) > r.right)
            r.right = val;

          if (child.top < r.top) r.top = child.top;
          val = child.height;
          if (val != null && (val += child.top) > r.bottom)
            r.bottom = val;
        }
      }
    }
    return r;
  }
}
