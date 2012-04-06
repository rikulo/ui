//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  9:56:20 AM
// Author: tomyeh

/**
 * The free layout 
 */
class FreeLayout implements Layout {
	Size measureSize(MeasureContext mctx, View view) {
	
	}
	void layout(MeasureContext mctx, View view) {
		if (view.firstChild !== null) {
			final AnchorRelation ar = new AnchorRelation(view);
			for (final View child in ar.indeps)
				layoutManager.sizeByProfile(child, view.width, view.height);

			ar.layoutAnchored(mctx);

			for (final View child in view.children)
				child.doLayout(mctx);
		}
	}
}
