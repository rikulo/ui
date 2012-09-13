//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 26, 2012  7:38:18 PM
// Author: tomyeh

/** The task used with [RunOnceViewManager] for handling a view.
 */
typedef void RunOnceViewTask(View view);

/** The callback to check if [RunOnceViewManager] is allowed to handle views.
 * You can register a callback to [RunOnceViewManager] by use of [RunOnceViewManager.addReadyCheck].
 * Once [RunOnceViewManager] is going to handle views, it will invoke all registered
 * callbacks. If one returns false, it won't do anything. Therefore, you can make
 * the manager depends on some external conditions.
 *
 * The call that returns false shall invoke [continueTask] if it is OK to proceed later.
 * In other words, it is the callback's job to resume the handling if it returns false.
 *
 * + [force] whether to force the task to flush the queued task if any.
 */
typedef bool RunOnceReadyCheck(View view, Task continueTask, bool force);

/**
 * A task queue used to manage deferred run-once tasks.
 * A run-once task is a task ([Task]) that needs to be executed only once.
 * In other words, the result is the same no matter how many
 * times they are executed.
 *
 * If a run-once task takes long to execute, you can create an instance
 * of [RunOnceQueue], and schedule the task by invoking [add].
 * Then, the second invocation of [add] with the same key will replace
 * the previous task if it is not executed yet. In other words, the previous
 * task will be dropped (and not executed).
 */
class RunOnceQueue {
  Map<String, int> _tasks;

  /** schedules a run-once task for execution.
   */
  void add(String key, void task(), [int timeout=0]) {
    if (_tasks != null)
      cancel(key);
    else
      _tasks = {};

    _tasks[key] = window.setTimeout((){
      _tasks.remove(key);
      task();
    }, timeout);
  }
  /** Cancels the scheduled task if it is still pending.
   */
  void cancel(String key) {
    final int tid = _tasks.remove(key);
    if (tid != null)
      window.clearTimeout(tid);
  }  
}

/**
 * A run-once view manager is used to manage the view-handling task in
 * a way that the task will be executed only once for each view .
 *
 * To use it, first you assign the view-handling task ([RunOnceViewTask])
 * in the constructor.
 * Then, you can invoke [queue] to put a view into the queue. The view won't be handled
 * immediately. Rather it will be handled later automatically.
 * Moreover, if the view is queued multiple times before it was handled, the task
 * is invoked only once for the given view. That is why it is called run-once.
 *
 * In additions, you can control whether to ignore the view, if the view
 * is not attached to the document. Or, to ignore the view if one of its ancestor is
 * also queued.
 *
 * To enforce the views queued in this manager to be handled immediately, you can invoke
 * [flush].
 */
class RunOnceViewManager {
  final RunOnceQueue _runQue;
  final Set<View> _views;
  final RunOnceViewTask _task;
  final List<RunOnceReadyCheck> _readyChecks;
  final bool _ignoreDetached;
  final bool _ignoreSubviews;

  /** Constructor.
   *
   * + [task] is the view-handling task. Notice that if you pass null here, you have
   * override [handle_] to handle it.
   * + [ignoreDetached] specifies whether to ignore the views that are not attached
   * to the docuemnt (ie.., ignore views if [View.inDocument] is false).
   * + [ignoreSubviews] specifies whether to ignore the sub views. In other words,
   * a view will be ignored, if one of its ancestor has been queued for handling too.
   */
  RunOnceViewManager(RunOnceViewTask task, [bool ignoreDetached=true, bool ignoreSubviews=true]):
  _runQue = new RunOnceQueue(), _views = new Set(), _readyChecks = new List(),
  _task = task, _ignoreDetached = ignoreDetached, _ignoreSubviews = ignoreSubviews {
  }

  /** Returns if there is no view is queued.
   *
   * + [view] if specified, this method check only if the given view and its descendant
   * views is in the queue.
   */
  bool isQueueEmpty([View view]) {
    if (view == null)
      return _views.isEmpty();

    for (final v in _views)
      if (v.isDescendantOf(view))
        return false;
    return true;
  }
  /** Adds the given view to the queue.
   */
  void queue(View view) {
    //we don't check view.inDocument here since it might be attached later
    _views.add(view);
    _runQue.add("", () {flush();}, 5);
  }
  /** Removes the given view from the queue, so the action won't take place.
   */
  void unqueue(View view) {
    _views.remove(view);
  }
  /** Hanldes the give view, if not null, or
   * all queued views, if the give view is null.
   *
   * + [force] specifies whether to force the tasks registered with [addReadyCheck]
   */
  void flush([View view, bool force=false]) {
    if (!_ready(view, force)) {
      if (view != null)
        _views.add(view);
    } else if (view != null) {
      _flushOne(view, force);
    } else {
      _flushAll();
    }
  }
  /** Handles the given view.
   * Don't call this method directly. It is called automatically
   * when a view is required to handle.
   *
   * Default: invoke the task that was assigned in the constructor.
   *
   * You can override this method if you don't pass a task in the constructor.
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
        for (View v = view; (v = v.parent) != null;) {
          if (_views.contains(v)) {//view is subview of v
            _views.remove(view);  //ignore subview (i.e., view)
            break;
          }
        }
      }
    }

    final List<View> todos = new List.from(_views);
    _views.clear();

    for (final v in todos)
      handle_(v);
  }
  void _flushOne(View view, bool force) {
    final found = _views.remove(view);
    if (!_ignoreDetached || view.inDocument) {
      if (_ignoreSubviews) {
        if (!force)
          for (View v = view; (v = v.parent) != null;)
            if (_views.contains(v)) //view is subview of v
              return; //no need to do since the parent will handle it (later)

        for (final View v in _views)
          if (v.isDescendantOf(view))
            _views.remove(v);

        handle_(view);
      } else {
        List<View> todos = [];
        if (found)
          todos.add(view);

        for (final v in _views)
          if (v.isDescendantOf(view))
            todos.add(v);

        for (final v in todos) {
          _views.remove(v);
          handle_(v);
        }
      }
    }
  }
  /** Adds a callback to check if this manager can handle the views (i.e.,
   * whether it has to wait).
   * It is used if you'd like this manage to depend on other conditions.
   */
  void addReadyCheck(RunOnceReadyCheck ready) {
    _readyChecks.add(ready);
  }
  bool _ready(View view, bool force) {
    if (!_readyChecks.isEmpty()) {
      final Task continueTask = () {flush(view, force);};
      for (final RunOnceReadyCheck ready in _readyChecks)
        if (!ready(view, continueTask, force))
          return false;
    }
    return true;
  }
}

class _ModelRenderer extends RunOnceViewManager {
  final List<Task> _contTasks;

  factory _ModelRenderer() {
		//dart2js can't handle closure in super()
    if (_$renderTask == null)
      _$renderTask = (view) {view.renderModel_();};
    return new _ModelRenderer._init(_$renderTask);
  }
  static RunOnceViewTask _$renderTask;

  _ModelRenderer._init(RunOnceViewTask task): super(task, ignoreSubviews: false),
  _contTasks = new List() {
    //For better performance (though optional), we make layoutManager to
    //wait until all pending renderers are done
    layoutManager.addReadyCheck((View view, Task continueTask, bool force) {
      if (force)
        flush(view, true);

      if (isQueueEmpty(view)) //just in case
        return true;

      _contTasks.add(continueTask);
      return false;
    });
  }
  void flush([View view, bool force=false]) {
    super.flush(view, force);

    if (isQueueEmpty()) { //_contTasks runs only after all views are processed
      final List<Task> tasks = new List.from(_contTasks);
      _contTasks.clear();

      for (final task in tasks)
        task();
    }
  }
}
/** The model rendering manager.
 * It assume the view implements a method called _renderModel.
 */
RunOnceViewManager get modelRenderer {
  if (_modelRenderer == null)
    _modelRenderer = new _ModelRenderer();
  return _modelRenderer;
}
RunOnceViewManager _modelRenderer;
