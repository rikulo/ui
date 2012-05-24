//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 24, 2012  4:42:38 PM
// Author: tomyeh

/**
 * A canvas.
 */
class Canvas extends View {
	View() {
		vclass = "v-Canvas";
	}

	/** Returns a drawing context for 2D on the canvas.
	 * A drawing context lets you draw on the canvas.
	 */
	CanvasRenderingContext2D get context2D() => node.getContext("2d");
	/** Returns a drawing context for WebGL on the canvas, or null
	 * if the browser doesn't support WebGL.
	 */
	WebGLRenderingContext get contextWebGL() => node.getContext("experimental-webgl");

	//@Override
	void adjustInnerNode_([bool bLeft=false, bool bTop=false, bool bWidth=false, bool bHeight=false]) {
		final n = node; //TODO: replace with Dart's cast if it is supported
		if (bWidth)
			n.width = width;
		if (bHeight)
			n.height = height;
		super.adjustInnerNode_(bLeft, bTop, bWidth, bHeight);
	}
	//@Override
	void domAttrs_(StringBuffer out,
	[bool noId=false, bool noStyle=false, bool noClass=false]) {
		if (width !== null)
			out.add('  width="').add(width).add('"');
		if (height !== null)
			out.add('  height="').add(height).add('"');

		super.domAttrs_(out, noId, noStyle, noClass);
	}
	String get domTag_() => "canvas";
	String toString() => "Canvas($uuid)";
}
