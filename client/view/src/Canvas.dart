//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 24, 2012  4:42:38 PM
// Author: tomyeh

/**
 * A canvas.
 */
class Canvas extends View {
  Canvas() {
  }

  //@Override
  String get className => "Canvas"; //TODO: replace with reflection if Dart supports it

  /** Returns a drawing context for 2D on the canvas.
   * A drawing context lets you draw on the canvas.
   *
   * Notice that it will throw an exception if it is not attached. In other words,
   * [inDocument] must be true when calling this method.
   */
  CanvasRenderingContext2D get context2D => canvasNode.getContext("2d");
  /** Returns a drawing context for WebGL on the canvas, or null
   * if the browser doesn't support WebGL.
   *
   * Notice that it will throw an exception if it is not attached. In other words,
   * [inDocument] must be true when calling this method.
   */
  WebGLRenderingContext get contextWebGL => canvasNode.getContext("experimental-webgl");

  /** Returns the canvas element. It is the same as [node].
   */
  CanvasElement get canvasNode => node;

  //@Override
  void set width(int width) {
    super.width = width;
    if (inDocument)
      canvasNode.width = width;
  }
  //@Override
  void set height(int height) {
    super.height = height;
    if (inDocument)
      canvasNode.height = height;
  }
  //@Override
  void domAttrs_(StringBuffer out, [DOMAttrsCtrl ctrl]) {
    if (width != null)
      out.add('  width="').add(width).add('"');
    if (height != null)
      out.add('  height="').add(height).add('"');

    super.domAttrs_(out, ctrl);
  }
  String get domTag_ => "canvas";
}
