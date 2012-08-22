//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  9:56:38 AM
// Author: tomyeh

/**
 * A layout controller that arranges the layout of the child views.
 */
interface Layout default FreeLayout {
  /** Measure the width of the given view.
   */
  int measureWidth(MeasureContext ctx, View view);
  /** Measure the height of the given view.
   */
  int measureHeight(MeasureContext ctx, View view);

  /** Returns whether the subview's profile shall inherit the layout of
   * its parent.
   *
   * For example, it is true for [LinearLayout], since the profile's width and
   * height in the subviews shall inherit from [LayoutDeclaration] of the parent
   * (that is associated with [LinearLayout]).
   */
  bool isProfileInherited();
  /** Returns whether its dimension depends on the parent.
   * If `true` is returned, the default width of the associate view's
   * [LayoutDeclaration] will be `flex` (rather than `content`).
   *
   * For example, [TileLayout] returns true since there is no way to measure
   * the dimension without knowing the parent's dimension.
   */
  bool isFlex();

  /** Handles the layout of the given view.
   */
  void doLayout(MeasureContext ctx, View view);
}
