//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  4:48:10 PM
// Author: tomyeh

/**
 * The linear layout.
 */
class LinearLayout implements Layout {
  static _RealLinearLayout _getRealLayout(view) //horizontal is default
  => view.layout.orient != "vertical" ? new _HLayout(): new _VLayout();

  int measureWidth(MeasureContext mctx, View view) {
    int width = mctx.widths[view];
    if (width !== null || mctx.widths.containsKey(view))
      return width;

    return mctx.widths[view] = _getRealLayout(view).measureWidth(mctx, view);
  }
  int measureHeight(MeasureContext mctx, View view) {
    int height = mctx.heights[view];
    if (height !== null || mctx.heights.containsKey(view))
      return height;

    return mctx.heights[view] = _getRealLayout(view).measureHeight(mctx, view);
  }
  void doLayout(MeasureContext mctx, View view) {
    if (view.firstChild !== null) {
      final AnchorRelation ar = new AnchorRelation(view);

      //1) layout independents
      _getRealLayout(view).doLayout(mctx, view, ar.indeps);

      //2) do anchored
      ar.layoutAnchored(mctx);

      //3) pass control to children
      for (final View child in view.children) {
        child.doLayout_(mctx); //no matter shallLayout_(child)
      }
    }
  }

  //Utilities//
  static final int DEFAULT_SPACING = 2;
  static LayoutAmountInfo profileWidth(View view, LayoutAmountInfo amtDefault) {
    final LayoutAmountInfo amt = new LayoutAmountInfo(view.profile.width);
    if (amt.type == LayoutAmountType.NONE) {
      amt.type = amtDefault.type;
      amt.value =  amtDefault.value;
    }
    return amt;
  }
  static LayoutAmountInfo profileHeight(View view, LayoutAmountInfo amtDefault) {
    final LayoutAmountInfo amt = new LayoutAmountInfo(view.profile.height);
    if (amt.type == LayoutAmountType.NONE) {
      amt.type = amtDefault.type;
      amt.value =  amtDefault.value;
    }
    return amt;
  }
}
interface _RealLinearLayout {
  int measureWidth(MeasureContext mctx, View view);
  int measureHeight(MeasureContext mctx, View view);
  void doLayout(MeasureContext mctx, View view, List<View> children);
}
