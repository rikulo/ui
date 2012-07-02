//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 25, 2012  11:34:48 PM
//Author: simon

/**
 * The control object of an Animate, with a built-in life cycle and control APIs.
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
  int get initTime();
  
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
 * The callback function used as the Animate callback in Motion.
 */
typedef bool MotionRunner(int time, int elapsed, int paused);

Animator _animator = new Animator();

class _Motion implements Motion {
  
  static final _MOTION_STATE_INIT = 0;
  static final _MOTION_STATE_RUNNING = 1;
  static final _MOTION_STATE_PAUSED = 2;
  
  final MotionRunner _runner;
  final MotionCallback _initCB, _endCB;
  Animate _animate;
  int _state = _MOTION_STATE_INIT;
  int _initTime, _pausedTimestamp, _pausedTime = 0;
  var data;
  
  static _defaultAnimator(Animator a) => a != null ? a : new Animator();
  
  _Motion([Animator animator, MotionRunner run, MotionCallback init, 
           MotionCallback end, bool autorun = true]) : 
             _runner = run, _initCB = init, _endCB = end {
    
    _animate = (int time, int elapsed) {
      if (_state == _MOTION_STATE_INIT) {
        _initTime = time;
        onInit(time, elapsed);
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
  
  Animator get animator() => _animator;
  
  int get initTime() => _initTime;
  
  int get pausedTime() => _pausedTime;
  
  /**
   * Called in each animator iteration, when the motion is at running state.
   */
  bool onRunning(int time, int elapsed, int paused) => 
      _runner == null || _runner(time, elapsed, paused);
  
  /**
   * Called in the first animator iteration after the motion is added into animator.
   */
  void onInit(int time, int elapsed) {
    if (_initCB != null)
      _initCB(time, elapsed, 0);
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
        _animator.add(this._animate);
    }
  }
  
  void pause() {
    if (_state != _MOTION_STATE_RUNNING)
      return;
    _state = _MOTION_STATE_PAUSED;
  }
  
  void stop() {
    _animator.remove(this._animate);
    _initTime = _pausedTimestamp = null;
    _pausedTime = 0;
    _state = _MOTION_STATE_INIT;
  }
  
  bool isRunning() => _state == _MOTION_STATE_RUNNING;
  
  bool isPaused() => _state == _MOTION_STATE_PAUSED;
  
}
