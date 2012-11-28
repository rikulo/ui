//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012 10:03:14 AM
// Author: tomyeh
part of rikulo_view;

/**
 * The layout declaration of a view.
 */
class LayoutDeclaration extends Declaration {
  final View _owner;
  Layout _handler;

  LayoutDeclaration(View owner): _owner = owner;

  /** The type of the layout.
   *
   * Syntax: `type: none | linear`
   *
   * Default: *an empty string*. It means no layout required at all (i.e., `none`)
   *
   * Notice you can plug in addition custom layouts. Refer to [LayoutManager]
   * for details.
   */
  String get type => getPropertyValue("type");
  /** The type of the layout.
   *
   * Alternatively, you can assign the layout handler directly with [handler].
   * It is useful if you'd like a view to be handled with a custom layout.
   */
  void set type(String value) {
    setProperty("type", value);
  }
  /** The handler for handling this layout.
   *
   * Note: this method will check if [handler] was set. If not, it will
   * return the handler of the given type specified in [type].
   * If there is no built-in handler for the given type, [UiError]  will
   * be thrown. In other words, this method won't return null.
   */
  Layout get handler {
    if (_handler != null)
      return _handler;

    final Layout handler = layoutManager.getLayout(type);
    if (handler == null)
      throw new UiError("Unknown type, ${type}");
    return handler;
  }
  /** The handler for handling this layout.
   * Instead of assigning one of standard types with [type], you can assign
   * a custom layout handler directly with this method.
   */
  void set handler(Layout layout) {
    _handler = layout;
    type = layout != null ? layoutManager.getType(layout): null;
  }

  /** The orientation.
   *
   * Syntax: `orient: horizontal | vertical`
   *
   * Default: *an empty string*. It means `horizontal`.
   */
  String get orient => getPropertyValue("orient");
  /// The orientation.
  void set orient(String value) {
    setProperty("orient", value);
  }
  /** The alignment.
   *
   * Syntax: `align: start | center | end`
   *
   * Default: *an empty string*. It means `start`.
   */
  String get align => getPropertyValue("align");
  /// The alignment.
  void set align(String value) {
    setProperty("align", value);
  }
  /** The spacing between two adjacent child views and
   * between a child view and the border.
   * It can be overriden by child view's [View.profile.spacing].
   *
   * Syntax: `spacing: #n1 [#n2 [#n3 #n4]]`
   *
   * Default: *an empty string*. It means `8` in *touch* devices
   * (i.e., `Browser.touch` is true), or `4` otherwise.
   *
   * If the spacing at the left and at the right is different,
   * the horizontal spacing of two adjacent views is the maximal value of them.
   * Similarly, the vertical spacing is the maximal
   * value of the spacing at the top and at the bottom.
   * If you prefer a different value, specify it in [gap].
   */
  String get spacing => getPropertyValue("spacing");
  /** The spacing between two adjacent child views and
   * between a child view and the border.
   */
  void set spacing(String value) {
    setProperty("spacing", value);
  }
  /** The gap between two adjacent child views.
   * If not specified, the value specified at [spacing] will be used.
   *
   * Syntax: `gap: #n1 [#n2]`
   *
   * Default: *an empty string*. It means dependong on [spacing].
   *
   * If you prefer to have a value other than [spacing], you can
   * specify [gap]. Then, [spacing] controls only the spacing between
   * a child view and the border, while [gap] controls the spacing
   * between two child views.
   */
  String get gap => getPropertyValue("gap");
  /// The gap between two adjacent child views.
  void set gap(String value) {
    setProperty("gap", value);
  }
  /** The width of each child view.
   * It can be overriden by child view's [View.profile.width].
   *
   * Syntax: `width: #n | content | flex | flex #n | #n %`
   *
   * Default: *an empty string*. It means `content`.
   */
  String get width => getPropertyValue("width");
  /// The width of each child view.
  void set width(String value) {
    setProperty("width", value);
  }
  /** The width of each child view.
   * It can be overriden by child view's [View.profile.height].
   *
   * Syntax: `height: #n | content | flex | flex #n | #n %`
   *
   * Default: *an empty string*. It means `content`.
   */
  String get height => getPropertyValue("height");
  /// The width of each child view.
  void set height(String value) {
    setProperty("height", value);
  }
}
