//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 26, 2012  2:47:38 PM
// Author: tomyeh
part of rikulo_layout;

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
  final Map<View, int> _borderWds, _borderHghs;
  Map<String, dynamic> _dataAttrs;

  MeasureContext(): widths = new Map(), heights = new Map(),
  _borderWds = new Map(), _borderHghs = new Map() {
  }
  /** Returns the border's width (left border plus right border).
   */
  int getBorderWidth(View view) {
    final v = _borderWds[view];
    if (v == null) {
      final qs = new DomAgent(view.node).computedStyle;
      return _borderWds[view] = Css.intOf(qs.borderLeftWidth) + Css.intOf(qs.borderRightWidth);
      //Note: qs.borderWidth is supported only by Chrome
    }
    return v;
  }
  /** Returns the border's height (top border plus bottom border).
   */
  int getBorderHeight(View view) {
    final v = _borderHghs[view];
    if (v == null) {
      final qs = new DomAgent(view.node).computedStyle;
      return _borderHghs[view] = Css.intOf(qs.borderTopWidth) + Css.intOf(qs.borderBottomWidth);
    }
    return v;
  }

  /** Returns the value of the profile with the given name.
   *
   * Notice that, depending on layout, some profile's value will be inherited
   * from its parent, so it is better to invoke this method rather than
   * accessing [View]'s profile directly.
   */
  String getProfile(View view, String name) {
    String v = view.profile.getPropertyValue(name);
    if (v.isEmpty) {
      if (view.parent != null
      && view.parent.layout.handler.isProfileInherited)
        v = view.parent.layout.getPropertyValue(name);
      if (v.isEmpty && view.layout.handler.isFlex)
        v = "flex";
    }
    return v;
  }

  /** Set the width of the given view based on its profile.
   * It is an utility for implementing a layout.
   *
   * It has no effect if view is not visible.
   */
  void setWidthByProfile(View view, AsInt width) {
    if (view.visible) {
      final AmountInfo amt = new AmountInfo(getProfile(view, "width"));
      switch (amt.type) {
        case AmountType.FIXED:
          view.width = amt.value; //fixed has higher priority than min/max
          break;
        case AmountType.FLEX:
          _flexWd(view, width());
          break;
        case AmountType.RATIO:
          view.width = _minMaxWd(view, (width() * amt.value).round().toInt());
          break;
        case AmountType.CONTENT:
          _contentWd(view);
          break;
        case AmountType.NONE:
        //Note: if NONE and app doesn't set width, it means content
          if (getWidthByApp(view) == null) {
            //if view is root and a view group, we use flex
            int wd;
            if (view.parent == null && !view.shallMeasureContent
            && (wd = width()) > 0)
              _flexWd(view, wd); //FLEX
            else
              _contentWd(view); //CONTENT
          }
          break;
        case AmountType.IGNORE:
          ViewImpl.clearWidthByLayout(view);
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
    if (view.visible) {
      final AmountInfo amt = new AmountInfo(getProfile(view, "height"));
      switch (amt.type) {
        case AmountType.FIXED:
          view.height = amt.value; //fixed has higher priority than min/max
          break;
        case AmountType.FLEX:
          _flexHgh(view, height());
          break;
        case AmountType.RATIO:
          view.height = _minMaxHgh(view, (height() * amt.value).round().toInt());
          break;
        case AmountType.CONTENT:
          _contentHgh(view);
          break;
        case AmountType.NONE:
        //Note: if NONE and app doesn't set height, it means content
          if (getHeightByApp(view) == null) {
            //if view is root and a view group, we use flex
            int hgh;
            if (view.parent == null && !view.shallMeasureContent
            && (hgh = height()) > 0)
              _flexHgh(view, hgh); //FLEX
            else
              _contentHgh(view); //CONTENT
          }
          break;
        case AmountType.IGNORE:
          ViewImpl.clearHeightByLayout(view);
          break;
      }
    }
  }
  void _flexWd(View view, int width) {
    view.width = _minMaxWd(view, width);
  }
  void _flexHgh(View view, int height) {
    view.height = _minMaxHgh(view, height);
  }
  void _contentWd(View view) {
    //note: we always set width/height; otherwise it might wrap because of position
    //example: if we changed the width to 95% (rather than 70%), TextView will wrap
    final wd = view.measureWidth_(this);
    if (wd != null)
      view.width = wd; //no need to min/max since measureXxx shall handle it
  }
  void _contentHgh(View view) {
    final hgh = view.measureHeight_(this);
    if (hgh != null)
      view.height = hgh; //no need to min/max since measureXxx shall handle it
  }
  int _minMaxWd(View view, int wd)
  => _minMax(wd, getProfile(view, "min-width"), getProfile(view, "max-width"));
  int _minMaxHgh(View view, int hgh)
  => _minMax(hgh, getProfile(view, "min-height"), getProfile(view, "max-height"));

  /** Measure the width of the given view.
   */
  int measureWidth(View view) {
    if (view.visible) {
      int wd = widths[view];
      if (wd != null || widths.containsKey(view))
        return wd;

      wd = view.layout.handler.measureWidth(this, view);

      final AsInt parentInnerWidth =
        () => view.parent != null ? view.parent.innerWidth: browser.size.width;
      int limit;
      if ((limit = _amountOf(view.profile.maxWidth, parentInnerWidth)) != null
      && (wd == null || wd > limit))
        wd = limit;
      if ((limit = _amountOf(view.profile.minWidth, parentInnerWidth)) != null
      && (wd == null || wd < limit))
        wd = limit;
      return widths[view] = wd;
    }
    return 0;
  }
  /** Measure the height of the given view.
   */
  int measureHeight(View view) {
    if (view.visible) {
      int hgh = heights[view];
      if (hgh != null || heights.containsKey(view))
        return hgh;

      hgh = view.layout.handler.measureHeight(this, view);
      final AsInt parentInnerHeight =
        () => view.parent != null ? view.parent.innerHeight: browser.size.height;
      int limit;
      if ((limit = _amountOf(view.profile.maxHeight, parentInnerHeight)) != null
      && (hgh == null || hgh > limit))
        hgh = limit;
      if ((limit = _amountOf(view.profile.minHeight, parentInnerHeight)) != null
      && (hgh == null || hgh < limit))
        hgh = limit;
      return heights[view] = hgh;
    }
    return 0;
  }

  /** Measures the width based on the view's content shown on the document.
   * It is an utility for implementing a view's [View.measureWidth_].
   * This method assumes the browser will resize the view automatically,
   * so it is applied to a leaf view with some content, such as [TextView]
   * and [Button].
   *
   * + [autowidth] specifies whether to adjust the width automatically.
   */
  int measureContentWidth(View view, bool autowidth) {
    final int wd = widths[view];
    return wd != null || widths.containsKey(view) ?
      wd: _measureContent(view, autowidth).width;
  }
  /** Measures the height based on the view's content shown on the document.
   * It is an utility for implementing a view's [View.measureHeight_].
   * This method assumes the browser will resize the view automatically,
   * so it is applied to a leaf view with some content, such as [TextView]
   * and [Button].
   *
   * + [autowidth] specifies whether to adjust the width automatically.
   */
  int measureContentHeight(View view, bool autowidth) {
    final int hgh = heights[view];
    return hgh != null || heights.containsKey(view) ?
      hgh: _measureContent(view, autowidth).height;
  }
  Size _measureContent(View view, bool autowidth) {
    if (!view.visible)
      return new Size(widths[view] = 0, heights[view] = 0);

    CssStyleDeclaration nodestyle;
    String orgspace, orgwd, orghgh;
    if (autowidth) {
      nodestyle = view.node.style;
      final String pos = nodestyle.position;
      if (pos != "fixed" && pos != "static") {
        orgspace = nodestyle.whiteSpace;
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

    final qview = new DomAgent(view.node);
    num width = qview.width, height = qview.height;

    if (orgspace != null)
      nodestyle.whiteSpace = orgspace; //restore
    if (orgwd != null && !orgwd.isEmpty)
      nodestyle.width = orgwd;
    if (orghgh != null && !orghgh.isEmpty)
      nodestyle.height = orghgh;

    final AsInt parentInnerWidth =
      () => view.parent != null ? view.parent.innerWidth: browser.size.width;
    final AsInt parentInnerHeight =
      () => view.parent != null ? view.parent.innerHeight: browser.size.height;

    int limit = _amountOf(view.profile.maxWidth, parentInnerWidth);
    if ((autowidth && width > browser.size.width)
    || (limit != null && width > limit)) {
      nodestyle.width = Css.px(limit != null ? limit: browser.size.width);

      width = qview.width;
      height = qview.height;
      //Note: we don't restore the width such that browser will really limit the width
    }

    if ((limit = _amountOf(view.profile.maxHeight, parentInnerHeight)) != null
    && height > limit)
      height = limit;
    if ((limit = _amountOf(view.profile.minWidth, parentInnerWidth)) != null
    && width < limit)
      width = limit;
    if ((limit = _amountOf(view.profile.minHeight, parentInnerHeight)) != null
    && height < limit)
      height = limit;

    widths[view] = width;
    heights[view] = height;
    return new Size(width, height);
  }

  /** Returns the left set by the applicaiton, or null if it is not set yet or set
   * by a layout.
   */
  int getLeftByApp(View view)
  => view.profile.anchorView == null && ViewImpl.isLeftByApp(view) ? view.left: null;
  /** Returns the top set by the applicaiton, or null if it is not set yet or set
   * by a layout.
   */
  int getTopByApp(View view)
  => view.profile.anchorView == null && ViewImpl.isTopByApp(view) ? view.top: null;

  /** Returns the width set by the applicaiton, or null if it is not set yet or set
   * by a layout.
   */
  int getWidthByApp(View view) {
    final AmountInfo amtInf = new AmountInfo(getProfile(view, "width"));
    switch (amtInf.type) {
      case AmountType.FIXED:
        return amtInf.value;
      case AmountType.NONE:
      case AmountType.IGNORE:
        return ViewImpl.isWidthByApp(view) ? view.width: null;
    }
  }
  /** Returns the height set by the applicaiton, or null if it is not set yet or set
   * by a layout.
   */
  int getHeightByApp(View view) {
    final AmountInfo amtInf = new AmountInfo(getProfile(view, "height"));
    switch (amtInf.type) {
      case AmountType.FIXED:
        return amtInf.value;
      case AmountType.NONE:
      case AmountType.IGNORE:
        return ViewImpl.isHeightByApp(view) ? view.height: null;
    }
  }

  /** Calls back [View.onPreLayout_].
   * The implementation of [Layout] shall invoke this method rather than 
   * [View.onPreLayout_].
   */
  void preLayout(View view) {
    ++layoutManager._inCallback;
    try {
      view.onPreLayout_(this);
    } finally {
      --layoutManager._inCallback;
    }
  }

  /**
   * A map of application-specific data. It is useful if you'd like to
   * store something that will be cleaned up automatically when the layout is done.
   *
   * Note: the name of the attribute can't start with "rk.", which is reserved
   * for internal use.
   */
  Map<String, dynamic> get dataAttributes
  => _dataAttrs != null ? _dataAttrs: MapUtil.onDemand(() => _dataAttrs = new Map());
}

int _minMax(int v, String vmin, String vmax) {
  if (!vmin.isEmpty) {
    final int w = Css.intOf(vmin);
    if (v < w) v = w;
  }
  if (!vmax.isEmpty) {
    final int w = Css.intOf(vmax);
    if (w > 0 && v > w) v = w;
  }
  return v;
}
int _amountOf(String profile, AsInt parentInner) {
  final AmountInfo ai = new AmountInfo(profile);
  switch (ai.type) {
    case AmountType.FIXED:
      return ai.value;
    case AmountType.FLEX:
      return parentInner();
    case AmountType.RATIO:
      return (parentInner() * ai.value).round().toInt();
  }
}
