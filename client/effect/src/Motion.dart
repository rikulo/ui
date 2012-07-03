//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 25, 2012  11:34:48 PM
//Author: simon

/**
 * The control object of an [AnimatorTask], with a built-in life cycle and control APIs.
 */
interface Motion default _Motion {
  
  /**
   * The Animator associated with the motion.
   */
  Animator get animator();
  
  /**
   * Start the motion, or resume it from a pause.
   */
  void run();
  
  /**
   * Pause the motion. 
   */
  void pause();
  
  /**
   * Stop the motion and reset the internal states.
   */
  void stop();
  
  /**
   * Return the time when the motion starts.
   */
  int get startTime();
  
  /**
   * Return the total paused time.
   */
  int get pausedTime();
  
  /**
   * Return true if the motion is at running state.
   */
  bool isRunning();
  
  /**
   * Return true if the motion is at paused state.
   */
  bool isPaused();
  
}

/**
 * The callback function used in Motion life cycle.
 */
typedef void MotionCallback(int time, int elapsed, int paused);

/**
 * The callback function used as the [AnimatorTask] callback in Motion.
 */
typedef bool MotionRunner(int time, int elapsed, int paused);

Animator _animator;

Animator _getAnimator() {
  if (_animator == null)
    _animator = new Animator();
  return _animator;
}

class _Motion implements Motion {
  
  static final _MOTION_STATE_INIT = 0;
  static final _MOTION_STATE_RUNNING = 1;
  static final _MOTION_STATE_PAUSED = 2;
  
  final MotionRunner _runner;
  final MotionCallback _startCB, _endCB;
  AnimatorTask _task;
  int _state = _MOTION_STATE_INIT;
  int _startTime, _pausedTimestamp, _pausedTime = 0;
  var data;
  
  _Motion([MotionRunner run, MotionCallback start, MotionCallback end, bool autorun = true]) : 
    _runner = run, _startCB = start, _endCB = end {
    
    _task = (int time, int elapsed) {
      if (_state == _MOTION_STATE_INIT) {
        _startTime = time;
        onStart(time, elapsed);
        _state = _MOTION_STATE_RUNNING;
      }
      switch (_state) {
        case _MOTION_STATE_RUNNING:
          if (_pausedTimestamp != null) { // resume from pause
            _pausedTime += time - _pausedTimestamp;
            _pausedTimestamp = null;
            onResume(time, elapsed, _pausedTime);
          }
          final bool cont = onRunning(time, elapsed, _pausedTime);
          if (!cont)
            onEnd(time, elapsed, _pausedTime);
          return cont;
        case _MOTION_STATE_PAUSED:
          if (_pausedTimestamp == null) { // pause from running
            _pausedTimestamp = time;
            onPause(time, elapsed, _pausedTime);
          }
          return true; // do nothing but keep in the loop
      }
    };
    
    if (autorun)
      this.run();
  }
  
  Animator get animator() => _getAnimator();
  
  int get startTime() => _startTime;
  
  int get pausedTime() => _pausedTime;
  
  /**
   * Called in each animator iteration, when the motion is at running state.
   */
  bool onRunning(int time, int elapsed, int paused) => 
      _runner == null || _runner(time, elapsed, paused);
  
  /**
   * Called in the first animator iteration after the motion is added into animator.
   */
  void onStart(int time, int elapsed) {
    if (_startCB != null)
      _startCB(time, elapsed, 0);
  }
  
  /**
   * Called after the runner returns false. Calling stop() will not invoke this function.
   */
  void onEnd(int time, int elapsed, int paused) {
    if (_endCB != null)
      _endCB(time, elapsed, paused);
  }
  
  /**
   * Called in the first animator iteration after the motion is paused.
   */
  void onPause(int time, int elapsed, int paused) {}
  
  /**
   * Called in the first animator iteration after the motion is resumed from pause.
   */
  void onResume(int time, int elapsed, int paused) {}
  
  void run() {
    switch (_state) {
      case _MOTION_STATE_RUNNING:
        return;
      case _MOTION_STATE_PAUSED:
        _state = _MOTION_STATE_RUNNING; // resume
        break;
      case _MOTION_STATE_INIT:
        _getAnimator().add(this._task);
    }
  }
  
  void pause() {
    if (_state != _MOTION_STATE_RUNNING)
      return;
    _state = _MOTION_STATE_PAUSED;
  }
  
  void stop() {
    _getAnimator().remove(this._task);
    _startTime = _pausedTimestamp = null;
    _pausedTime = 0;
    _state = _MOTION_STATE_INIT;
  }
  
  bool isRunning() => _state == _MOTION_STATE_RUNNING;
  
  bool isPaused() => _state == _MOTION_STATE_PAUSED;
  
}
