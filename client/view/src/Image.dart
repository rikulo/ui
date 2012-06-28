//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 13, 2012  1:50:56 PM
// Author: tomyeh

/**
 * An image.
 */
class Image extends View {
  String _src;
  Image([String src]) {
    _src = src;
  }

  //@Override
  String get className() => "Image"; //TODO: replace with reflection if Dart supports it

  /** Returns the source URI of the image, or null if not assigned yet.
   */
  String get src() => _src;
  /** Sets the source URI of the image.
   */
  void set src(String src) {
    _src = src;

    if (inDocument) {
      ImageElement n = node;
      n.src = src != null ? src: ""; //TODO: a blank image
    }
  }

  void domAttrs_(StringBuffer out,
  [bool noId=false, bool noStyle=false, bool noClass=false]) {
    if (_src != null)
      out.add(' src="').add(_src).add('"');
    super.domAttrs_(out, noId, noStyle, noClass);
  }
  /** Returns the HTML tag's name representing this widget.
   *
   * Default: `img`.
   */
  String get domTag_() => "img";
  /** Returns false to indicate this view doesn't allow any child views.
   */
  bool isViewGroup() => false;

  int measureWidth_(MeasureContext mctx)
  => layoutManager.measureWidthByContent(mctx, this, false); //no need to autowidth
  int measureHeight_(MeasureContext mctx)
  => layoutManager.measureHeightByContent(mctx, this, false); //no need to autowidth

  void mount_() {
    super.mount_();

    if (_src != null && (width === null || height === null))
      layoutManager.waitImageLoaded(_src);
  }

  String toString() => "$className('$src')";
}
