//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 25, 2012  3:52:43 PM
// Author: tomyeh

/**
 * The information of a view that has been cut from another view by
 * [View.cut]. It is used to implement the so-called 'cut-and-paste' feature.
 * Cut-and-paste is used to speed up the detachment and attachment
 * of a view.
 * <p>Use: to cut and paste a view, you can invoke [View.cut] first, and then
 * invoke [pasteTo] to paste it to a parent view you like. For example,
 * <pre><code>view.cut().pasteTo(newParent);</code></pre>
 *
 * <p>The reason that cut-and-paste is more efficiently is the view's DOM elements
 * won't be removed, so [View.exitDocument_], [View.enterDocument_] and
 * other detaching and attaching tasks have no need to take place.
 *
 * <p>If you decide not to paste it to another place, it is better to invoke
 * [drop] to remove DOM elements. It will invoke [View.exitDocument_] such that
 * your application or utility can clean up if necessary. After dropped, the view
 * can be used normally as if they are removed normally (with [View.remove]).
 *
 * <p>Notice that there is one limitation:
 * the view being cut (i.e., [view]) cannot be modified until
 * [pasteTo] or [drop] is called.
 * Furthermore, once [pasteTo] or [drop] is called, the [ViewCut] object can't be used
 * anymore.
 *
 */
interface ViewCut {
	/** The view being cut.
	 */
	View get view();

	/** Pastes the view kept in this [Viewcut] to the given parent view.
	 * The view kept in this object will become a child of the given parent view.
	 * <p>If [beforeChild] is specified, it must be a child of the given parent,
	 * and the view kept in this object will be inserted before it.
	 * <p>Notice that this method can be called only once.
	 */
	void pasteTo(View parent, [View beforeChild]);
	/** Drops the cut.
	 * It will invoke [exitDocument_] and other detaching tasks such
	 * that your application or utilties depending on the exitDocument event
	 * can clean up correctly.
	 * Furthermore, the view can be accessed normall as if the view is removed by [View.remove].
	 */
	void drop();
}
class _ViewCut implements ViewCut {
	final View view;

	_ViewCut(View this.view) {
		final Element n = view.node; //note: it is cached to View._node
		if (n === null)
			throw new UIException("Not in document: $this");

		final View parent = view.parent;
		if (parent !== null) {
			parent._removeChild(view, exit: false); //not to exit
		} else { //TODO: update activity.rootView
			n.remove();
		}
	}
	void pasteTo(View parent, [View beforeChild]) {
		if (!parent.inDocument)
			throw new UIException("Not in document: $parent");
		_check();

		parent._addChild(view, beforeChild, view.node);
	}
	void drop() {
		_check();
		view._exitDocument();
	}
	void _check() {
		if (view.parent !== null || !view.inDocument)
			throw const UIException("Unable to paste drop twice");
	}
}
