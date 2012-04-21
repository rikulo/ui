//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Apr 05, 2012 11:25:25 AM
// Author: tomyeh

/**
 * A DOM agent used to provide the additional utilities
 * for handling DOM.
 */
class DomAgent {
	final Element node;

	DomAgent(var v): node = v is View ? v.node: v {}

	/** Returns the offset of this node related to the document.
	 */
	Offset get documentOffset() {
		final Offset ofs = new Offset(0, 0);
		Element el = node;
		do {
			ofs.left += el.$dom_offsetLeft;
			ofs.top += el.$dom_offsetTop;
			if (el.style.position == "fixed") {
				//No need to add widnow's innerLeft/Top since we don't allow
				//window-level scrolling (rather, rootView is scrolled)
				break;
			}
		} while ((el = el.offsetParent) != null);
		return ofs;
	}
	/** Returns the final used values of all the CSS properties
	 */
	CSSStyleDeclaration get computedStyle() 
	=> window.$dom_getComputedStyle(node, "");
	/** Returns the width of the border.
	 */
	int get borderWidth() {
		String wd = computedStyle.borderWidth;
		return wd !== null && !wd.isEmpty() ?
			Math.parseInt(_reNum.firstMatch(wd).group(0)): 0;
	}
	static final RegExp _reNum = const RegExp(@"([0-9]*)");
}
