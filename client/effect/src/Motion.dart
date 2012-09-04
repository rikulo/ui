//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 25, 2012  11:34:48 PM
//Author: simon

/**
 * The callback function used when [Motion] starts.
 */
typedef void MotionStart(MotionState state);

/**
 * The callback function used during the movement in [Motion].
 */
typedef bool MotionMove(MotionState state);

/**
 * The callback function used when [Motion] ends.
 */
typedef void MotionEnd(MotionState state);

Animator _animator;

Animator _getAnimator() {
  if (_animator == null)
    _animator = new Animator();
  return _animator;
}

/** The state in a [Motion].
 */
class MotionState {
  
  final int startTime;
  int _current, _elapsed, _paused, _pauseStart;
  var data;
  
  MotionState(int current, int elapsed, [int start, int paused = 0]) : 
    startTime = start != null ? start : current, 
    _current = current, _elapsed = elapsed, _paused = paused;
  
  /** Return current time.
   */
  int get currentTime => _current;
  
  /** Return elapsed time since the previous animation frame.
   */
  int get elapsedTime => _elapsed;
  
  /** Return paused time.
   */
  int get pausedTime => _paused;
  
  /** Return the total running time since motion starts, excluding paused time.
   */
  int get runningTime => _current - startTime - _paused;
  
  /** Return true if paused.
   */
  bool isPaused() => _pauseStart != null;
  
  void _snapshot(int current, int elapsed) {
    _current = current;
    _elapsed = elapsed;
  }
  
  void _pause(int current) {
    _pauseStart = current;
  }
  
  void _resume(int current) {
    if (_pauseStart != null) {
      _paused += current - _pauseStart;
      _pauseStart = null;
    }
  }
  
}

/**
 * The control object of an [AnimatorTask], with a built-in life cycle and control APIs.
 */
class Motion {
  
  static final _MOTION_STATE_INIT = 0;
  static final _MOTION_STATE_RUNNING = 1;
  static final _MOTION_STATE_PAUSED = 2;
  
  final MotionStart _start;
  final MotionMove _move;
  final MotionEnd _end;
  AnimatorTask _task;
  
  MotionState _state;
  int _stateFlag = _MOTION_STATE_INIT;
  
  Motion([MotionStart start, MotionMove move, MotionEnd end, bool autorun = true]) : 
    _start = start, _move = move, _end = end {
    
    _task = (int time, int elapsed) {
      if (_stateFlag == _MOTION_STATE_INIT) {
        _state = new MotionState(time, elapsed);
        onStart(_state);
        _stateFlag = _MOTION_STATE_RUNNING;
      }
      _state._snapshot(time, elapsed);
      switch (_stateFlag) {
        case _MOTION_STATE_RUNNING:
          if (_state.isPaused()) { // resume from pause
            _state._resume(time);
            onResume(_state);
          }
          bool cont = onMove(_state);
          if (cont == null)
            cont = true;
          if (!cont) {
            onEnd(_state);
            _state = null;
            _stateFlag = _MOTION_STATE_INIT;
          }
          return cont;
        case _MOTION_STATE_PAUSED:
          if (!_state.isPaused()) { // pause from running
            _state._pause(time);
            onPause(_state);
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
  Animator get animator => _getAnimator();
  
  /** Retrieve the current [MotionState]. [null] if not running.
   */
  MotionState get state => _state;
  
  /**
   * Called in the first animator iteration after the motion is added into animator.
   */
  void onStart(MotionState state) {
    if (_start != null)
      _start(state);
  }
  
  /**
   * Called in each animator iteration, when the motion is at running state.
   */
  bool onMove(MotionState state) => 
      _move == null || _move(state);
  
  /**
   * Called after the runner returns false. Calling stop() will not invoke this function.
   */
  void onEnd(MotionState state) {
    if (_end != null)
      _end(state);
  }
  
  /**
   * Called in the first animator iteration after the motion is paused.
   */
  void onPause(MotionState state) {}
  
  /**
   * Called in the first animator iteration after the motion is resumed from pause.
   */
  void onResume(MotionState state) {}
  
  /**
   * Start the motion, or resume it from a pause.
   */
  void run() {
    switch (_stateFlag) {
      case _MOTION_STATE_RUNNING:
        return;
      case _MOTION_STATE_PAUSED:
        _stateFlag = _MOTION_STATE_RUNNING; // resume
        break;
      case _MOTION_STATE_INIT:
        _getAnimator().add(this._task);
    }
  }
  
  /**
   * Pause the motion. 
   */
  void pause() {
    if (_stateFlag != _MOTION_STATE_RUNNING)
      return;
    _stateFlag = _MOTION_STATE_PAUSED;
  }
  
  /**
   * Stop the motion and reset the internal states.
   */
  void stop() {
    _getAnimator().remove(this._task);
    _state = null;
    _stateFlag = _MOTION_STATE_INIT;
  }
  
  /**
   * Return true if the motion is at running state.
   */
  bool isRunning() => _stateFlag == _MOTION_STATE_RUNNING;
  
  /**
   * Return true if the motion is at paused state.
   */
  bool isPaused() => _stateFlag == _MOTION_STATE_PAUSED;
  
}
