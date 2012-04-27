//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Apr 12, 2012  4:47:32 PM
// Author: tomyeh

/**
 * Horizontal linear layout.
 */
class _HLayout implements _RealLinearLayout {
	int measureWidth(MeasureContext mctx, View view) {
		final LayoutAmountInfo amtDefault = LinearLayout.getDefaultAmountInfo(view.layout.width);
		final int maxWd = view.parent !== null ? view.parent.innerWidth: browser.size.width;
		final LayoutSideInfo spcinf = new LayoutSideInfo(view.layout.spacing, LinearLayout.DEFAULT_SPACING);
		int width = 0, prevSpacingRight = 0;
		for (final View child in view.children) {
			if (!view.shallLayout_(child) || child.profile.anchorView !== null)
				continue; //ignore anchored

			//add spacing to width
			final LayoutSideInfo si = new LayoutSideInfo(child.profile.spacing, 0, spcinf);
			if ((width += prevSpacingRight + si.left) >= maxWd)
				return maxWd;
			prevSpacingRight = si.right;

			final LayoutAmountInfo amt = new LayoutAmountInfo(child.profile.width);
			if (amt.type == LayoutAmountInfo.NONE) {
				if (child.width != null)  {
					amt.type = LayoutAmountInfo.FIXED;
					amt.value = child.width;
				} else {
					amt.type = amtDefault.type;
					amt.value =  amtDefault.value;
				}
			}

			switch (amt.type) {
			case LayoutAmountInfo.FIXED:
				if ((width += amt.value) >= maxWd)
					return maxWd;
				break;
			case LayoutAmountInfo.CONTENT:
				final int wd = child.measureWidth(mctx);
				if ((width += wd != null ? wd: child.outerWidth) >= maxWd)
					return maxWd;
				break;
			default:
				return maxWd; //fulfill the parent if flex or ratio is used
			}
		}

		width += prevSpacingRight + new DomQuery(view.node).borderWidth * 2;
		return width >= maxWd ? maxWd: width;
	}
	int measureHeight(MeasureContext mctx, View view) {
		final LayoutAmountInfo amtDefault =
			LinearLayout.getDefaultAmountInfo(view.layout.height);
		final LayoutSideInfo spcinf = new LayoutSideInfo(view.layout.spacing, LinearLayout.DEFAULT_SPACING);
		final int borderWd = new DomQuery(view.node).borderWidth * 2;
		int height;
		for (final View child in view.children) {
			if (!view.shallLayout_(child) || child.profile.anchorView !== null)
				continue; //ignore anchored

			//add spacing to width
			final LayoutSideInfo si = new LayoutSideInfo(child.profile.spacing, 0, spcinf);
			int hgh = si.top + si.bottom + borderWd;
			final LayoutAmountInfo amt = new LayoutAmountInfo(child.profile.height);
			if (amt.type == LayoutAmountInfo.NONE) {
				if (child.height != null)  {
					amt.type = LayoutAmountInfo.FIXED;
					amt.value = child.height;
				} else {
					amt.type = amtDefault.type;
					amt.value =  amtDefault.value;
				}
			}

			switch (amt.type) {
			case LayoutAmountInfo.FIXED:
				hgh += amt.value;
				break;
			case LayoutAmountInfo.CONTENT:
				final int h = child.measureHeight(mctx);
				hgh += h != null ? h: child.outerHeight;
				break;
			default:
				continue; //ignore if flex or ratio is used
			}

			if (height == null || hgh > height)
				height = hgh;
		}
		return height;
	}
	//children contains only indepedent views
	void layout(MeasureContext mctx, View view, List<View> children) {
		//1) size
		final AsInt innerWidth = () => view.innerWidth;
		final LayoutSideInfo spcinf = new LayoutSideInfo(view.layout.spacing, LinearLayout.DEFAULT_SPACING);
		final Map<View, LayoutSideInfo> childspcinfs = new Map();
		final List<View> flexViews = new List();
		final List<int> flexs = new List();
		int nflex = 0, assigned = 0, prevSpacingRight = 0;
		for (final View child in children) {
			if (!view.shallLayout_(child)) {
				layoutManager.setWidthByProfile(mctx, child, () => view.innerWidth);
				layoutManager.setHeightByProfile(mctx, child, () => view.innerHeight);
				continue;
			}

			final LayoutSideInfo si = new LayoutSideInfo(child.profile.spacing, 0, spcinf);
			childspcinfs[child] = si;
			assigned += prevSpacingRight + si.left;
			prevSpacingRight = si.right;

			final LayoutAmountInfo amt = new LayoutAmountInfo(child.profile.width);
			switch (amt.type) {
			case LayoutAmountInfo.NONE:
				if (child.width != null)
					assigned += child.width;
				else
					assigned += child.outerWidth;
				break;
			case LayoutAmountInfo.FIXED:
				assigned += child.width = amt.value;
				break;
			case LayoutAmountInfo.FLEX:
				nflex += amt.value;
				flexs.add(amt.value);
				flexViews.add(child);
				break;
			case LayoutAmountInfo.RATIO:
				assigned += child.width = (innerWidth() * amt.value).round().toInt();
				break;
			case LayoutAmountInfo.CONTENT:
				final int wd = child.measureWidth(mctx);
				if (wd != null)
					assigned += child.width = wd;
				else
					assigned += child.outerWidth;
				break;
			}

			final AsInt defaultHeight = () => view.innerHeight - si.top - si.bottom;
			layoutManager.setHeightByProfile(mctx, child, defaultHeight, defaultHeight);
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
				final int delta = (per * flexs[j]).round().toInt();
				flexViews[j].width = delta;
				space -= delta;
			}
		}

		//2) position
		final String defAlign = view.layout.align;
		prevSpacingRight = assigned = 0;
		for (final View child in children) {
			if (!view.shallLayout_(child))
				continue;

			final LayoutSideInfo si = childspcinfs[child];
			child.left = assigned += prevSpacingRight + si.left;
			assigned += child.outerWidth;
			prevSpacingRight = si.right;

			String align = child.profile.align;
			if (align.isEmpty()) align = defAlign;
			final int space = childspcinfs[child].top;
			switch (align) {
			case "center":
			case "end":
				int delta = view.innerHeight - si.top - si.bottom - child.outerHeight;
				if (align == "center") delta ~/= 2;
				child.top = space + delta;
				break; 
			default:
				child.top = space;
			}
		}
	}
}
