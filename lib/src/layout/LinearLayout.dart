//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  4:48:10 PM
// Author: tomyeh

/**
 * The linear layout. It arranges the children of the associated view in
 * a single column or a single row. The direction is controlled by
 * [LayoutDeclaration.orient]. If not specified, it is default to `horizontal`.
 */
class LinearLayout extends AbstractLayout {
  static _RealLinearLayout _getRealLayout(view) //horizontal is default
  => view.layout.orient != "vertical" ? new _HLayout(): new _VLayout();

  int measureWidth(MeasureContext mctx, View view)
  => _getRealLayout(view).measureWidth(mctx, view);
  int measureHeight(MeasureContext mctx, View view)
  => _getRealLayout(view).measureHeight(mctx, view);

  void doLayout_(MeasureContext mctx, View view, List<View> children)
  => _getRealLayout(view).doLayout(mctx, view, children);
}

interface _RealLinearLayout {
  int measureWidth(MeasureContext mctx, View view);
  int measureHeight(MeasureContext mctx, View view);
  void doLayout(MeasureContext mctx, View view, List<View> children);
}
