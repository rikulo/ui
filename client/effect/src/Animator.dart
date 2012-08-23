//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  7:12:55 PM
// Author: tomyeh

/** An animation callbak.
 * To start an animation, you can add a callback to [Animator], such that
 * the callback will be called periodically until the callback returns false.
 *
 * To add an animation, please invoke [Animator.add]. If the callback
 * returns false, it will be removed from the animator automatially.
 * If you'd like, you can remove it manually by use of [Animator.remove].
 *
 * + [time] is the milliseconds from 1970-01-01 (UTC).
 * In other words, it is the same as `new Date.now().value`.
 * + [elapsed] is the number of milliseconds elapsed since the previous
 * invocation.
 */
typedef bool AnimatorTask(int time, int elapsed);

/**
 * The animator used to play [AnimatorTask].
 */
interface Animator default _Animator {
  Animator();

  /** Adds an animation callback, such that it will be
   * called periodically.
   */
  void add(AnimatorTask animate);
  /** Removes this animation callback.
   *
   * It is called automatically, if the callback returns false.
   */
  void remove(AnimatorTask animate);
  /** Returns a readonly collection of all animation callbacks.
   */
  Collection<AnimatorTask> get animates;
}

class _Animator implements Animator {
  final List<AnimatorTask> _anims;
  //Used to hold deleted animation callback when callbacks are processed
  List<AnimatorTask> _tmpRemoved;
  Function _callback;
  int _prevTime;

  _Animator(): _anims = new List() {
    _callback = (num now) {
      if (!_anims.isEmpty()) {
        final int inow = now == null ? _now(): now.toInt();
        final int diff = inow - _prevTime;
        _prevTime = inow;

        _beforeCallback();
        try {
          //Note: _anims won't be changed by [remove] because of _beforeCallback
          //so it is OK to use index to iterate
          for (int j = 0; j < _anims.length; ++j) { //note: length might increase
            if (!_isRemoved(j) && !_anims[j](inow, diff)) {
              _anims.removeRange(j, 1);
              --j;
            }
          }
        } finally {
          _afterCallback();
        }

        if (!_anims.isEmpty())
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

    for (final AnimatorTask animate in removed) {
      remove(animate);
    }
  }
  bool _isRemoved(int index) {
    if (!_tmpRemoved.isEmpty()) {
      final AnimatorTask animate = _anims[index];
      int cnt = 0;
      for (final AnimatorTask anim in _tmpRemoved) {
        if (anim == animate)
          ++cnt;
      }
      if (cnt > 0) { //animate shall be deleted
        for (int j = 0; j < index; ++j) {
          if (_anims[j] == animate && --cnt == 0)
            return false;
        }
        return true;
      }
    }
    return false;
  }

  void add(AnimatorTask animate) {
    _anims.add(animate);
    if (_anims.length == 1) {
      _prevTime = _now();
      window.requestAnimationFrame(_callback);
    }
  }
  void remove(AnimatorTask animate) {
    if (_tmpRemoved != null) {
      _tmpRemoved.add(animate); //handle it later
    } else {
      ListUtil.remove(_anims, animate);
    }
  }
  Collection<AnimatorTask> get animates => _anims;  //TODO: readonly

  static int _now() => new Date.now().millisecondsSinceEpoch;
}
