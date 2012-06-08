//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Sat Feb  4 18:18:39 TST 2012
// Author: tomyeh

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
    if (_tasks !== null)
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
    if (tid !== null)
      window.clearTimeout(tid);
  }  
}
