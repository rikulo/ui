//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 11, 2012

/** A skipper is used with [View] to rerender portion(s) of a view
 * (rather than the whole view).
 * 
 */
interface Skipper {
	/** Returns whether the specified child view will be skipped by [skip].
	 */
	bool isSkipped(View view, View child);
	/** Skips all or subset of the descendant views of the given view,
	 * and returns the DOM elements that shall be reserved and restored by [restore].
	 */
	List<Element> skip(View view);
	/** Restores the DOM elements returned by [skip].
	 */
	void restore(View view, List<Element> skip);
}
