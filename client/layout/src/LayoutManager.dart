//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  9:56:30 AM
// Author: tomyeh

/**
 * The layout mananger that manages the layout controllers ([Layout]).
 * There is exactly one layout manager per application.
 */
interface LayoutManager default _LayoutManager {
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
	/** Mesures the size of the given view.
	 */
	Size measure(MeasureContext ctx, View view);
}

class _LayoutManager extends RunOnceViewManager implements LayoutManager {
	final Map<String, Layout> _layouts;

	_LayoutManager(): super(true), _layouts = {} {
	}

	Layout addLayout(String name, Layout layout) {
		final Layout old = _layouts[name];
		_layouts[name] = layout;
		return old;
	}
	Layout removeLayout(String name) {
		return _layouts.remove(name);
	}
	Layout getLayout(String name) {
		return _layouts[name];
	}

	Size measure(MeasureContext ctx, View view) {
	}
	void handle_(View view) {
		
	}
}

/** The layout manager used in [View]. */
LayoutManager get layoutManager() {
	if (_cachedLM === null) {
		_cachedLM = new LayoutManager();
		_cachedLM.addLayout("linear", new LinearLayout());
		FreeLayout freeLayout = new FreeLayout();
		_cachedLM.addLayout("none", freeLayout);
		_cachedLM.addLayout("", freeLayout);
	}
	return _cachedLM;
}
LayoutManager _cachedLM;
