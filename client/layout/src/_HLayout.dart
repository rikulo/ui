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
    final LayoutSideInfo gapinf = new LayoutSideInfo(view.layout.gap);
    int width = 0, prevSpacing;
    for (final View child in view.children) {
      if (!view.shallLayout_(child) || child.profile.anchorView !== null)
        continue; //ignore anchored

      //add spacing to width
      final LayoutSideInfo si = new LayoutSideInfo(child.profile.spacing, 0, spcinf);
      width += prevSpacing === null ? si.left: //first
        gapinf.left !== null ? gapinf.left: Math.max(prevSpacing, si.left);
      if (width >= maxWd)
        return maxWd;
      prevSpacing = si.right;

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
          if ((width += amt.value) >= maxWd)
            return maxWd;
          break;
        case LayoutAmountType.CONTENT:
          final int wd = child.measureWidth_(mctx);
          if ((width += wd != null ? wd: child.outerWidth) >= maxWd)
            return maxWd;
          break;
        default:
          return maxWd; //fulfill the parent if flex or ratio is used
      }
    }

    width += new DOMQuery(view.node).borderWidth * 2
      + (prevSpacing !== null ? prevSpacing: spcinf.left + spcinf.right);
    return width >= maxWd ? maxWd: width;
  }
  int measureHeight(MeasureContext mctx, View view) {
    final LayoutAmountInfo amtDefault =
      LinearLayout.getDefaultAmountInfo(view.layout.height);
    final LayoutSideInfo spcinf = new LayoutSideInfo(view.layout.spacing, LinearLayout.DEFAULT_SPACING);
    final int borderWd = new DOMQuery(view.node).borderWidth * 2;
    int height;
    for (final View child in view.children) {
      if (!view.shallLayout_(child) || child.profile.anchorView !== null)
        continue; //ignore anchored

      //add spacing to width
      final LayoutSideInfo si = new LayoutSideInfo(child.profile.spacing, 0, spcinf);
      int hgh = si.top + si.bottom + borderWd; //spacing of border
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
          hgh += amt.value;
          break;
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
    final AsInt innerWidth = () => view.innerWidth;
    final AsString defaultProfile = () { //default profile.height
      final String s = view.layout.height;
      return s.isEmpty() ? "content": s;
    };
    final LayoutSideInfo spcinf = new LayoutSideInfo(view.layout.spacing, LinearLayout.DEFAULT_SPACING);
    final LayoutSideInfo gapinf = new LayoutSideInfo(view.layout.gap);
    final Map<View, LayoutSideInfo> childspcinfs = new Map();
    final List<View> flexViews = new List();
    final List<int> flexs = new List();
    int nflex = 0, assigned = 0, prevSpacing;
    for (final View child in children) {
      if (!view.shallLayout_(child)) {
        layoutManager.setWidthByProfile(mctx, child, () => view.innerWidth);
        layoutManager.setHeightByProfile(mctx, child, () => view.innerHeight);
        continue;
      }

      final LayoutSideInfo si = new LayoutSideInfo(child.profile.spacing, 0, spcinf);
      childspcinfs[child] = si;
      assigned += prevSpacing === null ? si.left: //first
        gapinf.left !== null ? gapinf.left: Math.max(prevSpacing, si.left);
      prevSpacing = si.right;

      final LayoutAmountInfo amt = new LayoutAmountInfo(child.profile.width);
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
          assigned += child.width = (innerWidth() * amt.value).round().toInt();
          break;
        case LayoutAmountType.NONE:
        case LayoutAmountType.CONTENT:
          if (amt.type == LayoutAmountType.NONE) {
            if (child.width != null) {
              assigned += child.width;
              break;
            }
            final int v = child.outerWidth;
            if (v != 0) {
              assigned += v;
              break;
            }
            //fall through
          }

          final int wd = child.measureWidth_(mctx);
          if (wd != null)
            assigned += child.width = wd;
          else
            assigned += child.outerWidth;
          break;
      }

      final AsInt defaultHeight = () => view.innerHeight - si.top - si.bottom; //subtract spacing from borders
      layoutManager.setHeightByProfile(mctx, child, defaultHeight, defaultHeight, defaultProfile);
    }

    //1a) size flex
    if (nflex > 0) {
      int space = innerWidth() - assigned - prevSpacing; //prevSpacing not null here
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

      final LayoutSideInfo si = childspcinfs[child];
      child.left = assigned += prevSpacing === null ? si.left: //first
        gapinf.left !== null ? gapinf.left: Math.max(prevSpacing, si.left);
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
