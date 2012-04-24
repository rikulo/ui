//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  9:56:30 AM
// Author: tomyeh

/**
 * The layout mananger that manages the layout controllers ([Layout]).
 * There is exactly one layout manager per application.
 */
interface LayoutManager extends Layout default _LayoutManager {
	LayoutManager();

	/** Adds the layout for the given name.
	 */
	Layout addLayout(String name, Layout layout);
	/** Removes the layout of the given name if any.
	 */
	Layout removeLayout(String name);
	/** Returns the layout of the given name, or null if not found.
	 */
	Layout getLayout(String name);

	/** Adds the given view to the invalidated queue.
	 */
	void queue(View view);
	/** Redo the layout of the given view, if not null, or
	 * all queued views, if the give view is null.
	 */
	void flush([View view]);

	/** Set the width of the given view based on its profile.
	 * It is an utility for implementing a layout.
	 * <p>[defaultWidth] is used if the profile's width is not specified. Ignored if null.
	 */
	void setWidthByProfile(MeasureContext mctx, View view, AsInt width, [AsInt defaultWidth]);
	/** Set the height of the given view based on its profile.
	 * It is an utility for implementing a layout.
	 * <p>[defaultHeight] is used if the profile's height is not specified. Ignored if null.
	 */
	void setHeightByProfile(MeasureContext mctx, View view, AsInt height, [AsInt defaultHeight]);
	/** Measures the width based on the view's content.
	 * It is an utility for implementing a view's [View.measureWidth].
	 * This method assumes the browser will resize the view automatically,
	 * so it is applied only to a leaf view with some content, such as [TextView]
	 * and [Button].
	 */
	int measureWidthByContent(MeasureContext mctx, View view);
	/** Measures the height based on the view's content.
	 * It is an utility for implementing a view's [View.measureHeight].
	 * This method assumes the browser will resize the view automatically,
	 * so it is applied only to a leaf view with some content, such as [TextView]
	 * and [Button].
	 */
	int measureHeightByContent(MeasureContext mctx, View view);

	/** Wait until the given image is loaded.
	 * If the width and height of the image is not known in advance, this method
	 * shall be called to make the layout manager wait until the image is loaded.
	 * <p>Currently, [Image] will invoke this method if the width or height of
	 * the image is not specified.
	 */
	void waitImageLoaded(String imgURI);
}

class _LayoutManager extends RunOnceViewManager implements LayoutManager {
	final Map<String, Layout> _layouts;
	final Set<String> _imgWaits;

	_LayoutManager(): super(true), _layouts = {}, _imgWaits = new Set() {
	}

	Layout addLayout(String name, Layout clayout) {
		final Layout old = _layouts[name];
		_layouts[name] = clayout;
		return old;
	}
	Layout removeLayout(String name) {
		return _layouts.remove(name);
	}
	Layout getLayout(String name) {
		return _layouts[name];
	}

	int measureWidth(MeasureContext mctx, View view)
	=> _layoutOfView(view).measureWidth(mctx, view);
	int measureHeight(MeasureContext mctx, View view)
	=> _layoutOfView(view).measureHeight(mctx, view);

	void layout(MeasureContext mctx, View view) {
		if (mctx === null) {
			if (_imgWaits.isEmpty())
				flush(view);
			else if (view !== null)
				queue(view); //do it later
		} else {
			_doLayout(mctx, view);
		}
	}

	Layout _layoutOfView(View view) {
		final String name = view.layout.type;
		final Layout clayout = getLayout(name);
		if (clayout == null)
			throw new UiException("Unknown layout, ${name}");
		return clayout;
	}

	void handle_(View view) {
		_doLayout(new MeasureContext(), view);
	}
	void _doLayout(MeasureContext mctx, View view) {
		_layoutOfView(view).layout(mctx, view);
		view.onLayout();
	}

	void setWidthByProfile(MeasureContext mctx, View view, AsInt width, [AsInt defaultWidth]) {
		final _AmountInfo amt = new _AmountInfo(view.profile.width);
		switch (amt.type) {
		case _AmountInfo.NONE:
			if (defaultWidth !== null)
				view.width = defaultWidth();
			break;
		case _AmountInfo.FIXED:
			view.width = amt.value;
			break;
		case _AmountInfo.FLEX:
			view.width = width();
			break;
		case _AmountInfo.RATIO:
			view.width = (width() * amt.value).round().toInt();
			break;
		case _AmountInfo.CONTENT:
			final int wd = view.measureWidth(mctx);
			if (wd != null)
				view.width = wd;
			break;
		}
	}
	void setHeightByProfile(MeasureContext mctx, View view, AsInt height, [AsInt defaultHeight]) {
		final _AmountInfo amt = new _AmountInfo(view.profile.height);
		switch (amt.type) {
		case _AmountInfo.NONE:
			if (defaultHeight !== null)
				view.height = defaultHeight();
			break;
		case _AmountInfo.FIXED:
			view.height = amt.value;
			break;
		case _AmountInfo.FLEX:
			view.height = height();
			break;
		case _AmountInfo.RATIO:
			view.height = (height() * amt.value).round().toInt();
			break;
		case _AmountInfo.CONTENT:
			final int hgh = view.measureHeight(mctx);
			if (hgh != null)
				view.height = hgh;
			break;
		}
	}
	int measureWidthByContent(MeasureContext mctx, View view) {
		int wd = mctx.widths[view];
		return wd !== null || mctx.widths.containsKey(view) ? wd:
			_measureByContent(mctx, view).width;
	}
	int measureHeightByContent(MeasureContext mctx, View view) {
		int hgh = mctx.heights[view];
		return hgh !== null || mctx.heights.containsKey(view) ? hgh:
			_measureByContent(mctx, view).height;
	}
	Size _measureByContent(MeasureContext mctx, View view) {
		CSSStyleDeclaration nodestyle = view.node.style;
		final String pos = nodestyle.position;
		final bool bFixed = pos == "fixed" || pos == "static";
		if (!bFixed)
			nodestyle.position = _posForMeasure;
		final Size size = new Size(view.node.$dom_offsetWidth, view.node.$dom_offsetHeight);
		if (!bFixed)
			nodestyle.position = pos !== null ? pos: ""; //TODO: assign pos directly if Dart returns empty
		mctx.widths[view] = size.width;
		mctx.heights[view] = size.height;
		return size;
	}
	static String get _posForMeasure() {
		if (_cachedP4M === null)
			_cachedP4M = device.ios != null && device.ios < 5 ? "static": "fixed";
		return _cachedP4M;
	}
	static String _cachedP4M;

	void waitImageLoaded(String imgURI) {
		if (!_imgWaits.contains(imgURI)) {
			_imgWaits.add(imgURI);
			final ImageElement img = new Element.tag("img");
			var func = (event) {
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

/** The layout manager used in [View]. */
LayoutManager get layoutManager() {
	if (_cacheLayoutManager === null) {
		_cacheLayoutManager = new LayoutManager();
		_cacheLayoutManager.addLayout("linear", new LinearLayout());
		FreeLayout freeLayout = new FreeLayout();
		_cacheLayoutManager.addLayout("none", freeLayout);
		_cacheLayoutManager.addLayout("", freeLayout);
	}
	return _cacheLayoutManager;
}
LayoutManager _cacheLayoutManager;
