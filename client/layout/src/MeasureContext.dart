//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 26, 2012  2:47:38 PM
// Author: tomyeh

/**
 * The context to measure size.
 */
class MeasureContext {
	/** Indicates there is no limitation of the given dimension.
	 */
	static final int NO_LIMIT = -1;

	/** Indicates the maximal allowed size. */
	Size max;
	/** Indicates the minimal allowed size. */
	Size min;

	/** The size of measured views. The size is stored to speed up
	 * the measurement since [View.measureSize] might be called multiple time
	 * in one layout run. If the size shall be re-measured, you can
	 * remove it from this map.
	 */
	final Map<View, Size> measures;

	MeasureContext(View view): measures = new Map() {
		Element node = view.node;
		max = new Size(node.$dom_offsetWidth, node.$dom_offsetHeight);
		min = new Size(0, 0);
	}
	MeasureContext.from(MeasureContext mctx, int width, int height):
	measures = mctx.measures {
		max = new Size(width, height);
		min = new Size(0, 0);
	}
}
