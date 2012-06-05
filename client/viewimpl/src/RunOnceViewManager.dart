//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 26, 2012  7:38:18 PM
// Author: tomyeh

/** The task used with [RunOnceViewManager] for handling a view.
 */
typedef void RunOnceViewTask(View view);

/**
 * A run-once view manager is used to manage the view-handling task in
 * a way that the task will be executed only once for each view .
 *
 * <p>To use it, first you assign the view-handling task ([RunOnceViewTask])
 * in the constructor.
 * Then, you can invoke [queue] to put a view into the queue. The view won't be handled
 * immediately. Rather it will be handled later automatically.
 * Moreover, if the view is queued multiple times before it was handled, the task
 * is invoked only once for the given view. That is why it is called run-once.
 *
 * <p>In additions, you can control whether to ignore the view, if the view
 * is not attached to the document. Or, to ignore the view if one of its ancestor is
 * also queued.
 *
 * <p>To enforce the views queued in this manager to be handled immediately, you can invoke
 * [flush].
 */
class RunOnceViewManager {
	final RunOnceQueue _runQue;
	final Set<View> _views;
	final RunOnceViewTask _task;
	final bool _ignoreDetached;
	final bool _ignoreSubviews;

	/** Constructor.
	 * <p>[_task] is the view-handling task. Notice that if you pass null here, you have
	 * override [handle_] to handle it.
	 * <p>[ignoreDetached] specifies whether to ignore the views that are not attached
	 * to the docuemnt (ie.., ignore views if [View.inDocument] is false).
	 * <p>[ignoreSubviews] specifies whether to ignore the sub views. In other words,
	 * a view is ignored, if one of its ancestor has been queued for handling too.
	 */
	RunOnceViewManager(RunOnceViewTask task, [bool ignoreDetached=true, bool ignoreSubviews=true]):
	_runQue = new RunOnceQueue(), _views = new Set(),
	_task = task, _ignoreDetached = ignoreDetached, _ignoreSubviews = ignoreSubviews {
	}

	/** Adds the given view to the queue.
	 */
	void queue(View view) {
		//we don't check view.inDocument here since it might be attached later
		_views.add(view);
		_runQue.add("", () {flush();}, 5);
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
	 * <p>Default: invoke the task that was assigned in the constructor.
	 * <p>You can override this method if you don't pass a task in the constructor.
	 */
	void handle_(View view) {
		_task(view);
	}

	void _flushAll() {
		//remove redundent
		for (final View view in _views) {
			if (_ignoreDetached && !view.inDocument) {
				_views.remove(view); //ignore detached
				continue;
			}

			if (_ignoreSubviews) {
				for (View v = view; (v = v.parent) !== null;) {
					if (_views.contains(v)) {//view is subview of v
						_views.remove(view);  //ignore subview (i.e., view)
						break;
					}
				}
			}
		}

		final List<View> todo = new List.from(_views);
		_views.clear();

		for (final View view in todo) {
			handle_(view);
		}
	}
	void _flushOne(View view) {
		_views.remove(view);
		if (!_ignoreDetached || view.inDocument) {
			if (_ignoreSubviews) {
				for (final View v in _views) {
					if (v.isDescendantOf(view))
						_views.remove(v);
				}
			}
			handle_(view);
		}
	}
}

/** The model rendering manager.
 * It assume the view implements a method called _renderModel.
 */
RunOnceViewManager get modelRenderer() {
	if (_modelRenderer == null)
		_modelRenderer =
			new RunOnceViewManager((view) {view.renderModel_();}, ignoreSubviews: false);
	return _modelRenderer;
}
RunOnceViewManager _modelRenderer;
