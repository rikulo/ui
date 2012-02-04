//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 11, 2012

/** A skipper is used with [Widget] to rerender portion(s) of a widget
 * (rather than the whole widget).
 * 
 */
interface Skipper {
	/** Returns whether the specified child widget will be skipped by [skip].
	 */
	bool isSkipped(Widget wgt, Widget child);
	/** Skips all or subset of the descendant widgets of the given widget,
	 * and returns the DOM elements that shall be reserved and restored by [restore].
	 */
	List<Element> skip(Widget wgt);
	/** Restores the DOM elements returned by [skip].
	 */
	void restore(Widget wgt, List<Element> skip);
}
