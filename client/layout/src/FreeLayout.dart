//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  9:56:20 AM
// Author: tomyeh

/**
 * The free layout (default).
 */
class FreeLayout implements Layout {
  int measureWidth(MeasureContext mctx, View view) {
    int wd = mctx.widths[view];
    if (wd != null || mctx.widths.containsKey(view))
      return wd;

    if ((wd = mctx.getWidthSetByApp(view)) == null) {
      wd = view.innerWidth;
      for (final View child in view.children) {
        if (view.shallLayout_(child) && child.profile.anchorView == null) {
          int subsz = child.measureWidth_(mctx);
          subsz = child.left + (subsz != null ? subsz: 0);
          if (wd == null || subsz > wd)
            wd = subsz;
        }
      }

      if (wd != null)
        wd += mctx.getBorderWidth(view) << 1;
    }
    mctx.widths[view] = wd;
    return wd;
  }
  int measureHeight(MeasureContext mctx, View view) {
    int hgh = mctx.heights[view];
    if (hgh != null || mctx.heights.containsKey(view))
      return hgh;

    if ((hgh = mctx.getHeightSetByApp(view)) == null) {
      hgh = view.innerHeight;
      for (final View child in view.children) {
        if (view.shallLayout_(child) && child.profile.anchorView == null) {
          int subsz = child.measureHeight_(mctx);
          subsz = child.top + (subsz != null ? subsz: 0);
          if (hgh == null || subsz > hgh)
            hgh = subsz;
        }
      }

      if (hgh != null)
        hgh += mctx.getBorderWidth(view) << 1;
    }
    mctx.heights[view] = hgh;
    return hgh;
  }
  bool isProfileInherited() => false;
  void doLayout(MeasureContext mctx, View view) {
    if (view.firstChild != null) {
      final AnchorRelation ar = new AnchorRelation(view);
      final AsInt innerWidth = () => view.innerWidth,
        innerHeight = () => view.innerHeight; //future: introduce cache
      for (final View child in ar.indeps) {
        mctx.preLayout(child); //unlike onLayout_, the layout shall invoke mctx.preLayout
        mctx.setWidthByProfile(child, innerWidth);
        mctx.setHeightByProfile(child, innerHeight);
      }

      ar.layoutAnchored(mctx);

      for (final View child in view.children) {
        if (!child.hidden)
          child.doLayout_(mctx); //no matter shallLayout_
      }
    }
  }
}
