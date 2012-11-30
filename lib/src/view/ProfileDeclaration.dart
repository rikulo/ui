//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012 10:15:54 AM
// Author: tomyeh
part of rikulo_view;

/**
 * The position declaration of a view.
 */
class ProfileDeclaration extends Declaration {
  final View _owner;
  View _anchorView;

  ProfileDeclaration(View owner) : _owner = owner;

  /** The anchor.
   *
   * Syntax: `anchor: | a_CSS_selector | parent`
   *
   * Default: *an empty string*.  
   * It means parent if [location] is specified.  
   * Otherwise, it means no anchor at all if both [location] and [anchor]
   * are empty (and [anchorView] is null).
   */
  String get anchor => getPropertyValue("anchor");
  /** The anchor.
   *
   * Alternatively, you can assign the view directly with [anchorView].
   */
  void set anchor(String value) {
    setProperty("anchor", value);
    _anchorView = null;
  }
  /** The anchor view. There are two ways to assign an anchor view:
   *
   * 1. assign a value to [anchor]
   * 2. assign a view to [anchorView].
   *
   * Notice that the anchor view must be the parent or one of the
   * siblings.
   */
  View get anchorView {
    if (_anchorView != null)
      return _anchorView;
    final anc = anchor;
    return anc.isEmpty ? location.isEmpty ? null: _owner.parent: _owner.query(anc);
  }
  /// The anchor view. There are two ways to assign an anchor view:
  void set anchorView(View view) {
    String av;
    if (view == null) {
      av = "";
    } else if (identical(view, _owner.parent)) {
      av = "parent";
    } else {
      if (view != null
      && view.parent != null && _owner.parent != null //parent might not be assigned yet
      && !identical(view.parent, _owner.parent))
        throw new UiError("Anchor can be parent or sibling, not $view");
      if (identical(view, _owner))
        throw new UiError("Anchor can't be itself, $view.");
      av = view.id.isEmpty ? "": "#${view.id}";
    }
    setProperty("anchor", av);
    _anchorView = view;
  }

  /** The location of the associated view.
   *
   * Default: *an empty string*.
   * It means `top left`, if [anchor] or [anchorView] is specified, 
   *
   * It can be one of the following.  
   * "north start", "north center", "north end",
   * "south start", "south center", "south end",
   * "west start", "west center", "west end",
   * "east start", "east center", "east end",
   * "top left", "top center", "top right",
   * "center left", "center center", "center right",
   * "bottom left", "bottom center", and "bottom right"
   *
   * Notice that it is used only if [anchor] is not assigned with an non-empty value
   * (or [anchorView] is assigned with a view).
   */
  String get location => getPropertyValue("location");
  /// The location of the associated view.
  void set location(String value) {
    setProperty("location", value);
  }

  /** The additional margin after the view being anchored
   * (which is controlled by [location]).
   *
   * Syntax: `num1 [num2 [num3 num4]]`
   *
   * Default: *an empty string* (it means "0")
   *
   * It specifies the additional margin that will affect the view's left, top,
   * width or height depending what are specified.
   *
   *     profile="anchor:parent; margin: 8"
   *        //8 pixels spacing around four edges
   *     profile="location: bottom left; margin: 8 0 -8 0"
   *        //same height but 8 pixel down
   *
   * Notice that it is used only if [anchor] is not assigned with an non-empty value
   * (or [anchorView] is assigned with a view).
   */
  String get margin => getPropertyValue("margin");
  /** The additional margin after the view being anchored
   * (which is controlled by [location]).
   */
  void set margin(String value) {
    setProperty("margin", value);
  }

  /** The alignment.
   *
   * Syntax: `align: start | center | end`
   *
   * Default: *an empty string*. It means it will depends on parent's [LayoutDeclaration].
   */
  String get align => getPropertyValue("align");
  /// The alignment.
  void set align(String value) {
    setProperty("align", value);
  }
  /** The spacing of the associated view.
   *
   * Syntax: `num1 [num2 [num3 num4]]`
   *
   * Default: *an empty string*. It means it will depends on parent's [LayoutDeclaration].
   */
  String get spacing => getPropertyValue("spacing");
  /// The spacing of the associated view.
  void set spacing(String value) {
    setProperty("spacing", value);
  }

  /** The expected width of the associated view.
   *
   * Syntax: `width: num | content | flex | flex num | num % | ignore`
   *
   * Default: *an empty string*. It means it will depends on parent's [LayoutDeclaration].
   *
   * Notice that the width will be adjusted against [minWidth] and
   * [maxWidth] (if they are specified).
   *
   * If `ignore` is specified, the width won't be measured and assigned.
   * The real width depends on the `width` and/or `display` properties given
   * in CSS rules. Notice that, if the width is not given in CSS rules,
   * it could result as zero (unless `View.shallMeasureContent` is true).
   */
  String get width => getPropertyValue("width");
  /// The expected width of the associated view.
  void set width(String value) {
    setProperty("width", value);
  }
  /** The expected height of the associated view.
   *
   * Syntax: `height: num | content | flex | flex num | num % | ignore`
   *
   * Default: *an empty string*. It means it will depends on parent's [LayoutDeclaration].
   *
   * Notice that the height will be adjusted against [minHeight] and
   * [maxHeight] (if they are specified).
   *
   * If `ignore` is specified, the height won't be measured and assigned.
   * The real height depends on the `height` and/or `display` properties given
   * in CSS rules. Notice that, if the height is not given in CSS rules,
   * it could result as zero (unless `View.shallMeasureContent` is true).
   */
  String get height => getPropertyValue("height");
  /// The expected height of the associated view.
  void set height(String value) {
    setProperty("height", value);
  }

  /** The expected minimal allowed width of the associated view.
   *
   * Syntax: `min-width: num | flex | num %`
   *
   * Default: *an empty string*. It means it will depends on parent's [LayoutDeclaration].
   *
   * Currently, it is supported in the following cases:
   *
   * + Supported when measuring the width of a non-ViewGroup view such as
   * [TextView] and [Image] (See also [View.isViewGroup]).
   * + Supported by [TileLayout].
   *
   * Notice that, if, under your layout, the parent's width is decided by
   * the child, don't use flex or percentage at child's profile.
   * Otherwise, it will become zero.
   */
  String get minWidth => getPropertyValue("min-width");
  /// The expected minimal allowed width of the associated view.
  void set minWidth(String value) {
    setProperty("min-width", value);
  }
  /** The expected minimal allowed height of the associated view.
   *
   * Syntax: `min-height: num | flex | #n %`
   *
   * Default: *an empty string*. It means it will depends on parent's [LayoutDeclaration].
   *
   * Currently, it is supported in the following cases:
   *
   * + Supported when measuring the height of a non-ViewGroup view such as
   * [TextView] and [Image] (See also [View.isViewGroup]).
   * + Supported by [TileLayout].
   *
   * Notice that, if, under your layout, the parent's height is decided by
   * the child, don't use flex or percentage at child's profile.
   * Otherwise, it will become zero.
   */
  String get minHeight => getPropertyValue("min-height");
  /// The expected minimal allowed height of the associated view.
  void set minHeight(String value) {
    setProperty("min-height", value);
  }

  /** The expected maximal allowed width of the associated view.
   *
   * Syntax: `max-width: #n | flex | #n %`
   *
   * Default: *an empty string*. It means it will depends on parent's [LayoutDeclaration].
   *
   * Currently, it is supported in the following cases:
   *
   * + Supported when measuring the width of a non-ViewGroup view such as
   * [TextView] and [Image] (See also [View.isViewGroup]).
   * + Supported by [TileLayout].
   *
   * Notice that, if, under your layout, the parent's width is decided by
   * the child, don't use flex or percentage at child's profile.
   * Otherwise, it will become zero.
   */
  String get maxWidth => getPropertyValue("max-width");
  /// The expected maximal allowed width of the associated view.
  void set maxWidth(String value) {
    setProperty("max-width", value);
  }
  /** The expected maximal allowed height of the associated view.
   *
   * Syntax: `max-height: #n | flex | #n %`
   *
   * Default: *an empty string*. It means it will depends on parent's [LayoutDeclaration].
   *
   * Currently, it is supported in the following cases:
   *
   * + Supported when measuring the height of a non-ViewGroup view such as
   * [TextView] and [Image] (See also [View.isViewGroup]).
   * + Supported by [TileLayout].
   *
   * Notice that, if, under your layout, the parent's height is decided by
   * the child, don't use flex or percentage at child's profile.
   * Otherwise, it will become zero.
   */
  String get maxHeight => getPropertyValue("max-height");
  /// The expected maximal allowed height of the associated view.
  void set maxHeight(String value) {
    setProperty("max-height", value);
  }

  /** Which side of the view won't display another sibling.
   *
   * Syntax: `clear: left | right | both`
   *
   * Default: *an empty string*. It means there is no limitation.
   *
   * The real meaning depends on the layout. Currently, only the following
   * layouts support this property.
   *
   * ##[TileLayout]
   *
   * If `clear` is `left`, the view must be the first view in the row.  
   * If `right`, the view must be the last view in the row.  
   * If `both`, the view must be the only view in the row.
   */
  String get clear => getPropertyValue("clear");
  /// Which side of the view won't display another sibling.
  void set clear(String value) {
    setProperty("clear", value);
  }
}
