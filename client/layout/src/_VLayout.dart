//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Apr 12, 2012  4:49:52 PM
// Author: tomyeh

/**
 * Vertical linear layout.
 */
class _VLayout implements _LinearLayout {
	int measureHeight(MeasureContext mctx, View view) {
		final _AmountInfo amtDefault = LinearLayout.getDefaultAmountInfo(view.layout.height, 0);
		final int maxHgh = view.parent !== null ? view.parent.innerHeight: device.screen.height;
		final _SideInfo spcinf = new _SideInfo(view.layout.spacing, LinearLayout.DEFAULT_SPACING);
		int height = 0, prevSpacingBottom = 0;
		for (final View child in view.children) {
			if (!view.shallLayout_(child) || child.profile.anchorView !== null)
				continue; //ignore anchored

			//add spacing to height
			final _SideInfo si = new _SideInfo(child.profile.spacing, 0, spcinf);
			if ((height += prevSpacingBottom + si.top) >= maxHgh)
				return maxHgh;
			prevSpacingBottom = si.bottom;

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
				if ((height += amt.value) >= maxHgh)
					return maxHgh;
				break;
			case _AmountInfo.CONTENT:
				final int hgh = child.measureHeight(mctx);
				if ((height += hgh != null ? hgh: amtDefault.value) >= maxHgh)
					return maxHgh;
				break;
			default:
				return maxHgh; //fulfill the parent if flex or ratio is used
			}
		}

		height += prevSpacingBottom;
		return height >= maxHgh ? maxHgh: height;
	}
	int measureWidth(MeasureContext mctx, View view) {
		final _AmountInfo amtDefault =
			LinearLayout.getDefaultAmountInfo(view.layout.width, LinearLayout.DEFAULT_AMOUNT);
		final _SideInfo spcinf = new _SideInfo(view.layout.spacing, LinearLayout.DEFAULT_SPACING);
		int width;
		for (final View child in view.children) {
			if (!view.shallLayout_(child) || child.profile.anchorView !== null)
				continue; //ignore anchored

			//add spacing to height
			final _SideInfo si = new _SideInfo(child.profile.spacing, 0, spcinf);
			int wd = si.left + si.right;
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
				wd += amt.value;
				break;
			case _AmountInfo.CONTENT:
				final int w = child.measureWidth(mctx);
				wd += w != null ? w: amtDefault.value;
				break;
			default:
				continue; //ignore if flex or ratio is used
			}
			if (width == null || wd > width)
				width = wd;
		}
		return width;
	}
	//children contains only indepedent views
	void layout(MeasureContext mctx, View view, List<View> children) {
		//1) size
		final AsInt innerHeight = () => view.innerHeight;
		final _SideInfo spcinf = new _SideInfo(view.layout.spacing, LinearLayout.DEFAULT_SPACING);
		final Map<View, _SideInfo> childspcinfs = new Map();
		final List<View> flexViews = new List();
		final List<int> flexs = new List();
		int nflex = 0, assigned = 0, prevSpacingBottom = 0;
		for (final View child in children) {
			if (!view.shallLayout_(child)) {
				layoutManager.setWidthByProfile(mctx, child, () => view.innerWidth);
				layoutManager.setHeightByProfile(mctx, child, () => view.innerHeight);
				continue;
			}

			final _SideInfo si = new _SideInfo(child.profile.spacing, 0, spcinf);
			childspcinfs[child] = si;
			assigned += prevSpacingBottom + si.top;
			prevSpacingBottom = si.bottom;

			final _AmountInfo amt = new _AmountInfo(child.profile.height);
			switch (amt.type) {
			case _AmountInfo.FIXED:
				assigned += child.height = amt.value;
				break;
			case _AmountInfo.FLEX:
				nflex += amt.value;
				flexs.add(amt.value);
				flexViews.add(child);
				break;
			case _AmountInfo.RATIO:
				assigned += child.height = (innerHeight() * amt.value).round();
				break;
			case _AmountInfo.CONTENT:
				final int hgh = child.measureHeight(mctx);
				if (hgh != null)
					assigned += child.height = hgh;
				else
					assigned += child.outerHeight;
				break;
			}

			layoutManager.setWidthByProfile(mctx, child, () => view.innerWidth - si.left - si.right);
		}

		//1a) size flex
		if (nflex > 0) {
			int space = innerHeight() - assigned - prevSpacingBottom;
			double per = space / nflex;
			for (int j = 0, len = flexs.length - 1;; ++j) {
				if (j == len) { //last
					flexViews[j].height = space;
					break;
				}
				final num delta = (per * flexs[j]).round();
				flexViews[j].height = delta;
				space -= delta;
			}
		}

		//2) position
		final String defAlign = view.layout.align;
		prevSpacingBottom = assigned = 0;
		for (final View child in children) {
			if (!view.shallLayout_(child))
				continue;

			final _SideInfo si = childspcinfs[child];
			child.top = assigned += prevSpacingBottom + si.top;
			assigned += child.outerHeight;
			prevSpacingBottom = si.bottom;

			String align = child.profile.align;
			if (align.isEmpty()) align = defAlign;
			final int space = childspcinfs[child].left;
			switch (align) {
			case "center":
			case "end":
				int delta = view.innerWidth - si.left - si.right - child.outerWidth;
				if (align == "center") delta ~/= 2;
				child.left = space + delta;
				break; 
			default:
				child.left = space;
			}
		}
	}
}
