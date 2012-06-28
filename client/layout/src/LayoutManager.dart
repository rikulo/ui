//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  9:56:30 AM
// Author: tomyeh

/**
 * The layout mananger that manages the layout controllers ([Layout]).
 * There is exactly one layout manager per application.
 */
class LayoutManager extends RunOnceViewManager implements Layout {
  final Map<String, Layout> _layouts;
  final Set<String> _imgWaits;

  LayoutManager(): super(null), _layouts = {}, _imgWaits = new Set() {
    addLayout("linear", new LinearLayout());
    FreeLayout freeLayout = new FreeLayout();
    addLayout("none", freeLayout);
    addLayout("", freeLayout);
  }

  /** Adds the layout for the given name.
   */
  Layout addLayout(String name, Layout clayout) {
    final Layout old = _layouts[name];
    _layouts[name] = clayout;
    return old;
  }
  /** Removes the layout of the given name if any.
   */
  Layout removeLayout(String name) {
    return _layouts.remove(name);
  }
  /** Returns the layout of the given name, or null if not found.
   */
  Layout getLayout(String name) {
    return _layouts[name];
  }

  //@Override Layout
  int measureWidth(MeasureContext mctx, View view)
  => _layoutOfView(view).measureWidth(mctx, view);
  //@Override Layout
  int measureHeight(MeasureContext mctx, View view)
  => _layoutOfView(view).measureHeight(mctx, view);

  //@Override
  void flush([View view]) {
    //ignore flush if not empty (_onImageLoaded will invoke it later)
    if (_imgWaits.isEmpty())
      super.flush(view);
    else if (view !== null)
      queue(view); //do it later
  }

  Layout _layoutOfView(View view) {
    final String name = view.layout.type;
    final Layout clayout = getLayout(name);
    if (clayout == null)
      throw new UIException("Unknown layout, ${name}");
    return clayout;
  }

  //@Override RunOnceViewManager
  void handle_(View view) {
    doLayout(new MeasureContext(), view);
  }
  //@Override doLayout
  void doLayout(MeasureContext mctx, View view) {
    if (view.parent === null && view.profile.anchorView === null) { //root without anchor
      //handle profile since it has no parent to handel for it
      setWidthByProfile(mctx, view, () => browser.size.width);
      setHeightByProfile(mctx, view, () => browser.size.height);
      AnchorRelation._positionRoot(view);
    }
    _layoutOfView(view).doLayout(mctx, view);
    view.onLayout();
  }

  /** Set the width of the given view based on its profile.
   * It is an utility for implementing a layout.
   */
  void setWidthByProfile(MeasureContext mctx, View view, AsInt width) {
    final LayoutAmountInfo amt = new LayoutAmountInfo(view.profile.width);
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
        final bool bNONE = amt.type == LayoutAmountType.NONE;
        if (bNONE && _isWidthSet(view))
          break;
        final int wd = view.measureWidth_(mctx);
        if (wd != null) {
          view.width = wd;
          if (bNONE)
            _updWidthSet(view, wd);
        }
        break;
    }
  }
  /** Set the height of the given view based on its profile.
   * It is an utility for implementing a layout.
   */
  void setHeightByProfile(MeasureContext mctx, View view, AsInt height) {
    final LayoutAmountInfo amt = new LayoutAmountInfo(view.profile.height);
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
        final bool bNONE = amt.type == LayoutAmountType.NONE;
        if (bNONE && _isHeightSet(view))
          break;
        final int hgh = view.measureHeight_(mctx);
        if (hgh != null) {
          view.height = hgh;
          if (bNONE)
            _updHeightSet(view, hgh);
        }
        break;
    }
  }
  /** Returns whether width has been set by the applicaiton. */
  bool _isWidthSet(View view) => _isWHSet(view, view.width, 'rk.width');
  /** Returns whether height has been set by the applicaiton. */
  bool _isHeightSet(View view) => _isWHSet(view, view.height, 'rk.height');
  bool _isWHSet(View view, int v1, String nm) {
    int v2;
    if (v1 === null || v1 == (v2 = view.dataAttributes[nm]))
      return false;
    if (v2 !== null)
      view.dataAttributes.remove(nm);
    return true;
  }
  void _updWidthSet(View view, int width) {
    view.dataAttributes['rk.width'] = width;
  }
  void _updHeightSet(View view, int height) {
    view.dataAttributes['rk.height'] = height;
  }

  /** Measures the width based on the view's content.
   * It is an utility for implementing a view's [View.measureWidth_].
   * This method assumes the browser will resize the view automatically,
   * so it is applied only to a leaf view with some content, such as [TextView]
   * and [Button].
   *
   * + [autowidth] specifies whether to adjust the width automatically.
   */
  int measureWidthByContent(MeasureContext mctx, View view, bool autowidth) {
    int wd = mctx.widths[view];
    return wd !== null || mctx.widths.containsKey(view) ? wd:
      _measureByContent(mctx, view, autowidth).width;
  }
  /** Measures the height based on the view's content.
   * It is an utility for implementing a view's [View.measureHeight_].
   * This method assumes the browser will resize the view automatically,
   * so it is applied only to a leaf view with some content, such as [TextView]
   * and [Button].
   *
   * + [autowidth] specifies whether to adjust the width automatically.
   */
  int measureHeightByContent(MeasureContext mctx, View view, bool autowidth) {
    int hgh = mctx.heights[view];
    return hgh !== null || mctx.heights.containsKey(view) ? hgh:
      _measureByContent(mctx, view, autowidth).height;
  }
  Size _measureByContent(MeasureContext mctx, View view, bool autowidth) {
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

    mctx.widths[view] = size.width;
    mctx.heights[view] = size.height;
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

  /** Wait until the given image is loaded.
   * If the width and height of the image is not known in advance, this method
   * shall be called to make the layout manager wait until the image is loaded.
   *
   * Currently, [Image] will invoke this method automatically
   * if the width or height of the image is not specified.
   */
  void waitImageLoaded(String imgURI) {
    if (!_imgWaits.contains(imgURI)) {
      _imgWaits.add(imgURI);
      final ImageElement img = new Element.tag("img");
      var func = (event) { //DOM event
        _onImageLoaded(imgURI);
      };
      img.on.load.add(func);
      img.on.error.add(func);
      img.src = imgURI;
    }
  }
  void _onImageLoaded(String imgURI) {
    _imgWaits.remove(imgURI);
    if (_imgWaits.isEmpty())
      flush(); //flush all
  }
}

/** The layout manager.
 */
LayoutManager layoutManager;
