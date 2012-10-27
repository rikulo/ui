//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jul 23, 2012  2:31:05 PM
// Author: tomyeh

/**
 * The render context used to render [DataModel].
 *
 * Note: Which renderer to use depends on the view.
 * See also [Renderer].
 */
interface RenderContext<T> default _RenderContext<T> {
  RenderContext(View view, DataModel model, T data,
    bool selected, bool disabled,
    [int index, String column, int columnIndex]);

  /** The view that renders the model. */
  final View view;
  /** The model. */
  final DataModel model;
  /** The data being rendered.
   */
  final T data;
  /** The index of data, or -1 if not applicable.
   */
  final int index;
  /** Whether the data is selected, or false if not applicable.
   */
  final bool selected;
  /** Whetehr the data is disabled, or false if not applicable.
   */
  final bool disabled;

  /** The column index, or -1 if not applicable.
   * It is used only if the view is a grid-type UI and it supports the render-on-demand
   * at the horizontal direction. In other words, [data] is the data representing
   * the whole row, while [columnIndex] specifies which part of the data to render.
   *
   * Please refer to the views that support this field.
   */
  final int columnIndex;
  /** The column's name, or null if not applicable.
   * Like [columnIndex], it is used only if the view is a grid-type UI and
   * it supports the render-on-demand at the horizontal direction.
   * In other words, [data] is the data representing
   * the whole row, while [column] specifies which part of the data to render.
   *
   * Note: dependong on the view, [column] might not be supported, even if
   * supports [columnIndex].
   *
   * Please refer to the views that support this field.
   */
  final String column;
}
/** Renders the given data into a string or an element.
 * The return value depends on the view you are using.
 */
typedef Renderer(RenderContext context);

class _RenderContext<T> implements RenderContext<T> {
  final View view;
  final DataModel model;
  final T data;
  final int index;
  final bool selected;
  final bool disabled;
  final int columnIndex;
  final String column;

  _RenderContext(View this.view, DataModel this.model, T this.data,
    bool this.selected, bool this.disabled,
    [int this.index = -1, String this.column, int this.columnIndex = -1]);

  /** Converts the given object to a string.
   *
   * + [encode] specifies whether to invoke [XMLUtil.encode].
   */
  String getDataAsString([bool encode=false]) {
    var val = data;
    if (val is TreeNode)
      val = val.data;
    if (val is Map && val.contains("text"))
      val = val["text"];
    return val != null ? encode ? "${XMLUtil.encode(val)}": val.toString(): "";
  }
}
