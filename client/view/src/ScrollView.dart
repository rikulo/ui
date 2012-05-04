//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 03, 2012  3:21:34 PM
// Author: tomyeh

/**
 * A view container that can be scrolled by the user.
 */
class ScrollView extends View {
	Scroller _scroller;

	ScrollView() {
		vclass = "v-ScrollView";
	}

	//@Override
	void enterDocument_() {
		super.enterDocument_();
		_scroller = new Scroller(innerNode);
	}
	//@Override
	void exitDocument_() {
		_scroller.destroy();
		_scroller = null;
		super.enterDocument_();
	}
	//@Override
	void draw(StringBuffer out) {
		final String tag = domTag_;
		out.add('<').add(tag);
		domAttrs_(out);
		out.add('><div class="v-ScrollView-inner" id="')
			.add(uuid).add('-inner">');
		domInner_(out);
		out.add('</div></').add(tag).add('>');
	}
	//@Override
	Element get innerNode() => getNode("inner");
	//@Override
	void adjustInnerNode_([bool left=false, bool top=false, bool width=false, bool height=false]) {
		//nothing to do since it is controlled by CSS (and handled by browser)
	}
}
