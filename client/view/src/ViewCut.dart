//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 25, 2012  3:52:43 PM
// Author: tomyeh

/**
 * The information of a view that has been cut from another view by
 * [View.cut]. It is used to implement the so-called 'cut-and-paste' feature.
 * Cut-and-paste is used to speed up the detachment and attachment
 * of a view more efficiently. However, there is one limitation:
 * the view being cut (i.e., [view]) cannot be modified until
 * [paste] is called.
 * Furthermore, once [paste] is called, the [ViewCut] object can't be used
 * anymore.
 *
 * <p>The reason that cut-and-paste is more efficiently is the view's DOM elements
 * won't be removed, so [View.exitDocument_], [View.enterDocument_] and
 * other detaching and attaching tasks no need to take place.
 */
interface ViewCut {
	/** The view being cut.
	 */
	View get view();

	/** Pastes the view being cut ([view]) to be the child of the given view
	 * ([parent]).
	 * This method can be called only once.
	 */
	void pasteTo(View parent, View insertBefore);
}
class _ViewCut implements ViewCut {
	final View view;

	_ViewCut(View this.view);

	void pasteTo(View parent, View insertBefore) {
	}
}
