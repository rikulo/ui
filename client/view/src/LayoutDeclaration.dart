//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012 10:03:14 AM
// Author: tomyeh

/**
 * The layout declaration of a view.
 */
interface LayoutDeclaration extends Declaration
default LayoutDeclarationImpl {
  LayoutDeclaration(View owner);

  /** The type of the layout.
   *
   * Syntax: `type: none | linear | stack | tiles | table`
   *
   * Default: *an empty string*. It means no layout required at all (i.e., `none`)
   *
   * Notice you can plug in addition custom layouts. Refer to [LayoutManager]
   * for details.
   */
  String type;
  /** The orientation.
   *
   * Syntax: `orient: horizontal | vertical`
   *
   * Default: *an empty string*. It means `horizontal`.
   */
  String orient;
  /** The alignment.
   *
   * Syntax: `align: start | center | end`
   *
   * Default: *an empty string*. It means `start`.
   */
  String align;
  /** The spacing between two adjacent child views and
   * between a child view and the border.
   * It can be overriden by child view's [View.profile.spacing].
   *
   * Syntax: `spacing: #n1 [#n2 [#n3 #n4]]`
   *
   * Default: *an empty string*. It means `3`.
   *
   * If the spacing at the left and at the right is different,
   * the horizontal spacing of two adjacent views is the maximal value of them.
   * Similarly, the vertical spacing is the maximal
   * value of the spacing at the top and at the bottom.
   * If you prefer a different value, specify it in [gap].
   */
  String spacing;
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
  String gap;
  /** The width of each child view.
   * It can be overriden by child view's [View.profile.width].
   *
   * Syntax: `width: #n | content | flex | flex #n | #n %`
   *
   * Default: *an empty string*. It means `content`.
   */
  String width;
  /** The width of each child view.
   * It can be overriden by child view's [View.profile.height].
   *
   * Syntax: `height: #n | content | flex | flex #n | #n %`
   *
   * Default: *an empty string*. It means `content`.
   */
  String height;
}
