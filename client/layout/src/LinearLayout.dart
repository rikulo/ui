//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  4:48:10 PM
// Author: tomyeh

/**
 * The linear layout.
 */
class LinearLayout extends AbstractLayout {
	static final int _NO_SPACING = -10000;
	static final int _DEFAULT_AMOUNT = 30;

	String getDefaultProfileProperty(View view, String name) {
		switch (name) {
		case "height":
			if (_isHorizontal(view))
				return "content";
			//fall thru
		case "width":
			return "flex"; //no matter horizontal or vertical
		}
		return "";
	}

	/** Returns whether the orient is horizontal.
	 */
	static bool _isHorizontal(view) => view.layout.orient == "horizontal";

	int measureWidth(MeasureContext mctx, View view) {
		int width = mctx.widths[view];
		if (width !== null || mctx.widths.containsKey(view))
			return width;

		width = _isHorizontal(view) ? _measureHWidth(mctx, view): _measureVWidth(mctx, view);
		mctx.widths[view] = width;
		return width;
	}
	int measureHeight(MeasureContext mctx, View view) {
		int height = mctx.heights[view];
		if (height !== null || mctx.heights.containsKey(view))
			return height;

//		height = _isHorizontal(view) ? _measureHHeight(mctx, view): _measureVHeight(mctx, view);
		mctx.heights[view] = height;
		return height;
	}
	int _measureHWidth(MeasureContext mctx, View view) {
		final _AmountInfo amtDefault = _getDefaultAmountInfo(view);
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
		print("$maxWd");

		return wd;
	}
	int _measureVWidth(MeasureContext mctx, View view) {
	}
	_AmountInfo _getDefaultAmountInfo(View view) {
		final _AmountInfo amtDefault = new _AmountInfo(view.layout.width);
		if (amtDefault.type == _AmountInfo.NONE) {
			amtDefault.type == _AmountInfo.FIXED;
			amtDefault.value = _DEFAULT_AMOUNT;
		}
		return amtDefault;
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
