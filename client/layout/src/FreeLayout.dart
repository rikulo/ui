//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  9:56:20 AM
// Author: tomyeh

/**
 * The free layout 
 */
class FreeLayout implements Layout {
	Size measure(MeasureContext mctx, View view) {
	
	}
	void layout(MeasureContext mctx, View view) {
		if (view.firstChild !== null) {
			final AnchorRelation ar = new AnchorRelation(view);
			ar.layoutIndeps(mctx);
			ar.layoutAnchored(mctx);

			for (final View child in view.children)
				child.doLayout(mctx);
		}
	}
}
