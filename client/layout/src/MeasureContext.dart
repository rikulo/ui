//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 26, 2012  2:47:38 PM
// Author: tomyeh

/**
 * The measure context.
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
	 * the measurement since View.measure might be called multiple time
	 * in one layout run. If the size shall be re-measured, you can
	 * remove it from this map.
	 */
	Map<View, Size> measures;

	MeasureContext() {
		measures = new Map();
		max = new Size(NO_LIMIT, NO_LIMIT);
		min = new Size(NO_LIMIT, NO_LIMIT);
	}
}
