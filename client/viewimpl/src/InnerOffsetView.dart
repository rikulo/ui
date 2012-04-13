//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 13, 2012  4:52:38 PM
// Author: tomyeh

/**
 * A skeleton for implementing views that support [innerLeft]
 * and [innerTop].
 * The deriving class has to override [drawInner_] to enclose
 * the child view with a DOM element identified as "$uuid-inner".
 * Furthermore, the position of the DOM element has to be "absolute".
 */
class InnerOffsetView extends View {
	int _innerLeft, _innerTop;

	InnerOffsetView(int innerLeft, int innerTop) {
		_innerLeft = innerLeft;
		_innerTop = innerTop;
	}

	//@Override
	int get innerLeft() => _innerLeft;
	//@Override
	int get innerTop() => _innerTop;
	//@Override
	void set innerLeft(int left) {
		_innerLeft = left;
		Element inner = innerNode;
		if (inner !== null)
			inner.style.left = "${left}px";
	}
	//@Override
	void set innerTop(int top) {
		_innerLeft = top;
		Element inner = innerNode;
		if (inner !== null)
			inner.style.top = "${top}px";
	}
	/** Returns the element representing the inner element.
	 */
	Element get innerNode() => getNode("inner");
}
