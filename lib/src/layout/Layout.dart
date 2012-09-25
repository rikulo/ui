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

/** A skeletal implementation of [Layout].
 * By extending from this class, the derive can implement only [measureWidth],
 * [measureHeight] and [doLayout_].
 *
 * Notice the default implementation of [doLayout] already handles the `preLayout`
 * callback, anchored views and the recursive callback of [doLayout] of sub views.
 * The derive shall override [doLayout_] and handle only the give sub views.
 */
class AbstractLayout implements Layout {
  /** Arranges the layout of non-anchored views.
   * Instead of overriding [doLayout], it is simpler to override this method.
   */
  abstract void doLayout_(MeasureContext mctx, View view, List<View> children);

  /** Default: true.
   */
  bool isProfileInherited() => true;
  /** Default: false.
   */
  bool isFlex() => false;
  void doLayout(MeasureContext mctx, View view) {
    if (view.firstChild != null) {
      final AnchorRelation ar = new AnchorRelation(view);
      for (final View child in ar.indeps) {
        mctx.preLayout(child);
        //unlike View.onLayout_, the layout shall invoke mctx.preLayout
      }

      //1) layout independents
      doLayout_(mctx, view, ar.indeps);

      //2) do anchored
      ar.layoutAnchored(mctx);

      //3) pass control to children
      for (final View child in view.children) {
        if (child.visible)
          child.doLayout_(mctx); //no matter shallLayout_(child)
      }
    }
  }
}

//Utilities//
final int _DEFAULT_SPACING = 3;
/** Returns the layout amount info for the given view.
 */
LayoutAmountInfo _getLayoutAmountInfo(View view, String value) {
  final amt = new LayoutAmountInfo(value);
  if (amt.type == LayoutAmountType.NONE
  && layoutManager.getLayoutOfView(view).isFlex()) {
    amt.type = LayoutAmountType.FLEX;
    amt.value = 1;
  }
  return amt;
}
