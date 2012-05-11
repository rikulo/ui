//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Apr 05, 2012 11:25:25 AM
// Author: tomyeh

/**
 * A DOM query agent used to provide the additional utilities
 * for handling DOM.
 */
class DomQuery {
	/** The DOM element in query. */
	final node;

	factory DomQuery(var v) {
		v = v is View ? v.node: v is String ? document.query(v): v;
		return v is Window ? new _WindowQuery._with(v): new DomQuery._with(v);
	}

	DomQuery._with(this.node) {
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
	/** Returns the closest ancestor elemento in the DOM hierachy from
	 * which the position of the current element is calculated, or null
	 * if it is the topmost element.
	 * <p>Use [offsetLeft] and [offsetTop] to retrieve the position of
	 * the top-left corner of an object relative to the top-left corner
	 * of its offset parent object.
	 */
	Element get offsetParent() => node.offsetParent;
	/** Returns the left position of this element relative to the left side of
	 * its [offsetParent] element.
	 */
	int get offsetLeft() => node.$dom_offsetLeft;
	/** Returns the left position of this element relative to the top side of
	 * its [offsetParent] element.
	 */
	int get offsetTop() => node.$dom_offsetTop;

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

	/** Returns if a DOM element is a descendant of this element or
	 * it is identical to this element.
	 */
	bool isDescendantOf(Element parent) {
		for (Element n = node; n !== null; n = n.parent) {
			if (n === parent)
				return true;
		}
		return false;
	}
	/** Returns the nearest view containing this element.
	 */
	/** View.getView(uuid) not supported yet (because of memory overhead)
	View get view() {
		for (Element n = node; n !== null && n !== document.body
		&& n !== document; n = n.parent) {
			final String id = n.id;
			if (id !== null && !id.isEmpty()) {
				final View view = View.getView(id);
				if (view !== null)
					return view;
			}
		}
		return null;
	}*/

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
	_WindowQuery._with(var v): super._with(v) {}

	//@Override
	int get innerWidth() => node.innerWidth;
	//@Override
	int get innerHeight() => node.innerHeight;
	//@Override
	int get outerWidth() => node.outerWidth;
	//@Override
	int get outerHeight() => node.outerHeight;
	//@Override
	Element get offsetParent() => null;
}
