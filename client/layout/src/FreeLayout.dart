//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  9:56:20 AM
// Author: tomyeh

/**
 * The free layout 
 */
class FreeLayout implements Layout {
	Size measure(MeasureContext ctx, View view) {
	
	}
	void layout(MeasureContext ctx, View view) {
		final AnchorRelation ar = new AnchorRelation(view);
		ar.layout(ar.independences, null, noPosition:true);
	}
}
