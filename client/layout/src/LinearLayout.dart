//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  4:48:10 PM
// Author: tomyeh

/**
 * The linear layout.
 */
class LinearLayout implements Layout {
	static final int _NO_SPACING = -10000;
	static final int _DEFAULT_AMOUNT = 30;

	Size measureSize(MeasureContext mctx, View view) {
		Size size = mctx.measures[view];
		if (size !== null)
			return size;

		size = view.layout.orient == "horizontal" ?
				_measureHSize(mctx, view): _measureVSize(mctx, view);
		mctx.measures[view] = size;
		return size;
	}
	Size _measureHSize(MeasureContext mctx, View view) {
		final _AmountInfo amtDefault = new _AmountInfo(view.layout.width);
		if (amtDefault.type == _AmountInfo.NONE) {
			amtDefault.type == _AmountInfo.FIXED;
			amtDefault.value = _DEFAULT_AMOUNT;
		}

		final int maxWd = view.parent !== null ? view.parent.innerWidth: device.screen.width;
		final _SideInfo spacing = new _SideInfo(view.profile.spacing, 2);
		int wd = 0, spacingRight = _NO_SPACING, hgh = 0;
		for (final View child in view.children) {
			if (child.profile.anchorView !== null)
				continue; //ignore anchored

			final _SideInfo spc = new _SideInfo(child.profile.spacing, _NO_SPACING);
			//1) calculate width
			if (wd < maxWd) {
				//add spacing to wd
				if (spacingRight != _NO_SPACING)
					wd += spacingRight + (spc.left != _NO_SPACING ? spc.left: spacing.left);
				spacingRight = spc.right != _NO_SPACING ? spc.right: spacing.right;

				final _AmountInfo amt = new _AmountInfo(child.profile.width);
				if (amt.type == _AmountInfo.NONE) {
					amt.type = amtDefault.type;
					amt.value = amtDefault.value;
				}

				switch (amt.type) {
				case _AmountInfo.FIXED:
					if ((wd += amt.value) >= maxWd)
						wd = maxWd;
					break;
				case _AmountInfo.CONTENT:
					
				default:
					//fulfill the parent if flex or ratio is used
					wd = maxWd;
				}
			}
		}

		return new Size(wd, hgh);
	}
	Size _measureVSize(MeasureContext mctx, View view) {
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
