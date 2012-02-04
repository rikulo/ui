//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012

/** A div.
 */
class Div extends Widget {
	Div() {
		wclass = "w-div";
	}

	void redraw_(StringBuffer out, Skipper skipper) {
		out.add('<div').add(domAttrs_()).add('>');
		super.redraw_(out, skipper);
		out.add('</div>');
	}
}
