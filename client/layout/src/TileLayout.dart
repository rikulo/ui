//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Aug 21, 2012  4:01:03 PM
// Author: tomyeh

/**
 * The title layout (not implemented yet).
 * It arranges the child views of the associated view in rows and columns.
 *
 * Based on the given width, minWidth and maxWidth, it arranges views from left
 * to right, and starts a new row when there is no enough zoom for a view.
 *
 * [LayoutDeclaration] of the associated view provides the default width and height
 * for each child view, while [ProfileDeclaration] of
 * each child view, if specified, controls how a child view is arranged different
 * including width, minWidth, minHeight, maxWidth and so on.
 *
 * In additions, you can control the alignment and spacing with the `align`,
 * `spacing` and `gap` properties. If you want to arrange a view as the first or lat view
 * of a row, you can control it with the `clear` property. Please refer to
 * [ProfileDeclaration] for more information.
 *
 * [TileLayout] arranges views row-by-row and then cell-by-cell. When calculating
 * and deciding how many of views can be placed in the given row, it first check
 * the width (of [ProfileDeclaration] and then [LayoutDeclaration]). If a fixed
 * value is specified (excluding flex and ratio), it will be used.
 * Otherwise, it checked the minWidth of [ProfileDeclaration].
 *
 * After deciding which views to place in the given row, it distributes the width
 * based on the criteria specified in [ProfileDeclaration] and [LayoutDeclaration].
 *
 * It is useful for responsive Web design, since the tile layout will
 * arrange child views in additional rows, if they can't fit into a row.
 */
class TileLayout extends AbstractLayout {
  void doLayout_(MeasureContext mctx, View view, List<View> children) {
    final innerWidth = () => view.innerWidth,
      innerHeight = () => view.innerHeight;
    int sum = 0;
    for (final View child in children) {
      if (!view.shallLayout_(child)) {
        mctx.setWidthByProfile(child, innerWidth);
        mctx.setHeightByProfile(child, innerHeight);
        continue;
      }
    }
  }

  int measureWidth(MeasureContext ctx, View view) {
    throw const UIException("'content' not allowed in tile layout");
  }
  int measureHeight(MeasureContext ctx, View view) {
    throw const UIException("'content' not allowed in tile layout");
  }
  bool isFlex() => true;
}
