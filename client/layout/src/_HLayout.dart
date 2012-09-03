//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Apr 12, 2012  4:47:32 PM
// Author: tomyeh

/**
 * Horizontal linear layout.
 */
class _HLayout implements _RealLinearLayout {
  int measureWidth(MeasureContext mctx, View view) {
    final int va = mctx.getWidthSetByApp(view);
    if (va != null)
      return va;

    final spcinf = new LayoutSideInfo(view.layout.spacing, _DEFAULT_SPACING);
    final gapinf = new LayoutSideInfo(view.layout.gap);
    final defpwd = view.layout.width;
    int width = 0, prevSpacing;
    for (final View child in view.children) {
      if (!view.shallLayout_(child) || child.profile.anchorView != null)
        continue; //ignore anchored

      //add spacing to width
      final si = new LayoutSideInfo(child.profile.spacing, 0, spcinf);
      width += prevSpacing == null ? si.left: //first
        gapinf.left != null ? gapinf.left: max(prevSpacing, si.left);
      prevSpacing = si.right;

      final pwd = child.profile.width;
      final amt = _getLayoutAmountInfo(child, pwd.isEmpty() ? defpwd: pwd);
      switch (amt.type) {
        case LayoutAmountType.FIXED:
          width += amt.value;
          break;
        case LayoutAmountType.NONE:
        case LayoutAmountType.CONTENT:
          final int wd = child.measureWidth_(mctx);
          width += wd != null ? wd: child.outerWidth;
          break;
        //default: if flex/%, don't count
      }
    }

    width += mctx.getBorderWidth(view)
      + (prevSpacing != null ? prevSpacing: spcinf.left + spcinf.right);
    return width;
  }
  int measureHeight(MeasureContext mctx, View view) {
    final int va = mctx.getHeightSetByApp(view);
    if (va != null)
      return va;

    final spcinf = new LayoutSideInfo(view.layout.spacing, _DEFAULT_SPACING);
    final String defphgh = view.layout.height;
    final int borderHgh = mctx.getBorderHeight(view);
    int height;
    for (final View child in view.children) {
      if (!view.shallLayout_(child) || child.profile.anchorView != null)
        continue; //ignore anchored

      //add spacing to width
      final si = new LayoutSideInfo(child.profile.spacing, 0, spcinf);
      int hgh = si.top + si.bottom + borderHgh; //spacing of border
      final phgh = child.profile.height;
      final amt = _getLayoutAmountInfo(child, phgh.isEmpty() ? defphgh: phgh);
      switch (amt.type) {
        case LayoutAmountType.FIXED:
          hgh += amt.value;
          break;
        case LayoutAmountType.NONE:
        case LayoutAmountType.CONTENT:
          final int h = child.measureHeight_(mctx);
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
  void doLayout(MeasureContext mctx, View view, List<View> children) {
    //1) size
    final spcinf = new LayoutSideInfo(view.layout.spacing, _DEFAULT_SPACING);
    final gapinf = new LayoutSideInfo(view.layout.gap);
    final String defpwd = view.layout.width;
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

      final si = new LayoutSideInfo(child.profile.spacing, 0, spcinf);
      childspcinfs[child] = si;
      assigned += prevSpacing == null ? si.left: //first
        gapinf.left != null ? gapinf.left: max(prevSpacing, si.left);
      prevSpacing = si.right;

      final pwd = child.profile.width;
      final amt = _getLayoutAmountInfo(child, pwd.isEmpty() ? defpwd: pwd);
      switch (amt.type) {
        case LayoutAmountType.FIXED:
          assigned += child.width = amt.value;
          break;
        case LayoutAmountType.FLEX:
          nflex += amt.value;
          flexs.add(amt.value);
          flexViews.add(child);
          break;
        case LayoutAmountType.RATIO:
          assigned += child.width = (view.innerWidth * amt.value).round().toInt();
          break;
        default:
          final int wd = child.measureWidth_(mctx);
          if (wd != null)
            assigned += child.width = wd;
          else
            assigned += child.outerWidth;
          break;
      }

      mctx.setHeightByProfile(child,
        () => view.innerHeight - si.top - si.bottom); //subtract spacing from borders
    }

    //1a) size flex
    if (nflex > 0) {
      int space = view.innerWidth - assigned - prevSpacing; //prevSpacing not null here
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
    prevSpacing = null;
    assigned = 0;
    for (final View child in children) {
      if (!view.shallLayout_(child))
        continue;

      final si = childspcinfs[child];
      child.left = assigned += prevSpacing == null ? si.left: //first
        gapinf.left != null ? gapinf.left: max(prevSpacing, si.left);
      assigned += child.outerWidth;
      prevSpacing = si.right;

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
