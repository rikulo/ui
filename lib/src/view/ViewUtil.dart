//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  6:16:53 PM
// Author: tomyeh
part of rikulo_view;

/**
 * An ID space.
 */
abstract class IdSpace {
  /** Searches and returns the first view that matches the given selector,
   * or null if not found.
   */
  View query(String selector);
  /** Searches and returns all views that matches the selector (never null).
   */
  List<View> queryAll(String selector);

  /** Returns a map of all fellows in this ID space.
   * The key is ID, while the value is the view with the given ID.
   *
   *     view.fellows['foo'].width = 100;
   *       //equivalent to view.query('#foo').width = 100
   *
   * Notice that the application shall consider the map as read-only.
   * Otherwise, the result is unpredictable.
   */
  Map<String, View> get fellows;
}

/**
 * Represents an input that store a value.
 */
abstract class Input<T> {
  /** The value. */
  T value;
}

/** An UI exception.
 */
class UiError implements Error {
  final String message;

  UiError(String this.message);
  String toString() => "UiError($message)";
}

/**
 * A declaration of properties.
 */
class Declaration {
  final Map<String, String> _props;

  Declaration(): _props = new Map();

  /** The text representation of the declaration block.
   * Setting this attribute will reset all properties.
   */
  String get text {
    final StringBuffer sb = new StringBuffer();
    for (final String key in _props.keys)
      sb.add(key).add(':').add(_props[key]).add(';');
    return sb.toString();
  }
  /// Sets the text representation of the declaration block.
  void set text(String text) {
    _props.clear();

    for (String pair in _s(text).split(';')) {
      pair = pair.trim();
      if (pair.isEmpty)
        continue;
      final int j = pair.indexOf(':');
      if (j > 0) {
        final String key = pair.substring(0, j).trim();
        final String value = pair.substring(j + 1).trim();
        if (!key.isEmpty) {
          setProperty(key, value);
          continue;
        }
      }
      throw new UiError("Unknown declaration: ${pair}");
    }
  }
  /** Returns a collection of properties that are assigned with
   * a non-empty value.
   */
  Collection<String> get propertyNames {
    return _props.keys;
  }
  /** Retrieves the property's value.
   */
  String getPropertyValue(String propertyName) {
    final String value = _props[propertyName];
    return value != null ? value: "";
  }
  /** Removes the property of the given name.
   */
  String removeProperty(String propertyName) {
    _props.remove(propertyName);
  }
  /** Sets the value of the given property.
   * If the given value is null or empty, the property will be removed.
   *
   * Notice: the value will be trimmed before saving.
   */
  void setProperty(String propertyName, String value) {
    if (value == null || value.isEmpty)
      removeProperty(propertyName);
    else
      _props[propertyName] = value.trim();
  }
}

/** An annotation for providing meta-information.
 * The menaning depends on the tool or utility that interprets it.
 *
 * See also [View.annotations].
 */
abstract class Annotation {
  /** The name of this annoataion.
   */
  String get name;
  /** The attributes of this annoataion.
   */
  Map<String, List<String>> get attributes;
}

/** A readonly list of root views that are attached to the document.
 * In other words, if a root view's `addToDocument` is called, it will be
 * added to this list automatically.
 *
 * > Don't modify it directly. The result is unpredictable.
 */
final List<View> rootViews = new List();

/**
 * A collection of [View] utilities.
 */
class ViewUtil {
  /** Returns the view of the given node, or null if not found.
   *
   * Notice it searches only the mounted views, i.e.,
   * `inDocument` is true.
   *
   * If the given node doesn't belong to any view,
   * the nearest view containing it will be returned.
   * For example, if the given node is the content of an instance of [TextView],
   * the [TextView] instance will be returned.
   */
  static View getView(Node node) {
    var view;
    do {
      if ((view = _views[node]) != null)
        return view;
    } while ((node = node.parent) != null && node is! Document);
  }
  static final Map<Element, View> _views = new Map();

  /** Handles the layouts of views queued by [View.requestLayout].
   *
   * Notice that it is static, i.e., all queued requests will be handled.
   */
  static void flushRequestedLayouts() {
    layoutManager.flush(null, true);
  }

  /** Returns the root view of the given view.
   */
  static View getRoot(View view) {
    for (View w; (w = view.parent) != null; view = w)
      ;
    return view;
  }
  /** Returns the rectangle enclosing all views in the given list.
   * Views in [children] must belong to the same parent.
   *
   * It doesn't count the child views that are anchored or [View.shallLayout_]
   * returns false.
   */
  static Rectangle getRectangle(List<View> children) {
    int left = 0, top = 0, right = 0, bottom = 0;
    for (final View child in children) {
      if ((child.parent == null || child.parent.shallLayout_(child))
      && child.profile.anchorView == null) {
        final String pos = child.style.position;
        if (pos != "static" && pos != "fixed") {
          if (child.left < left) left = child.left;
          int val = child.width;
          if (val != null && (val += child.left) > right)
            right = val;

          if (child.top < top) top = child.top;
          val = child.height;
          if (val != null && (val += child.top) > bottom)
            bottom = val;
        }
      }
    }
    return new Rectangle(left, top, right, bottom);
  }

  /** Returns an ID that uniquely identifying this application.
   * In other words, every dart application in the same browser
   * will have an unique [appId].
   */
  static int get appId {
    if (_appId == null) {
      final body = document.body;
      if (body == null)
        throw new UiError("document not ready yet");

      final attrs = body.dataAttributes;
      String sval = attrs[_APP_COUNT];
      if (sval != null) {
        _appId = int.parse(sval);
        attrs[_APP_COUNT] = _appId + 1;
      } else {
        _appId = 0;
        attrs[_APP_COUNT] = "1";
      }
    }
    return _appId;
  }
  static int _appId;
  static const String _APP_COUNT = "data-rkAppCount";
}
