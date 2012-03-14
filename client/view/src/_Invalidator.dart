//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Mar 13, 2012  2:14:29 PM
// Author: tomyeh

/**
 * Invalidators handles the invalidated views
 */
class _Invalidator {
	final RunOnceQueue _runQue;
	final Set<View> _views;

	_Invalidator(): _runQue = new RunOnceQueue(), _views = new Set() {
	}

	/** Add the give queue to the invalidated queue.
	 */
	void add(View view) {
		if (view.inDocument) {
			_views.add(view);
			_runQue.add("", () {redraw();}, 5);
		}
	}
	/** Redraws the views queued in the invalidated queue.
	 */
	void redraw() {
		//remove redundent
		for (final View view in _views) {
			if (view.inDocument) {
				bool redundent = false;
				for (View v = view; (v = v.parent) !== null;)
					if (redundent = _views.contains(v))
						break;
				if (!redundent)
					continue;
			}
			_views.remove(view);
		}

		for (final View view in _views) {
			final Element n = view.node;
			if (n != null) {
				view._exitDocument();
				view.addToDocument(n, outer: true);
			}
		}
		_views.clear();
	}
}

_Invalidator get _invalidator() {
	if (_cacheInvalidator == null)
		_cacheInvalidator = new _Invalidator();
	return _cacheInvalidator;
}
_Invalidator _cacheInvalidator;