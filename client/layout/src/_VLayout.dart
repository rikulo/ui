//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Apr 12, 2012  4:49:52 PM
// Author: tomyeh

/**
 * Vertical linear layout.
 */
class _VLayout implements _RealLinearLayout {
  int measureHeight(MeasureContext mctx, View view) {
    final int va = mctx.getHeightSetByApp(view);
    if (va != null)
      return va;

    final LayoutSideInfo spcinf = new LayoutSideInfo(view.layout.spacing, LinearLayout.DEFAULT_SPACING);
    final LayoutSideInfo gapinf = new LayoutSideInfo(view.layout.gap);
    final String defphgh = view.layout.height;
    int height = 0, prevSpacing;
    for (final View child in view.children) {
      if (!view.shallLayout_(child) || child.profile.anchorView != null)
        continue; //ignore anchored

      //add spacing to height
      final LayoutSideInfo si = new LayoutSideInfo(child.profile.spacing, 0, spcinf);
      height += prevSpacing == null ? si.top: //first
        gapinf.top != null ? gapinf.top: max(prevSpacing, si.top);
      prevSpacing = si.bottom;

      final String phgh = child.profile.height;
      final LayoutAmountInfo amt = new LayoutAmountInfo(phgh.isEmpty() ? defphgh: phgh);
      switch (amt.type) {
        case LayoutAmountType.FIXED:
          height += amt.value;
          break;
        case LayoutAmountType.NONE:
        case LayoutAmountType.CONTENT:
          final int hgh = child.measureHeight_(mctx);
          height += hgh != null ? hgh: child.outerHeight;
          break;
        //default: if flex/%, don't count
      }
    }

    height += mctx.getBorderWidth(view) * 2
      + (prevSpacing != null ? prevSpacing: spcinf.top + spcinf.bottom);
    return height;
  }
  int measureWidth(MeasureContext mctx, View view) {
    final int va = mctx.getWidthSetByApp(view);
    if (va != null)
      return va;

    final LayoutSideInfo spcinf = new LayoutSideInfo(view.layout.spacing, LinearLayout.DEFAULT_SPACING);
    final String defpwd = view.layout.width;
    final int borderWd = mctx.getBorderWidth(view) << 1;
    int width;
    for (final View child in view.children) {
      if (!view.shallLayout_(child) || child.profile.anchorView != null)
        continue; //ignore anchored

      //add spacing to height
      final LayoutSideInfo si = new LayoutSideInfo(child.profile.spacing, 0, spcinf);
      int wd = si.left + si.right + borderWd; //spacing of border
      final String pwd = child.profile.width;
      final LayoutAmountInfo amt = new LayoutAmountInfo(pwd.isEmpty() ? defpwd: pwd);
      switch (amt.type) {
        case LayoutAmountType.FIXED:
          wd += amt.value;
          break;
        case LayoutAmountType.NONE:
        case LayoutAmountType.CONTENT:
          final int w = child.measureWidth_(mctx);
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
  void doLayout(MeasureContext mctx, View view, List<View> children) {
    //1) size
    final AsInt innerHeight = () => view.innerHeight;
    final LayoutSideInfo spcinf = new LayoutSideInfo(view.layout.spacing, LinearLayout.DEFAULT_SPACING);
    final LayoutSideInfo gapinf = new LayoutSideInfo(view.layout.gap);
    final String defphgh = view.layout.height;
    final Map<View, LayoutSideInfo> childspcinfs = new Map();
    final List<View> flexViews = new List();
    final List<int> flexs = new List();
    int nflex = 0, assigned = 0, prevSpacing;
    for (final View child in children) {
      if (!view.shallLayout_(child)) {
        mctx.setWidthByProfile(child, () => view.innerWidth);
        mctx.setHeightByProfile(child, () => view.innerHeight);
        continue;
      }

      final LayoutSideInfo si = new LayoutSideInfo(child.profile.spacing, 0, spcinf);
      childspcinfs[child] = si;
      assigned += prevSpacing == null ? si.top: //first
        gapinf.top != null ? gapinf.top: max(prevSpacing, si.top);
      prevSpacing = si.bottom;

      final String phgh = child.profile.height;
      final LayoutAmountInfo amt = new LayoutAmountInfo(phgh.isEmpty() ? defphgh: phgh);
      switch (amt.type) {
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
        default:
          final int hgh = child.measureHeight_(mctx);
          if (hgh != null)
            assigned += child.height = hgh;
          else
            assigned += child.outerHeight;
          break;
      }

      mctx.setWidthByProfile(child,
        () => view.innerWidth - si.left - si.right); //subtract spacing from border
    }

    //1a) size flex
    if (nflex > 0) {
      int space = innerHeight() - assigned - prevSpacing; //prevSpacing must not null
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
    prevSpacing = null;
    assigned = 0;
    for (final View child in children) {
      if (!view.shallLayout_(child))
        continue;

      final LayoutSideInfo si = childspcinfs[child];
      child.top = assigned += prevSpacing == null ? si.top: //first
        gapinf.top != null ? gapinf.top: max(prevSpacing, si.top);
      assigned += child.outerHeight;
      prevSpacing = si.bottom;

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
