//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  7:12:55 PM
// Author: tomyeh
part of rikulo_effect;

/** An animation task.
 * To start an animation, you can add a task to [Animator], such that
 * the task will be called periodically until the task returns false.
 *
 * To add an animation, please invoke [Animator.add]. If the task
 * returns false, it will be removed from the animator automatially.
 * If you'd like, you can remove it manually by use of [Animator.remove].
 *
 * + [time] is the milliseconds from 1970-01-01 (UTC).
 * In other words, it is the same as `new Date.now().millisecondsSinceEpoch`.
 */
typedef bool AnimatorTask(int time);

/**
 * The animator used to play [AnimatorTask].
 */
abstract class Animator {
  factory Animator() => new _Animator();

  /** Adds an animation task, such that it will be
   * called periodically.
   */
  void add(AnimatorTask task);
  /** Removes this animation task.
   *
   * It is called automatically, if the task returns false.
   */
  void remove(AnimatorTask task);
  /** Returns a readonly collection of all animation tasks.
   */
  Collection<AnimatorTask> get tasks;
}

class _Animator implements Animator {
  final List<AnimatorTask> _tasks;
  //Used to hold deleted animation task when tasks are processed
  List<AnimatorTask> _tmpRemoved;
  Function _callback;

  _Animator(): _tasks = new List() {
    _callback = (num now) {
      if (!_tasks.isEmpty) {
        final int inow = _now();

        _beforeCallback();
        try {
          //Note: _tasks won't be changed by [remove] because of _beforeCallback
          //so it is OK to use index to iterate
          for (int j = 0; j < _tasks.length; ++j) { //note: length might increase
            if (!_isRemoved(j) && !_tasks[j](inow)) {
              _tasks.removeRange(j, 1);
              --j;
            }
          }
        } finally {
          _afterCallback();
        }

        if (!_tasks.isEmpty)
          window.requestAnimationFrame(_callback);
      }
    };
  }
  void _beforeCallback() {
    _tmpRemoved = new List();
  }
  void _afterCallback() {
    final List<AnimatorTask> removed = _tmpRemoved;
    _tmpRemoved = null;

    for (final task in removed)
      remove(task);
  }
  bool _isRemoved(int index) {
    if (!_tmpRemoved.isEmpty) {
      final AnimatorTask task = _tasks[index];
      int cnt = 0;
      for (final t in _tmpRemoved) {
        if (t == task)
          ++cnt;
      }
      if (cnt > 0) { //task shall be deleted
        for (int j = 0; j < index; ++j) {
          if (_tasks[j] == task && --cnt == 0)
            return false;
        }
        return true;
      }
    }
    return false;
  }

  void add(AnimatorTask task) {
    _tasks.add(task);
    if (_tasks.length == 1) {
      window.requestAnimationFrame(_callback);
    }
  }
  void remove(AnimatorTask task) {
    if (_tmpRemoved != null) {
      _tmpRemoved.add(task); //handle it later
    } else {
      ListUtil.remove(_tasks, task);
    }
  }
  Collection<AnimatorTask> get tasks => _tasks;

  static int _now() => new Date.now().millisecondsSinceEpoch;
}
