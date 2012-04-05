//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Apr 05, 2012 11:25:25 AM
// Author: tomyeh

/**
 * A DOM agent used to provide the additional utilities
 * for handling DOM.
 */
class DomAgent {
	final Element node;

	DomAgent(this.node);

	/** Returns the offset of this node related to the document.
	 */
	Offset get documentOffset() {
		final Offset ofs = new Offset(0, 0);
		Element el = node;
		do {
			ofs.left += el.$dom_offsetLeft;
			ofs.top += el.$dom_offsetTop;
		} while (el.style.position != "fixed" && (el = el.offsetParent) != null);
		return ofs;
	}
}
