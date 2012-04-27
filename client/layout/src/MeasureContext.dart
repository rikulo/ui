//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 26, 2012  2:47:38 PM
// Author: tomyeh

/**
 * The context to measure size.
 */
class MeasureContext {
	/** The widths of measured views. The size is stored to speed up
	 * the measurement since [View.measureWidth] might be called multiple times
	 * in one layout run. If the width shall be re-measured, you can
	 * remove it from this map.
	 * <p>Note: null indicates the width is up to the system, i.e., no need
	 * to set the width.
	 */
	final Map<View, int> widths;
	/** The heights of measured views. The size is stored to speed up
	 * the measurement since [View.measureHeight] might be called multiple times
	 * in one layout run. If the height shall be re-measured, you can
	 * remove it from this map.
	 * <p>Note: null indicates the height is up to the system, i.e., no need
	 * to set the height.
	 */
	final Map<View, int> heights;

	MeasureContext(): widths = {}, heights = {} {
	}
}
