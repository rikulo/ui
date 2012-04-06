//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  9:56:38 AM
// Author: tomyeh

/**
 * A layout controller that arranges the layout of the child views.
 */
interface Layout default FreeLayout {
	/** Indicates there is no limitation of the given dimension.
	 */
	static final int NO_LIMIT = MeasureContext.NO_LIMIT;

	/** Measure the dimension of the given view.
	 */
	Size measureSize(MeasureContext ctx, View view);
	/** Handles the layout of the given view.
	 */
	void layout(MeasureContext ctx, View view);
}
