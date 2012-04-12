//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  4:48:10 PM
// Author: tomyeh

/**
 * The linear layout.
 */
class LinearLayout extends AbstractLayout {
	static final int _DEFAULT_AMOUNT = 30;
	static final int _DEFAULT_SPACING = 2;

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

		width = _isHorizontal(view) ? _measureHrWidth(mctx, view): _measureVtWidth(mctx, view);
		print("wd: $width");
		mctx.widths[view] = width;
		return width;
	}
	int measureHeight(MeasureContext mctx, View view) {
		int height = mctx.heights[view];
		if (height !== null || mctx.heights.containsKey(view))
			return height;

		height = _isHorizontal(view) ? _measureHrHeight(mctx, view): _measureVtHeight(mctx, view);
		print("hgh: $height");
		mctx.heights[view] = height;
		return height;
	}
	int _measureHrWidth(MeasureContext mctx, View view) {
		final _AmountInfo amtDefault = _getDefaultAmountInfo(view.layout.width, 0);
		final int maxWd = view.parent !== null ? view.parent.innerWidth: device.screen.width;
		final _SideInfo spcinf = new _SideInfo(view.layout.spacing, _DEFAULT_SPACING);
		int width = 0, prevSpacingRight = 0;
		for (final View child in view.children) {
			if (child.profile.anchorView !== null)
				continue; //ignore anchored

			//add spacing to width
			final _SideInfo si = new _SideInfo(child.profile.spacing, 0, spcinf);
			if ((width += prevSpacingRight + si.left) >= maxWd)
				return maxWd;
			prevSpacingRight = si.right;

			final _AmountInfo amt = new _AmountInfo(child.profile.width);
			if (amt.type == _AmountInfo.NONE) {
				if (child.width != null)  {
					amt.type = _AmountInfo.FIXED;
					amt.value = child.width;
				} else {
					amt.type = amtDefault.type;
					amt.value =  amtDefault.value;
				}
			}

			switch (amt.type) {
			case _AmountInfo.FIXED:
				if ((width += amt.value) >= maxWd)
					return maxWd;
				break;
			case _AmountInfo.CONTENT:
				final int wd = child.measureWidth(mctx);
				if ((width += wd != null ? wd: amtDefault.value) >= maxWd)
					return maxWd;
				break;
			default:
				return maxWd; //fulfill the parent if flex or ratio is used
			}
		}

		width += prevSpacingRight;
		return width >= maxWd ? maxWd: width;
	}
	int _measureHrHeight(MeasureContext mctx, View view) {
		final _AmountInfo amtDefault = _getDefaultAmountInfo(view.layout.height, _DEFAULT_AMOUNT);
		final _SideInfo spcinf = new _SideInfo(view.layout.spacing, _DEFAULT_SPACING);
		int height;
		for (final View child in view.children) {
			if (child.profile.anchorView !== null)
				continue; //ignore anchored

			//add spacing to width
			final _SideInfo si = new _SideInfo(child.profile.spacing, 0, spcinf);
			int hgh = si.top + si.bottom;
			final _AmountInfo amt = new _AmountInfo(child.profile.height);
			if (amt.type == _AmountInfo.NONE) {
				if (child.height != null)  {
					amt.type = _AmountInfo.FIXED;
					amt.value = child.height;
				} else {
					amt.type = amtDefault.type;
					amt.value =  amtDefault.value;
				}
			}

			switch (amt.type) {
			case _AmountInfo.FIXED:
				hgh += amt.value;
				break;
			case _AmountInfo.CONTENT:
				final int h = child.measureHeight(mctx);
				hgh += h != null ? h: amtDefault.value;
				break;
			default:
				continue; //ignore if flex or ratio is used
			}
			if (height == null || hgh > height)
				height = hgh;
		}
		return height;
	}
	int _measureVtWidth(MeasureContext mctx, View view) {
	}
	int _measureVtHeight(MeasureContext mctx, View view) {
	}
	_AmountInfo _getDefaultAmountInfo(String info, int defValue) {
		final _AmountInfo amt = new _AmountInfo(info);
		if (amt.type == _AmountInfo.NONE) {
			amt.type = _AmountInfo.FIXED;
			amt.value = defValue;
		}
		return amt;
	}

	void layout(MeasureContext mctx, View view) {
		if (view.firstChild !== null) {
			final AnchorRelation ar = new AnchorRelation(view);

			//1) layout independents
			if (_isHorizontal(view)) _hlayout(mctx, view, ar.indeps);
			else _vlayout(mctx, view, ar.indeps);

			//2) do anchored
			ar.layoutAnchored(mctx);

			//3) pass control to children
			for (final View child in view.children)
				child.doLayout(mctx);
		}
	}
	void _hlayout(MeasureContext mctx, View view, List<View> children) {
		//1) size
		final AsInt innerWidth = () => view.innerWidth;
		final _SideInfo spcinf = new _SideInfo(view.layout.spacing, _DEFAULT_SPACING);
		final Map<View, _SideInfo> childspcinfs = new Map();
		final List<View> flexViews = new List();
		final List<int> flexs = new List();
		int nflex = 0, assigned = 0, prevSpacingRight = 0;
		for (final View child in children) {
			final _SideInfo si = new _SideInfo(child.profile.spacing, 0, spcinf);
			childspcinfs[child] = si;
			assigned += prevSpacingRight + si.left;
			prevSpacingRight = si.right;

			final _AmountInfo amt = new _AmountInfo(child.profile.width);
			switch (amt.type) {
			case _AmountInfo.FIXED:
				assigned += child.width = amt.value;
				break;
			case _AmountInfo.FLEX:
				nflex += amt.value;
				flexs.add(amt.value);
				flexViews.add(child);
				break;
			case _AmountInfo.RATIO:
				assigned += child.width = (innerWidth() * amt.value).round();
				break;
			case _AmountInfo.CONTENT:
				final int wd = child.measureWidth(mctx);
				if (wd != null)
					assigned += child.width = wd;
				else
					assigned += child.outerWidth;
				break;
			}

			layoutManager.setHeightByProfile(mctx, child, () => view.innerHeight - si.top - si.bottom);
		}

		//1a) size flex
		if (nflex > 0) {
			int space = innerWidth() - assigned - prevSpacingRight;
			double per = space / nflex;
			for (int j = 0, len = flexs.length - 1;; ++j) {
				if (j == len) { //last
					flexViews[j].width = space;
					break;
				}
				final num delta = (per * flexs[j]).round();
				flexViews[j].width = delta;
				space -= delta;
			}
		}

		//2) position
		prevSpacingRight = assigned = 0;
		for (final View child in children) {
			final _SideInfo si = childspcinfs[child];
			child.left = assigned += prevSpacingRight + si.left;
			assigned += child.width;
			prevSpacingRight = si.right;
			child.top = childspcinfs[child].top; //TODO: handle align
		}
	}
	void _vlayout(MeasureContext mctx, View view, List<View> children) {
	}
}
