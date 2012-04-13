//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 13, 2012  4:52:38 PM
// Author: tomyeh

/**
 * A skeleton for implementing views that support [innerLeft]
 * and [innerTop].
 * <p>The deriving class has to override [domInner_] to enclose
 * the child view with a DOM element identified as "$uuid-inner".
 * Notice that the position of the DOM element has to be "absolute".
 * <p>If some of child views are <i>not</i> placed in the inner element,
 * the derving class shall override [shallLayout_] to skip the child views
 * not in the inner element from being handled by the layout manager.
 * <p>For a sample of implementation, you can refer to the viewport sample.
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
	//@Override
	/** Returns the element representing the inner element.
	 */
	Element get innerNode() => getNode("inner");

	//@Override
	int get innerWidth() {
		final int v = super.innerWidth - innerSpacing_.width;
		return v > 0 ? v: 0;
	}
	//@Override
	int get innerHeight() {
		final int v = super.innerHeight - innerSpacing_.height;
		return v > 0 ? v: 0;
	}

	//@Override
	void set width(int w) {
		super.width = w;
		Element inner = innerNode;
		if (inner !== null)
			inner.style.width = "${innerWidth}px";
	}
	//@Override
	void set height(int h) {
		super.height = h;
		Element inner = innerNode;
		if (inner !== null)
			inner.style.height = "${innerHeight}px";
	}

	/** Returns the spacing between the inner element and the border.
	 * <p>Default: <code>new Size(innerLeft, innerTop)</code>
	 * <p>Notice: instead of overriding [width] and [height], you
	 * shall override this method if the spacing is more than
	 * [innerLeft] and [innerTop].
	 */
	Size get innerSpacing_() => new Size(_innerLeft, _innerTop);
}
