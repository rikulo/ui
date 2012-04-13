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
		vclass = "v-Image";
	}
	/** Returns the source URI of the image, or null if not assigned yet.
	 */
	String get src() => _src;
	/** Sets the source URI of the image.
	 */
	void set src(String src) {
		_src = src;
		ImageElement n = node;
		if (n != null)
			n.src = src != null ? src: ""; //TODO: a blank image
	}

	void domAttrs_(StringBuffer out,
	[bool noId=false, bool noStyle=false, bool noClass=false]) {
		if (_src != null)
			out.add(' src="').add(_src).add('"');
		super.domAttrs_(out, noId, noStyle, noClass);
	}
	/** Returns the HTML tag's name representing this widget.
	 * <p>Default: <code>img</code>.
	 */
	String get domTag_() => "img";
	/** Returns whether this view allows any child views.
	 * <p>Default: false.
	 */
	bool isChildable_() => false;

	int measureWidth(MeasureContext mctx)
	=> layoutManager.measureWidthByContent(mctx, this);
	int measureHeight(MeasureContext mctx)
	=> layoutManager.measureHeightByContent(mctx, this);

	String toString() => "Image('$src')";
}
