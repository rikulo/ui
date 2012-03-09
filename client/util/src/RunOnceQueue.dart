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
 * times they are executed. For example, <code>View.rerender()</code>.
 *
 * <p>If a run-once task takes long to execute, you can schedule it for
 * execution  by invoking [add].
 * Then, only the last one will be
 * executed, if multiple tasks with the same key has been added
 * before any of them is executed,
 */
class RunOnceQueue {
	Map<String, int> _tasks;

	/** schedules a run-once task for execution.
	 */
	void add(String key, RunOnceTask task, [int timeout=0]) {
		if (_tasks == null)
			_tasks = {};

		if (_tasks[key] == null)
			_tasks[key] = 1;
		else
			++_tasks[key];

		window.setTimeout((){
			if (--_tasks[key] <= 0) {
				_tasks.remove(key);
				task();
			}
		}, timeout);
	}
}
