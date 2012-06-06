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
  /** Measure the width of the given view.
   */
  int measureHeight(MeasureContext ctx, View view);

  /** Handles the layout of the given view.
   */
  void doLayout(MeasureContext ctx, View view);
}
