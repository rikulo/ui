//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 26, 2012  2:47:38 PM
// Author: tomyeh

/**
 * The layout context.
 */
interface LayoutContext {
	/** Indicates there is no limitation of the given dimension.
	 */
	static final int NO_LIMIT = -1;

	/** Indicates the maximal allowed size. */
	Size max;
	/** Indicates the minimal allowed size. */
	Size min;
}
