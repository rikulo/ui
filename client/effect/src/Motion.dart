//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 25, 2012  11:34:48 PM
//Author: simon

/**
 * The callback function used when [Motion] starts.
 */
typedef void MotionStart(int time, int elapsed, int paused);

/**
 * The callback function used in Motion life cycle.
 */
typedef void MotionEnd(int time, int elapsed, int paused);

/**
 * The callback function used as the [AnimatorTask] callback in Motion.
 */
typedef bool MotionMoving(int time, int elapsed, int paused);

Animator _animator;

Animator _getAnimator() {
  if (_animator == null)
    _animator = new Animator();
  return _animator;
}

/**
 * The control object of an [AnimatorTask], with a built-in life cycle and control APIs.
 */
class Motion {
  
  static final _MOTION_STATE_INIT = 0;
  static final _MOTION_STATE_RUNNING = 1;
  static final _MOTION_STATE_PAUSED = 2;
  
  final MotionStart _startCB;
  final MotionMoving _movingCB;
  final MotionEnd _endCB;
  AnimatorTask _task;
  int _state = _MOTION_STATE_INIT;
  int _startTime, _pausedTimestamp, _pausedTime = 0;
  var data;
  
  Motion([MotionStart start, MotionMoving moving, MotionEnd end, bool autorun = true]) : 
    _movingCB = moving, _startCB = start, _endCB = end {
    
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
          final bool cont = onMoving(time, elapsed, _pausedTime);
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
  
  /**
   * The Animator associated with the motion.
   */
  Animator get animator() => _getAnimator();
  
  /**
   * Return the time when the motion starts.
   */
  int get startTime() => _startTime;
  
  /**
   * Return the total paused time.
   */
  int get pausedTime() => _pausedTime;
  
  /**
   * Called in each animator iteration, when the motion is at running state.
   */
  bool onMoving(int time, int elapsed, int paused) => 
      _movingCB == null || _movingCB(time, elapsed, paused);
  
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
  
  /**
   * Start the motion, or resume it from a pause.
   */
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
  
  /**
   * Pause the motion. 
   */
  void pause() {
    if (_state != _MOTION_STATE_RUNNING)
      return;
    _state = _MOTION_STATE_PAUSED;
  }
  
  /**
   * Stop the motion and reset the internal states.
   */
  void stop() {
    _getAnimator().remove(this._task);
    _startTime = _pausedTimestamp = null;
    _pausedTime = 0;
    _state = _MOTION_STATE_INIT;
  }
  
  /**
   * Return true if the motion is at running state.
   */
  bool isRunning() => _state == _MOTION_STATE_RUNNING;
  
  /**
   * Return true if the motion is at paused state.
   */
  bool isPaused() => _state == _MOTION_STATE_PAUSED;
  
}
