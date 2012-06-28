//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 26, 2012  2:47:38 PM
// Author: tomyeh

/**
 * The context to measure size.
 */
class MeasureContext {
  /** The widths of measured views. The size is stored to speed up
   * the measurement since [View.measureWidth_] might be called multiple times
   * in one layout run. If the width shall be re-measured, you can
   * remove it from this map.
   *
   * Note: null indicates the width is up to the system, i.e., no need
   * to set the width.
   */
  final Map<View, int> widths;
  /** The heights of measured views. The size is stored to speed up
   * the measurement since [View.measureHeight_] might be called multiple times
   * in one layout run. If the height shall be re-measured, you can
   * remove it from this map.
   *
   * Note: null indicates the height is up to the system, i.e., no need
   * to set the height.
   */
  final Map<View, int> heights;
  final Map<View, int> _borderWds;

  MeasureContext(): widths = new Map(), heights = new Map(),
  _borderWds = new Map() {
  }
  /** Returns the border's width.
   */
  int getBorderWidth(View view) {
    int v = _borderWds[view];
    if (v === null)
      _borderWds[view] = v = new DOMQuery(view.node).borderWidth;
    return v;
  }

  /** Returns the width set by the applicaiton, or null if it is not set yet or set
   * by a layout.
   */
  int getWidthSetByApp(View view) => layoutManager._getWidthSetByApp(view);
  /** Returns the height set by the applicaiton, or null if it is not set yet or set
   * by a layout.
   */
  int getHeightSetByApp(View view) => layoutManager._getHeightSetByApp(view);
}
