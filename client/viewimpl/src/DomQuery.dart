//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Apr 05, 2012 11:25:25 AM
// Author: tomyeh

/**
 * A DOM query agent used to provide the additional utilities
 * for handling DOM.
 */
class DomQuery {
	final node;

	factory DomQuery(var v) {
		v = v is View ? v.node: v is String ? document.query(v): v;
		return v is Window ? new _WindowQuery._from(v): new DomQuery._from(v);
	}

	DomQuery._from(this.node) {
	}

	/** Returns the inner width of the given element, including padding
	 * but not border.
	 */
	int get innerWidth() => node.$dom_clientWidth;
	/** Returns the inner width of the given element, including padding
	 * but not border.
	 */
	int get innerHeight() => node.$dom_clientHeight;
	/** Returns the other width of the given element, including padding,
	 * border and margin.
	 */
	int get outerWidth() => node.$dom_offsetWidth;
	/** Returns the other width of the given element, including padding,
	 * border and margin.
	 */
	int get outerHeight() => node.$dom_offsetHeight;

	/** Returns the offset of this node related to the document.
	 */
	Offset get documentOffset() {
		final Offset ofs = new Offset(0, 0);
		Element el = node;
		do {
			ofs.left += el.$dom_offsetLeft;
			ofs.top += el.$dom_offsetTop;
		} while (el.style.position != "fixed" && (el = el.offsetParent) != null);
		//Note: no need to add widnow's innerLeft/Top if position is fixed.
		//reason: we don't allow window-level scrolling (rather, rootView is scrolled)
		return ofs;
	}
	/** Returns the final used values of all the CSS properties
	 */
	CSSStyleDeclaration get computedStyle() 
	=> window.$dom_getComputedStyle(node, "");

	/** Returns the width of the border.
	 */
	int get borderWidth() => _parseInt(computedStyle.borderWidth);
	/** Returns the size of the padding at left.
	 */
	int get paddingLeft() => _parseInt(computedStyle.paddingLeft);
	/** Returns the size of the padding at right.
	 */
	int get paddingRight() => _parseInt(computedStyle.paddingRight);
	/** Returns the size of the padding at top.
	 */
	int get paddingTop() => _parseInt(computedStyle.paddingTop);
	/** Returns the size of the padding at bottom.
	 */
	int get paddingBottom() => _parseInt(computedStyle.paddingBottom);

	static int _parseInt(String val)
	=> val !== null && !val.isEmpty() ?
		Math.parseInt(_reNum.firstMatch(val).group(0)): 0;
	static final RegExp _reNum = const RegExp(@"([0-9]*)");
}
class _WindowQuery extends DomQuery {
	_WindowQuery._from(var v): super._from(v) {}

	//@Override
	int get innerWidth() => node.innerWidth;
	//@Override
	int get innerHeight() => node.innerHeight;
	//@Override
	int get outerWidth() => node.outerWidth;
	//@Override
	int get outerHeight() => node.outerHeight;
}
