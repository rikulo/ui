//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Apr 12, 2012  4:49:52 PM
// Author: tomyeh

/**
 * Vertical linear layout.
 */
class _VLayout implements _RealLinearLayout {
	int measureHeight(MeasureContext mctx, View view) {
		final LayoutAmountInfo amtDefault = LinearLayout.getDefaultAmountInfo(view.layout.height);
		final int maxHgh = view.parent !== null ? view.parent.innerHeight: browser.size.height;
		final LayoutSideInfo spcinf = new LayoutSideInfo(view.layout.spacing, LinearLayout.DEFAULT_SPACING);
		int height = 0, prevSpacingBottom = 0;
		for (final View child in view.children) {
			if (!view.shallLayout_(child) || child.profile.anchorView !== null)
				continue; //ignore anchored

			//add spacing to height
			final LayoutSideInfo si = new LayoutSideInfo(child.profile.spacing, 0, spcinf);
			if ((height += prevSpacingBottom + si.top) >= maxHgh)
				return maxHgh;
			prevSpacingBottom = si.bottom;

			final LayoutAmountInfo amt = new LayoutAmountInfo(child.profile.height);
			if (amt.type == LayoutAmountType.NONE) {
				if (child.height != null)  {
					amt.type = LayoutAmountType.FIXED;
					amt.value = child.height;
				} else {
					amt.type = amtDefault.type;
					amt.value =  amtDefault.value;
				}
			}

			switch (amt.type) {
				case LayoutAmountType.FIXED:
					if ((height += amt.value) >= maxHgh)
						return maxHgh;
					break;
				case LayoutAmountType.CONTENT:
					final int hgh = child.measureHeight(mctx);
					if ((height += hgh != null ? hgh: child.outerHeight) >= maxHgh)
						return maxHgh;
					break;
				default:
					return maxHgh; //fulfill the parent if flex or ratio is used
			}
		}

		height += prevSpacingBottom + new DomQuery(view.node).borderWidth * 2;
		return height >= maxHgh ? maxHgh: height;
	}
	int measureWidth(MeasureContext mctx, View view) {
		final LayoutAmountInfo amtDefault =
			LinearLayout.getDefaultAmountInfo(view.layout.width);
		final LayoutSideInfo spcinf = new LayoutSideInfo(view.layout.spacing, LinearLayout.DEFAULT_SPACING);
		final int borderWd = new DomQuery(view.node).borderWidth * 2;
		int width;
		for (final View child in view.children) {
			if (!view.shallLayout_(child) || child.profile.anchorView !== null)
				continue; //ignore anchored

			//add spacing to height
			final LayoutSideInfo si = new LayoutSideInfo(child.profile.spacing, 0, spcinf);
			int wd = si.left + si.right + borderWd;
			final LayoutAmountInfo amt = new LayoutAmountInfo(child.profile.width);
			if (amt.type == LayoutAmountType.NONE) {
				if (child.width != null)  {
					amt.type = LayoutAmountType.FIXED;
					amt.value = child.width;
				} else {
					amt.type = amtDefault.type;
					amt.value =  amtDefault.value;
				}
			}

			switch (amt.type) {
				case LayoutAmountType.FIXED:
					wd += amt.value;
					break;
				case LayoutAmountType.CONTENT:
					final int w = child.measureWidth(mctx);
					wd += w != null ? w: child.outerWidth;
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
		final LayoutSideInfo spcinf = new LayoutSideInfo(view.layout.spacing, LinearLayout.DEFAULT_SPACING);
		final Map<View, LayoutSideInfo> childspcinfs = new Map();
		final List<View> flexViews = new List();
		final List<int> flexs = new List();
		int nflex = 0, assigned = 0, prevSpacingBottom = 0;
		for (final View child in children) {
			if (!view.shallLayout_(child)) {
				layoutManager.setWidthByProfile(mctx, child, () => view.innerWidth);
				layoutManager.setHeightByProfile(mctx, child, () => view.innerHeight);
				continue;
			}

			final LayoutSideInfo si = new LayoutSideInfo(child.profile.spacing, 0, spcinf);
			childspcinfs[child] = si;
			assigned += prevSpacingBottom + si.top;
			prevSpacingBottom = si.bottom;

			final LayoutAmountInfo amt = new LayoutAmountInfo(child.profile.height);
			switch (amt.type) {
				case LayoutAmountType.NONE:
					if (child.height != null)
						assigned += child.height;
					else
						assigned += child.outerHeight;
					break;
				case LayoutAmountType.FIXED:
					assigned += child.height = amt.value;
					break;
				case LayoutAmountType.FLEX:
					nflex += amt.value;
					flexs.add(amt.value);
					flexViews.add(child);
					break;
				case LayoutAmountType.RATIO:
					assigned += child.height = (innerHeight() * amt.value).round().toInt();
					break;
				case LayoutAmountType.CONTENT:
					final int hgh = child.measureHeight(mctx);
					if (hgh != null)
						assigned += child.height = hgh;
					else
						assigned += child.outerHeight;
					break;
			}

			final AsInt defaultWidth = () => view.innerWidth - si.left - si.right;
			layoutManager.setWidthByProfile(mctx, child, defaultWidth, defaultWidth);
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
				final int delta = (per * flexs[j]).round().toInt();
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

			final LayoutSideInfo si = childspcinfs[child];
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
