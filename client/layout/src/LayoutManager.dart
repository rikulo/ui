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

	/** Sizes a view based on its profile.
	 * It is an utility for implementing a layout.
	 */
	void sizeByProfile(MeasureContext mctx, View view, AsInt width, AsInt height);
	/** Measures the content's size.
	 * It is an utility for implementing a view's [View.measureSize].
	 * This method assumes the browser will resize the view automatically,
	 * so it is applied only to a leaf view with some content, such as [TextView]
	 * and [Button].
	 */
	Size measureContentSize(MeasureContext mctx, View view);
}

class _LayoutManager extends RunOnceViewManager implements LayoutManager {
	final Map<String, Layout> _layouts;

	_LayoutManager(): super(true), _layouts = {} {
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

	Size measureSize(MeasureContext mctx, View view)
	=> _layoutOfView(view).measureSize(mctx, view);

	void layout(MeasureContext mctx, View view) {
		if (mctx === null)
			flush(view); //so it will clean up _layouts
		else
			_layoutOfView(view).layout(mctx, view);
	}

	Layout _layoutOfView(View view) {
		final String name = view.layout.type;
		final Layout clayout = getLayout(name);
		if (clayout == null)
			throw new UiException("Unknown layout, ${name}");
		return clayout;
	}

	void handle_(View view) {
		_layoutOfView(view).layout(new MeasureContext(), view);
	}

	void sizeByProfile(MeasureContext mctx, View view, AsInt width, AsInt height) {
		_SizeInfo inf = new _SizeInfo(view.profile.width);
		switch (inf.type) {
		case _SizeInfo.FIXED:
			view.width = inf.value;
			break;
		case _SizeInfo.FLEX:
			view.width = width();
			break;
		case _SizeInfo.RATIO:
			view.width = (width() * inf.value).round();
			break;
		case _SizeInfo.CONTENT:
			final Size sz = view.measureSize(mctx);
			if (sz != null && sz.width != MeasureContext.NO_LIMIT)
				view.width = sz.width;
			break;
		}

		inf = new _SizeInfo(view.profile.height);
		switch (inf.type) {
		case _SizeInfo.FIXED:
			view.height = inf.value;
			break;
		case _SizeInfo.FLEX:
			view.height = height();
			break;
		case _SizeInfo.RATIO:
			view.height = (height() * inf.value).round();
			break;
		case _SizeInfo.CONTENT:
			final Size sz = view.measureSize(mctx);
			if (sz != null && sz.height != MeasureContext.NO_LIMIT)
				view.height = sz.height;
			break;
		}
	}
	Size measureContentSize(MeasureContext mctx, View view) {
		Size size = mctx.measures[view];
		if (size === null) {
			final String pos = view.style.position;
			final bool bFixed = pos == "fixed";
			if (!bFixed) view.style.position = "fixed";

			size = new Size(view.node.$dom_offsetWidth, view.node.$dom_offsetHeight);

			if (!bFixed) view.style.position = pos;
			mctx.measures[view] = size;
		}
		return size;
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
