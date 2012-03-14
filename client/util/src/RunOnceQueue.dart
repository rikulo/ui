//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Sat Feb  4 18:18:39 TST 2012
// Author: tomyeh

/** The run-once task scheduled by <code>View.runOnce()</code>.
 */
typedef void RunOnceTask();

/**
 * A task queue used to manage deferred run-once tasks.
 * A run-once task is a task that needs to be executed only once.
 * In other words, the result is the same no matter how many
 * times they are executed.
 *
 * <p>If a run-once task takes long to execute, you can schedule it for
 * execution  by invoking [add].
 * Then, the second task with the same key will replace the previous task
 * if it is not executed yet.
 */
class RunOnceQueue {
	Map<String, int> _tasks;

	/** schedules a run-once task for execution.
	 */
	void add(String key, RunOnceTask task, [int timeout=0]) {
		if (_tasks === null)
			_tasks = {};

		final int tid = _tasks[key];
		if (tid !== null)
			window.clearTimeout(tid);

		_tasks[key] = window.setTimeout((){
			_tasks.remove(key);
			task();
		}, timeout);
	}
}
