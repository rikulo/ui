//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  9:56:20 AM
// Author: tomyeh

/**
 * The free layout (default).
 */
class FreeLayout extends AbstractLayout {
  int measureWidth(MeasureContext mctx, View view) {
    int wd = mctx.getWidthSetByApp(view);
    if (wd == null) {
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
        wd += mctx.getBorderWidth(view);
    }
    return wd;
  }
  int measureHeight(MeasureContext mctx, View view) {
    int hgh = mctx.getHeightSetByApp(view);
    if (hgh == null) {
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
        hgh += mctx.getBorderHeight(view);
    }
    return hgh;
  }
  bool isProfileInherited() => false;
  void doLayout_(MeasureContext mctx, View view, List<View> children) {
    final AsInt innerWidth = () => view.innerWidth,
      innerHeight = () => view.innerHeight; //future: introduce cache
    for (final View child in children) {
      mctx.setWidthByProfile(child, innerWidth);
      mctx.setHeightByProfile(child, innerHeight);
    }
  }
}
