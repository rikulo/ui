//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 13, 2012  1:50:56 PM
// Author: tomyeh
part of rikulo_view;

/**
 * A view for display an image.
 */
class Image extends View {
  Image([String src]) {
    if (src != null && !src.isEmpty)
      imageNode.src = src;
  }

  /** Returns the source URI of the image, or null if not assigned yet.
   */
  String get src => imageNode.src;
  /** Sets the source URI of the image.
   */
  void set src(String src) {
    imageNode.src = _s(src);
  }

  /** Returns the image node.
   */
  ImageElement get imageNode => node;

  //@override
  Element render_()
  => new Element.tag("img");
  /** Returns false to indicate this view doesn't allow any child views.
   */
  //@override
  bool get isViewGroup => false;

  int measureWidth_(MeasureContext mctx)
  => mctx.measureContentWidth(this, false); //no need to autowidth
  int measureHeight_(MeasureContext mctx)
  => mctx.measureContentHeight(this, false); //no need to autowidth

  void mount_() {
    super.mount_();

    if (width == null || height == null)
      layoutManager.waitImageLoaded(src);
  }

  String toString() => "$className('$src')";
}
