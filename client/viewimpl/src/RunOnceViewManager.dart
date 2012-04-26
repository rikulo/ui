//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 26, 2012  7:38:18 PM
// Author: tomyeh

/**
 * A run-once view manager that manages a particular run-once task.
 * The typical use is to extend this class and override [handle_] to
 * handle the view.
 *
 * <p>Then, the user can invoke [queue] to put a view into the queue
 * such that it will be handled later (with [handle_]).
 * If the user won't to force the handling of a particular view
 * or all queued views, he can invoke [flush].
 *
 * <p>The manager assumes if a task is applied to a view, then
 * all of its descendant views will be applied too.
 */
class RunOnceViewManager {
	final RunOnceQueue _runQue;
	final Set<View> _views;
	final bool _ignoreDetached;

	/** Constructor.
	 */
	RunOnceViewManager(bool ignoreDetached):
	_runQue = new RunOnceQueue(), _views = new Set(),
	_ignoreDetached = ignoreDetached {
	}

	/** Adds the given view to the queue.
	 */
	void queue(View view) {
		if (!_ignoreDetached || view.inDocument) {
			_views.add(view);
			_runQue.add("", () {flush();}, 5);
		}
	}
	/** Hanldes the give view, if not null, or
	 * all queued views, if the give view is null.
	 */
	void flush([View view=null]) {
		if (view !== null) {
			_flushOne(view);
		} else {
			_flushAll();
		}
	}
	/** Handles the given view.
	 * Don't call this method directly. It is called automatically
	 * when a view is required to handle.
	 * <p>The deriving class shall override this method to handle
	 * the view anyway it wants.
	 */
	void handle_(View view) {
	}

	void _flushAll() {
		//remove redundent
		for (final View view in _views) {
			if (!_ignoreDetached || view.inDocument) {
				bool redundent = false;
				for (View v = view; (v = v.parent) !== null;)
					if (redundent = _views.contains(v))
						break;
				if (!redundent)
					continue;
			}
			_views.remove(view);
		}

		final List<View> todo = new List.from(_views);
		_views.clear();

		for (final View view in todo) {
			handle_(view);
		}
	}
	void _flushOne(View view) {
			if (!_ignoreDetached || view.inDocument) {
				for (final View v in _views) {
					if ((!_ignoreDetached || v.inDocument)
					&& v.isDescendantOf(view))
						_views.remove(v);
				}
				handle_(view);
			}
	}
}
