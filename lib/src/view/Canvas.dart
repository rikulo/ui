//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 24, 2012  4:42:38 PM
// Author: tomyeh
part of rikulo_view;

/**
 * A canvas view that you can draw graphics, on the fly, in Dart.
 */
class Canvas extends View {
  Canvas() {
  }

  /** Returns a drawing context for 2D on the canvas.
   * A drawing context lets you draw on the canvas.
   */
  CanvasRenderingContext2D get context2D => canvasNode.getContext("2d");
  /** Returns a drawing context for WebGL on the canvas, or null
   * if the browser doesn't support WebGL.
   */
  WebGLRenderingContext get contextWebGL => canvasNode.getContext("experimental-webgl");

  /** Returns the canvas element. It is the same as [node].
   */
  CanvasElement get canvasNode => node;

  //@override
  void set width(int width) {
    super.width = width;
    canvasNode.width = width;
  }
  //@override
  void set height(int height) {
    super.height = height;
    canvasNode.height = height;
  }
  //@override
  Element render_() => new Element.tag("canvas");
  /** Returns false to indicate this view doesn't allow any child views.
   */
  //@override
  bool get isViewGroup => false;
  //@override
  bool get shallMeasureContent => false;
}