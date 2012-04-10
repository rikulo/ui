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

		int wd = _initSize(view.profile.width, () => view.offsetWidth),
			hgh = _initSize(view.profile.height, () => view.offsetHeight);
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
	static int _initSize(String profile, AsInt current) {
		final _SizeInfo szinf = new _SizeInfo(profile);
		final int v = szinf.type == _SizeInfo.FIXED ? szinf.value: current();
		return v != null ? v: Layout.NO_LIMIT;
	}
	void layout(MeasureContext mctx, View view) {
		if (view.firstChild !== null) {
			final AnchorRelation ar = new AnchorRelation(view);
			for (final View child in ar.indeps)
				layoutManager.sizeByProfile(mctx,
					child, () => view.offsetWidth, () => view.offsetHeight);

			ar.layoutAnchored(mctx);

			for (final View child in view.children)
				child.doLayout(mctx);
		}
	}
}
