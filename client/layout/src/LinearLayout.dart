//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  4:48:10 PM
// Author: tomyeh

/**
 * The linear layout.
 */
class LinearLayout implements Layout {
	Size measureSize(MeasureContext mctx, View view) {
		final Size size = mctx.measures[view];
		return size !== null ? size: 
			view.layout.orient == "horizontal" ?
				_measureHSize(mctx, view): _measureVSize(mctx, view);
	}
	Size _measureHSize(MeasureContext mctx, View view) {
		final Size size = new Size(0, 0);
		int wdTotal = 0, wdLeft = mctx.max.width, flexTotal = 0;
		final List<View> hflexViews = [];
		for (final View child in view.children) {
			if (child.profile.anchorView === null) { //not depending
				String val = child.profile.width.trim();
				if (val.startsWith("flex")) {
					print("$child $val");
				} else if (val == "content") {
				} else {
				}

				val = child.profile.height.trim();
				if (val.startsWith("flex")) {
				} else {
				}
			}
		}

		if (mctx.max.height != NO_LIMIT && mctx.max.height < size.height)
			size.height = mctx.max.height;
		else if (mctx.min.height > size.height)
			size.height = mctx.min.height;
		mctx.measures[view] = size;
		return size;
	}
	Size _measureVSize(MeasureContext mctx, View view) {
		final Size size = new Size(0, 0);
		mctx.measures[view] = size;
		return size;
	}
	void layout(MeasureContext mctx, View view) {
		if (view.firstChild !== null) {
			final AnchorRelation ar = new AnchorRelation(view);

			//1) size
			for (final View child in ar.indeps) {
			}

			//2) position
			for (final View child in ar.indeps) {
			}

			//3) do anchored
			ar.layoutAnchored(mctx);

			//4) pass control to children
			for (final View child in view.children)
				child.doLayout(mctx);
		}
	}
}
