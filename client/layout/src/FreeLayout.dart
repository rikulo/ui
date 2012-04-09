//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  9:56:20 AM
// Author: tomyeh

/**
 * The free layout (default).
 */
class FreeLayout implements Layout {
	Size measureSize(MeasureContext mctx, View view) {
		Size size = mctx.measures[view];
		if (size !== null)
			return size;

		int wd = view.width, hgh = view.height;
		if (wd === null) wd = NO_LIMIT;
		if (hgh === null) hgh = NO_LIMIT;
		for (final View child in view.children) {
			if (child.profile.anchorView == null && child.style.position != "fixed") {
				final Size subsz = child.measureSize(mctx);
				int v = subsz != null ? subsz.width: null;
				v = child.left + (v !== null ? v: 0);
				if (v > wd) wd = v;

				v = subsz != null ? subsz.height: null;
				v = child.top + (v !== null ? v: 0);
				if (v > hgh) hgh = v;
			}
		}

		size = new Size(wd, hgh);
		mctx.measures[view] = size;
		return size;
	}
	void layout(MeasureContext mctx, View view) {
		if (view.firstChild !== null) {
			final AnchorRelation ar = new AnchorRelation(view);
			for (final View child in ar.indeps)
				layoutManager.sizeByProfile(mctx,
					child, () => view.width, () => view.height);

			ar.layoutAnchored(mctx);

			for (final View child in view.children)
				child.doLayout(mctx);
		}
	}
}
