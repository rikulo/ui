//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 25, 2012  11:34:48 PM
//Author: simon
part of rikulo_effect;

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

final Animator _animator = new Animator();

/** The state in a [Motion].
 */
class MotionState {
  
  final int startTime;
  int _current, _elapsed, _paused, _pauseStart;
  var data;
  
  MotionState._(int current, {int start, int paused : 0}) : 
    startTime = start != null ? start : current, 
    _current = current, _elapsed = 0, _paused = paused;
  
  /** Return current time, in the form of millisecond since epoch.
   */
  int get currentTime => _current;
  
  /** Return elapsed time since the previous animation frame. At the first 
   * animation frame, the value is 0.
   */
  int get elapsedTime => _elapsed;
  
  /** Return paused time in milliseconds.
   */
  int get pausedTime => _paused;
  
  /** Return the total running time in milliseconds since motion starts, 
   * excluding paused time.
   */
  int get runningTime => _current - startTime - _paused;
  
  /** Return true if paused.
   */
  bool get isPaused => _pauseStart != null;
  
  void _snapshot(int current) {
    _elapsed = current - _current;
    _current = current;
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
  
  static const _MOTION_STATE_INIT = 0;
  static const _MOTION_STATE_RUNNING = 1;
  static const _MOTION_STATE_PAUSED = 2;
  
  final MotionStart _start;
  final MotionMove _move;
  final MotionEnd _end;
  AnimatorTask _task;
  
  MotionState _state;
  int _stateFlag = _MOTION_STATE_INIT;
  
  Motion({MotionStart start, MotionMove move, MotionEnd end}) : 
    _start = start, _move = move, _end = end {
    
    _task = (int time) {
      if (_stateFlag == _MOTION_STATE_INIT) {
        _state = new MotionState._(time);
        onStart(_state);
        _stateFlag = _MOTION_STATE_RUNNING;
      }
      _state._snapshot(time);
      switch (_stateFlag) {
        case _MOTION_STATE_RUNNING:
          if (_state.isPaused) { // resume from pause
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
          if (!_state.isPaused) { // pause from running
            _state._pause(time);
            onPause(_state);
          }
          return true; // do nothing but keep in the loop
      }
    };
  }
  
  /**
   * The Animator associated with the motion.
   */
  Animator get animator => _animator;
  
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
        animator.add(this._task);
        break;
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
    animator.remove(this._task);
    _state = null;
    _stateFlag = _MOTION_STATE_INIT;
  }
  
  /**
   * Return true if the motion is at running state.
   */
  bool get isRunning => _stateFlag == _MOTION_STATE_RUNNING;
  
  /**
   * Return true if the motion is at paused state.
   */
  bool get isPaused => _stateFlag == _MOTION_STATE_PAUSED;
}
