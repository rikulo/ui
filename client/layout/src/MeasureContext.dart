//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 26, 2012  2:47:38 PM
// Author: tomyeh

/**
 * The context to measure size.
 */
class MeasureContext {
  /** The widths of measured views. The size is stored to speed up
   * the measurement since [View.measureWidth_] might be called multiple times
   * in one layout run. If the width shall be re-measured, you can
   * remove it from this map.
   *
   * Note: null indicates the width is up to the system, i.e., no need
   * to set the width.
   */
  final Map<View, int> widths;
  /** The heights of measured views. The size is stored to speed up
   * the measurement since [View.measureHeight_] might be called multiple times
   * in one layout run. If the height shall be re-measured, you can
   * remove it from this map.
   *
   * Note: null indicates the height is up to the system, i.e., no need
   * to set the height.
   */
  final Map<View, int> heights;
  final Map<View, int> _borderWds;

  MeasureContext(): widths = new Map(), heights = new Map(),
  _borderWds = new Map() {
  }
  /** Returns the border's width.
   */
  int getBorderWidth(View view) {
    int v = _borderWds[view];
    if (v === null)
      _borderWds[view] = v = new DOMQuery(view.node).borderWidth;
    return v;
  }

  /** Returns the value of the profile with the given name.
   *
   * Notice that, depending on layout, some profile's value will be inherited
   * from its parent, so it is better to invoke this method rather than
   * accessing [View]'s profile directly.
   */
  String getProfile(View view, String name) {
    final String v = view.profile.getPropertyValue(name);
    return !v.isEmpty() || view.parent === null
    || !layoutManager.getLayoutOfView(view.parent).isProfileInherited() ?
      v: view.parent.layout.getPropertyValue(name);
  }

  /** Set the width of the given view based on its profile.
   * It is an utility for implementing a layout.
   *
   * It has no effect if view is not visible.
   */
  void setWidthByProfile(View view, AsInt width) {
    if (!view.hidden) {
      final LayoutAmountInfo amt = new LayoutAmountInfo(getProfile(view, "width"));
      switch (amt.type) {
        case LayoutAmountType.FIXED:
          view.width = amt.value;
          break;
        case LayoutAmountType.FLEX:
          view.width = width();
          break;
        case LayoutAmountType.RATIO:
          view.width = (width() * amt.value).round().toInt();
          break;
        case LayoutAmountType.NONE:
        case LayoutAmountType.CONTENT:
          //Note: if NONE and app doesn't set width, it means content
          if (amt.type == LayoutAmountType.NONE && getWidthSetByApp(view) !== null)
            break;
          final int wd = view.measureWidth_(this);
          if (wd != null)
            view.width = wd;
          break;
      }
    }
  }
  /** Set the height of the given view based on its profile.
   * It is an utility for implementing a layout.
   *
   * It has no effect if view is not visible.
   */
  void setHeightByProfile(View view, AsInt height) {
    if (!view.hidden) {
      final LayoutAmountInfo amt = new LayoutAmountInfo(getProfile(view, "height"));
      switch (amt.type) {
        case LayoutAmountType.FIXED:
          view.height = amt.value;
          break;
        case LayoutAmountType.FLEX:
          view.height = height();
          break;
        case LayoutAmountType.RATIO:
          view.height = (height() * amt.value).round().toInt();
          break;
        case LayoutAmountType.NONE:
        case LayoutAmountType.CONTENT:
          //Note: if NONE and app doesn't set height, it means content
          if (amt.type == LayoutAmountType.NONE && getHeightSetByApp(view) !== null)
            break;
          final int hgh = view.measureHeight_(this);
          if (hgh != null)
            view.height = hgh;
          break;
      }
    }
  }

  /** Measure the width of the given view.
   */
  int measureWidth(View view)
  => view.hidden ? 0: layoutManager.getLayoutOfView(view).measureWidth(this, view);
  /** Measure the height of the given view.
   */
  int measureHeight(View view)
  => view.hidden ? 0: layoutManager.getLayoutOfView(view).measureHeight(this, view);

  /** Measures the width based on the view's content.
   * It is an utility for implementing a view's [View.measureWidth_].
   * This method assumes the browser will resize the view automatically,
   * so it is applied only to a leaf view with some content, such as [TextView]
   * and [Button].
   *
   * + [autowidth] specifies whether to adjust the width automatically.
   */
  int measureWidthByContent(View view, bool autowidth) {
    final int wd = widths[view];
    return wd !== null || widths.containsKey(view) ?
      wd: _measureByContent(view, autowidth).width;
  }
  /** Measures the height based on the view's content.
   * It is an utility for implementing a view's [View.measureHeight_].
   * This method assumes the browser will resize the view automatically,
   * so it is applied only to a leaf view with some content, such as [TextView]
   * and [Button].
   *
   * + [autowidth] specifies whether to adjust the width automatically.
   */
  int measureHeightByContent(View view, bool autowidth) {
    final int hgh = heights[view];
    return hgh !== null || heights.containsKey(view) ?
      hgh: _measureByContent(view, autowidth).height;
  }
  Size _measureByContent(View view, bool autowidth) {
    if (view.hidden)
      return new Size(widths[view] = 0, heights[view] = 0);

    CSSStyleDeclaration nodestyle;
    String orgspace, orgwd, orghgh;
    if (autowidth) {
      nodestyle = view.node.style;
      final String pos = nodestyle.position;
      if (pos != "fixed" && pos != "static") {
        orgspace = nodestyle.whiteSpace;
        if (orgspace === null) orgspace = ""; //TODO: no need if Dart handles it
        nodestyle.whiteSpace = "nowrap";
        //Node: an absolute DIV's width will be limited by its parent's width
        //so we have to unlimit it (by either nowrap or fixed/staic position)
      }

      //we have to reset width since it could be set by layout before and the content is changed
      orgwd = nodestyle.width;
      orghgh = nodestyle.height;
      nodestyle.width = "";
      nodestyle.height = "";
    }

    final DOMQuery qview = new DOMQuery(view);
    final Size size = new Size(qview.outerWidth, qview.outerHeight);

    if (orgspace !== null)
      nodestyle.whiteSpace = orgspace; //restore
    if (orgwd !== null && !orgwd.isEmpty())
      nodestyle.width = orgwd;
    if (orghgh !== null && !orghgh.isEmpty())
      nodestyle.height = orghgh;

    final AsInt parentInnerWidth =
      () => view.parent !== null ? view.parent.innerWidth: browser.size.width;
    final AsInt parentInnerHeight =
      () => view.parent !== null ? view.parent.innerHeight: browser.size.height;

    int limit = _amountOf(view.profile.maxWidth, parentInnerWidth);
    if ((autowidth && size.width > browser.size.width)
    || (limit !== null && size.width > limit)) {
      nodestyle.width = CSS.px(limit != null ? limit: browser.size.width);

      size.width = qview.outerWidth;
      size.height = qview.outerHeight;
      //Note: we don't restore the width such that browser will really limit the width
    }

    if ((limit = _amountOf(view.profile.maxHeight, parentInnerHeight)) !== null
    && size.height > limit) {
      size.height = limit;
    }
    if ((limit = _amountOf(view.profile.minWidth, parentInnerWidth)) !== null
    && size.width < limit) {
      size.width = limit;
    }
    if ((limit = _amountOf(view.profile.minHeight, parentInnerHeight)) !== null
    && size.height < limit) {
      size.height = limit;
    }

    widths[view] = size.width;
    heights[view] = size.height;
    return size;
  }
  static int _amountOf(String profile, AsInt parentInner) {
    final LayoutAmountInfo ai = new LayoutAmountInfo(profile);
    switch (ai.type) {
      case LayoutAmountType.FIXED:
        return ai.value;
      case LayoutAmountType.FLEX:
        return parentInner();
      case LayoutAmountType.RATIO:
        return (parentInner() * ai.value).round().toInt();
    }
    return null;
  }

  /** Returns the width set by the applicaiton, or null if it is not set yet or set
   * by a layout.
   */
  int getWidthSetByApp(View view) {
    final LayoutAmountInfo amtInf = new LayoutAmountInfo(getProfile(view, "width"));
    switch (amtInf.type) {
      case LayoutAmountType.FIXED:
        return amtInf.value;
      case LayoutAmountType.NONE:
        return _getSetByApp(view, view.width, 'rk.layout.w'); //see also LayoutManager.sizeUpdated
    }
  }
  /** Returns the height set by the applicaiton, or null if it is not set yet or set
   * by a layout.
   */
  int getHeightSetByApp(View view) {
    final LayoutAmountInfo amtInf = new LayoutAmountInfo(getProfile(view, "height"));
    switch (amtInf.type) {
      case LayoutAmountType.FIXED:
        return amtInf.value;
      case LayoutAmountType.NONE:
        return _getSetByApp(view, view.height, 'rk.layout.h'); //see also LayoutManager.sizeUpdated
    }
  }
  static int _getSetByApp(View view, int val, String nm)
  => val !== null && val != view.dataAttributes[nm] ? val: null;
}
