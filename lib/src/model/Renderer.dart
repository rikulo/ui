//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jul 23, 2012  2:31:05 PM
// Author: tomyeh
part of rikulo_model;

/**
 * The render context used to render [DataModel].
 *
 * Note: Which renderer to use depends on the view.
 * See also [Renderer].
 */
class RenderContext<T> {
  RenderContext(View this.view, DataModel this.model, T this.data,
    bool this.selected, bool this.disabled,
    [int this.index = -1, String this.column, int this.columnIndex = -1]);

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

  /** Converts the given object to a string.
   *
   * + [encode] specifies whether to invoke [XmlUtil.encode].
   */
  String getDataAsString([bool encode=false]) {
    var val = data;
    if (val is TreeNode)
      val = val.data;
    if (val is Map && (val as Map).containsKey("text"))
      val = val["text"];
    return val != null ? encode ? "${XmlUtil.encode(val)}": val.toString(): "";
  }
}
/** Renders the given data into a string or an element.
 * The return value depends on the view you are using.
 */
typedef Renderer(RenderContext context);
