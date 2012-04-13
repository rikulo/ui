//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 13, 2012  2:40:15 PM
// Author: tomyeh
#library('artra:samples:viewport');

#import('../../client/view/view.dart');
#import('../../client/viewimpl/viewimpl.dart');

/**
 * A view port that demostrates how to use [View.innerLeft]
 * and [View.innerTop], such that the origin of child views
 * is not at the left-top corner of this view.
 */
class Viewport extends InnerOffsetView {
	Viewport(): super(20, 20) {
		vclass = "v-Viewport";
	}

	void domInner_(StringBuffer out) {
		out.add('<div class="v-Viewport-inner" id="')
			.add(uuid).add('-inner" style="left:')
			.add(innerLeft).add('px;top:')
			.add(innerTop).add('px">');
		super.domInner_(out);
		out.add('</div>');
	}
}
