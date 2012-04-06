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

	/** Sizes the given view with the information presented in
	 * [MeasureContext].
	 */
	void sizeView(MeasureContext mctx, View view);
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
		_layoutOfView(view).layout(new MeasureContext(view), view);
	}

	void sizeView(MeasureContext mctx, View view) {
		final Size size = mctx.measures[view];
		if (size != null) {
			if (size.width != NO_LIMIT)
				view.width = size.width;
			if (size.height != NO_LIMIT)
				view.height = size.height;
		}
	}
	/** Sizes a view based on its profile.
	 */
	void sizeByProfile(View view, int width, int height) {
		_SizeInfo inf = new _SizeInfo(view.profile.width);
		switch (inf.type) {
		case _SizeInfo.FLEX:
			view.width = width;
			break;
		case _SizeInfo.RATIO:
			view.width = (width * inf.value).round();
			break;
		}

		inf = new _SizeInfo(view.profile.height);
		switch (inf.type) {
		case _SizeInfo.FLEX:
			view.height = height;
			break;
		case _SizeInfo.RATIO:
			view.height = (height * inf.value).round();
			break;
		}
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
