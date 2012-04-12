//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  9:56:20 AM
// Author: tomyeh

/**
 * The free layout (default).
 */
class FreeLayout extends AbstractLayout {
	int measureWidth(MeasureContext mctx, View view) {
		int wd = mctx.widths[view];
		if (wd !== null || mctx.widths.containsKey(view))
			return wd;

		wd = _initSize(view.profile.width, () => view.innerWidth);
		for (final View child in view.children) {
			if (child.profile.anchorView == null && child.style.position != "fixed") {
				int subsz = child.measureWidth(mctx);
				subsz = child.left + (subsz !== null ? subsz: 0);
				if (wd == null || subsz > wd)
					wd = subsz;
			}
		}

		mctx.widths[view] = wd;
		return wd;
	}
	int measureHeight(MeasureContext mctx, View view) {
		int hgh = mctx.heights[view];
		if (hgh !== null || mctx.heights.containsKey(view))
			return hgh;

		hgh = _initSize(view.profile.height, () => view.innerHeight);
		for (final View child in view.children) {
			if (child.profile.anchorView == null && child.style.position != "fixed") {
				int subsz = child.measureHeight(mctx);
				subsz = child.top + (subsz !== null ? subsz: 0);
				if (hgh == null || subsz > hgh)
					hgh = subsz;
			}
		}

		mctx.heights[view] = hgh;
		return hgh;
	}
	static int _initSize(String profile, AsInt current) {
		final _AmountInfo szinf = new _AmountInfo(profile);
		final int v = szinf.type == _AmountInfo.FIXED ? szinf.value: current();
		return v != null ? v: null;
	}
	void layout(MeasureContext mctx, View view) {
		if (view.firstChild !== null) {
			final AnchorRelation ar = new AnchorRelation(view);
			for (final View child in ar.indeps)
				layoutManager.sizeByProfile(mctx,
					child, () => view.innerWidth, () => view.innerHeight);

			ar.layoutAnchored(mctx);

			for (final View child in view.children)
				child.doLayout(mctx);
		}
	}
}
