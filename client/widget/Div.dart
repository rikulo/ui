//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012
#library("artra:widget:Div");

#import("Widget.dart");

/** A div.
 */
class Div extends Widget {
	Div() {
		wclass = "w-div";
	}

	void redraw_(StringBuffer out) {
		out.add('<div').add(domAttrs_()).add('>');
		super.redraw_(out);
		out.add('</div>');
	}
}
