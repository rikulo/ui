//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 03, 2012  1:06:33 PM
// Author: tomyeh
part of rikulo_gesture;

/** The callback invoked by [Scroller] when scrolling starts.
 * 
 * + If false is returned, the scrolling will be cancelled. In other cases 
 * (true or null) the scrolling will continue.
 */
typedef bool ScrollerStart(ScrollerState state);

/** The callback invoked continuously by [Scroller] during scrolling.
 * 
 * + [defaultAction] applies the new scroll position to the Element. You
 * shall call it to attain the default behavior of Scroller.
 * + If false is returned, the scrolling will stop. In other cases (true or null)
 * the scrolling will continue.
 */
typedef bool ScrollerMove(ScrollerState state, void defaultAction());

/** The callback invoked by [Scroller] when scrolling ends.
 */
typedef void ScrollerEnd(ScrollerState state);

/** The callback to snap the given position to, say, a grid line.
 */
typedef Offset ScrollerSnap(Offset position);

/** The scroller used to scroll an element by use of its style's
 * transform property.
 */
class Scroller {
  final bool _hasHor, _hasVer;
  final bool scrollbar;
  final ScrollerStart _start;
  final ScrollerMove _move;
  final ScrollerEnd _end;
  final AsSize _fnContentSize, _fnViewPortSize;
  
  DragGesture _dg;
  _BoundedInertialMotion _bim;
  EasingMotion _stm;
  ScrollerState _state;
  ScrollbarControl _scrollbarCtrl;

  /** Constructor.
   *
   * + [start] is the callback before starting scrolling.
   * If it returns false, the scrolling won't be activated.
   * + [dir]: the direction. If not specified, [Dir.BOTH] is assumed.
   */
  Scroller(Element owner, AsSize viewPortSize, AsSize contentSize,
  {Element handle, Dir direction: Dir.BOTH, bool scrollbar: true, 
  ScrollerSnap snap, ScrollerStart start, ScrollerMove move, ScrollerEnd end}) :
  this.owner = owner, _fnViewPortSize = viewPortSize, _fnContentSize = contentSize,
  this.handle = handle, this.direction = direction, this.scrollbar = scrollbar,
  _hasHor = identical(direction, Dir.HORIZONTAL) || identical(direction, Dir.BOTH),
  _hasVer = identical(direction, Dir.VERTICAL) || identical(direction, Dir.BOTH),
  _start = start, _move = move, _end = end {
    
    _dg = new DragGesture(handle != null ? handle : owner,
    start: (DragGestureState state) => _onStart(state.eventTarget, state.time), // TODO: stop _stm
    move: (DragGestureState state) {
      _onMove(state.transition - _state.startPosition, state.time);
      
    }, end: (DragGestureState state) {
      final Offset pos = new DomAgent(owner).offset;
      final Rectangle range = _state.dragRange;
      // always go through this motion
      _bim = new _BoundedInertialMotion(owner, state.velocity, range, 
        _hor, _ver, _onMove, _onEnd, snap: snap)..run();
      
    });
    
    // init scroll bar
    if (scrollbar) {
      _scrollbarCtrl = _scrollbarControl();
      if (_scrollbarCtrl != null)
        _applyScrollBarFunction0(_scrollbarCtrl.init);
    }
    
    //TODO: support desktop - if not in simulator, mousewheel/draggable scrollbar
    // TODO: inertial, bounce
  }
  
  /** Stop current scrolling.
   */
  void stop() {
    if (_bim != null) {
      _bim.stop();
      _bim = null;
    }
    if (_stm != null) {
      _stm.stop();
      _stm = null;
    }
    _state = null;
  }
  
  /** Destroys the scroller.
   * It shall be called to clean up the scroller, if it is no longer used.
   */
  void destroy() {
    _state = null;
    if (scrollbar && _scrollbarCtrl != null)
      _applyScrollBarFunction0(_scrollbarCtrl.destroy);
    _dg.destroy();
  }
  
  /** Returns the direction that the scrolling is allowed.
   */
  final Dir direction;
  
  /** Returns the owner that associates to the scroller.
   */
  final Element owner;
  
  /** Returns the handle element that associates to the scroller, if any.
   */
  final Element handle;
  
  /** Return true if it is currently scrolling.
   */
  bool get isScrolling => _state != null;

  /** Return the current scroll position.
   */
  Offset get scrollPosition => 
      _state != null ? _state.position : (new DomAgent(owner).offset * -1);
  
  /** Set the scroll position. The current scrolling motion, if any, will be stopped.
   */
  void set scrollPosition(Offset position) => scrollTo(position, false);
  
  /** Set the scroll position. The current scrolling, if any, will be stopped.
   * + If [animate], scroll to the position continously. Otherwise the position
   * is updated instantly.
   */
  void scrollTo(Offset position, [bool animate = true]) {
    position = position * -1;
    stop();
    if (animate) {
      final Offset initPos = scrollPosition * -1, diffPos = position - initPos;
      _stm = new EasingMotion((num x, MotionState state) {
        _onMove(initPos + diffPos * x, state.currentTime, false);
        
      }, start: (MotionState state) {
        _onStart(null, state.currentTime, false);
        
      }, end: (MotionState state) {
        _onEnd(false);
        
      })..run();
      
    } else {
      int time = new Date.now().millisecondsSinceEpoch;
      _onStart(null, time, false); // TODO: 1rupt drag?
      _onMove(position, time, false);
      _onEnd(false);
    }
  }
  
  // scrolling mechanism //
  bool _onStart(EventTarget target, int time, [bool callback = true]) {
    if (_bim != null)
      _bim.stop();
    _state = new ScrollerState._(this, target, _fnViewPortSize, _fnContentSize, time);
    if (scrollbar && _scrollbarCtrl != null)
      _applyScrollBarFunction1(_scrollbarCtrl.start, _state);
    if (!callback || _start == null)
      return true;
    final bool res = _start(_state);
    return res == null || res;
  }
  
  void _onMove(Offset position, int time, [bool callback = true]) {
    _state.snapshot(position, time);
    if (scrollbar && _scrollbarCtrl != null)
      _applyScrollBarFunction1(_scrollbarCtrl.move, _state);
    if (callback && _move != null) {
      if (identical(_move(_state, () => _applyPosition(position)), false)) {
        // TODO stop
      }
    } else
      _applyPosition(position);
  }
  
  void _onEnd([bool callback = true]) {
    if (callback && _end != null)
      _end(_state);
    if (scrollbar && _scrollbarCtrl != null)
      _applyScrollBarFunction1(_scrollbarCtrl.end, _state);
    _state = null;
    _bim = null;
  }
  
  void _applyPosition(Offset position) {
    if (_hor)
      owner.style.left = Css.px(position.left);
    if (_ver)
      owner.style.top = Css.px(position.top);
  }
  
  // scroll bar //
  ScrollbarControl _scrollbarControl() => new ScrollbarControl(this, this.owner);
  
  void _applyScrollBarFunction0(Function f) {
    if (_hor)
      f(false);
    if (_ver)
      f(true);
  }
  
  void _applyScrollBarFunction1(Function f, ScrollerState state) {
    if (_hor)
      f(false, state);
    if (_ver)
      f(true, state);
  }
  
  bool get _hor => _state != null ? _state._hor : _hasHor;
  bool get _ver => _state != null ? _state._ver : _hasVer;
}

/**
 * The state in a scolling process, provided by [Scroller] in [ScrollerStart] and
 * [ScrollerMove] callback.
 */
class ScrollerState extends GestureState {
  final AsSize _fnViewPortSize, _fnContentSize;
  bool _hor, _ver;
  Offset _pos, _ppos;
  int _time, _ptime;
  Size _contentSizeCache, _viewPortSizeCache;
  Rectangle _dragRangeCache;

  ScrollerState._(Scroller scroller, EventTarget this.eventTarget, 
  this._fnViewPortSize, this._fnContentSize, this._time) :
  this.scroller = scroller,
  startPosition = new DomAgent(scroller.owner).offset * -1 {
    _pos = startPosition;
    Size cs = contentSize, vs = viewPortSize;
    _hor = scroller._hasHor && cs.width > vs.width;
    _ver = scroller._hasVer && cs.height > vs.height;
  }

  //@override
  final EventTarget eventTarget;
  //@override
  int get time => _time;
  /** Returns the associated [Scroller].
   */
  final Scroller scroller;
  
  /** Returns the current scroll offset.
   */
  Offset get position => _pos;
  /** The starting position.
   */
  final Offset startPosition;
  
  /** Returns the current scrolling velocity.
   */
  Offset get velocity => _ppos == null || _pos == null || _time == null || _ptime == null ? 
      new Offset(0, 0) : ((_pos - _ppos) / (_time - _ptime));
  /** Returns the size of view port.
   */
  Size get viewPortSize {
    if (_viewPortSizeCache == null)
      _viewPortSizeCache = _fnViewPortSize();
    return _viewPortSizeCache;
  }
  /** Returns the content size.
   */
  Size get contentSize {
    if (_contentSizeCache == null)
      _contentSizeCache = _fnContentSize();
    return _contentSizeCache;
  }
  
  /** Tell scroller state to re-determine view port and content sizes.
   */
  void resize() {
    _viewPortSizeCache = _contentSizeCache = null;
    _dragRangeCache = null;
  }
  
  Rectangle get dragRange {
    if (_dragRangeCache == null) {
      Size vsize = viewPortSize,
          csize = contentSize;
      _dragRangeCache = new Rectangle(vsize.width - csize.width, vsize.height - csize.height, 0, 0);
    }
    return _dragRangeCache;
  }

  void snapshot(Offset pos, int time) {
    if (_time == null || time > _time) {
      _ppos = _pos;
      _ptime = _time;
      _pos = pos * -1;
      _time = time;
    }
  }
}

/**
 * The controller of a virtual scroll bar which appears when scrolling.
 */
class ScrollbarControl {
  /* bar inner size: 4px
   * bar border: 1px
   * bar margin: 2px
   */
  static const _mgs = 2, _bds = 1, _ins = 4;

  Element _hbar, _vbar;

  ScrollbarControl(this.scroller, this.owner);

  ///The scrollbar
  final Scroller scroller;
  ///The owner
  final Element owner;
  
  /** Initialization of scroll bar.
   */
  void init(bool vertical) {
    if (vertical) {
      _vbar = new Element.tag("div");
      _vbar.classes = ["v-scrollbar-ver"];
      _vbar.style.width = Css.px(_ins); // do here to have better sync
      _vbar.style.display = "none";
      owner.parent.insertBefore(_vbar, owner.nextElementSibling);
    } else {
      _hbar = new Element.tag("div");
      _hbar.classes = ["v-scrollbar-hor"];
      _hbar.style.height = Css.px(_ins); // do here to have better sync
      _hbar.style.display = "none";
      owner.parent.insertBefore(_hbar, owner.nextElementSibling);
    }
  }
  
  /** Destory the scroll bar.
   */
  void destroy(bool vertical) {
    if (vertical) {
      _vbar.remove();
      _vbar == null;
    } else {
      _hbar.remove();
      _hbar == null;
    }
  }
  
  /** Called when scrolling starts.
   */
  void start(bool vertical, ScrollerState state) {
    _updateBarSize(vertical, state);
    _updateBarPosition(vertical, state);
    final Element bar = vertical ? _vbar : _hbar;
    bar.style.display = "block"; // TODO: animation + leave hook to cancel
  }
  
  /** Called at each scrolling iteraion.
   */
  void move(bool vertical, ScrollerState state) {
    _updateBarPosition(vertical, state);
  }
  
  /** Called when scrolling stops.
   */
  void end(bool vertical, ScrollerState state) {
    final Element bar = vertical ? _vbar : _hbar;
    bar.style.display = "none"; // TODO: animation + leave hook to skip
  }
  
  void _updateBarSize(bool ver, ScrollerState state) {
    final Size csize = state.contentSize;
    final Size vsize = state.viewPortSize;
    final num csize0 = ver ? csize.height : csize.width;
    final num vsize0 = ver ? vsize.height : vsize.width;
    final num s = ((vsize0 - _mgs * 2) * (csize0 > vsize0 ? vsize0 / csize0 : 1)).toInt() - _bds * 2;
    final num off = (ver ? vsize.width : vsize.height) - _mgs - _ins - _bds * 2;
    if (ver) {
      _vbar.style.height = Css.px(s);
      _vbar.style.left = Css.px(off);
    } else {
      _hbar.style.width = Css.px(s);
      _hbar.style.top = Css.px(off);
    }
  }
  
  void _updateBarPosition(bool ver, ScrollerState state) {
    final Size csize = state.contentSize;
    final Size vsize = state.viewPortSize;
    final num csize0 = ver ? csize.height : csize.width;
    final num vsize0 = ver ? vsize.height : vsize.width;
    final num pos = ver ? state.position.y : state.position.x;
    final num x = _mgs + (csize0 > vsize0 ? ((vsize0 - _mgs * 2) * pos / csize0) : 0);
    if (ver)
      _vbar.style.top = Css.px(x);
    else
      _hbar.style.left = Css.px(x);
  }
  
}

class _BoundedInertialMotion extends Motion {
  
  final bool _hor, _ver;
  final Element element;
  final num friction, bounce, snapSpeedThreshold;
  final Rectangle range;
  final Function _move, _end, _snap;
  num _posx, _posy, _velx, _vely;
  Motion _snapMotion;
  
  _BoundedInertialMotion(Element element, Offset velocity, this.range, 
  this._hor, this._ver, void move(Offset position, int time), void end(),
  {num friction: 0.0005, num bounce: 0.0002, num snapSpeedThreshold: 0.05, ScrollerSnap snap}) :
  this.element = element, this.friction = friction, this.bounce = bounce,
  this.snapSpeedThreshold = snapSpeedThreshold, _move = move, _end = end, _snap = snap {
    final Offset pos = new DomAgent(element).offset;
    _posx = pos.x;
    _posy = pos.y;
    _velx = _hor ? velocity.x : 0;
    _vely = _ver ? velocity.y : 0;
  }
  //@override  
  bool onMove(MotionState state) {
    final Offset vel = new Offset(_velx, _vely);
    final num speed = vel.norm();
    final Offset dir = speed == 0 ? new Offset(0, 0) : vel / speed;
    final Offset dec = dir * friction;
    final int elapsed = state.elapsedTime;
    
    if (_hor)
      _posx = _updatePosition(_posx, _velx, dec.x, elapsed, range.x, range.right);
    if (_ver)
      _posy = _updatePosition(_posy, _vely, dec.y, elapsed, range.y, range.bottom);
    
    if (_move != null)
      _move(new Offset(_posx, _posy), state.currentTime);
    
    if (_hor)
      _velx = _updateVelocity(_posx, _velx, dec.x, elapsed, range.x, range.right);
    if (_ver)
      _vely = _updateVelocity(_posy, _vely, dec.y, elapsed, range.y, range.bottom);
    
    if (_shallSnap())
      return false;
    
    return (_hor && !_shallStop(_posx, _velx, range.x, range.right)) ||
        (_ver && !_shallStop(_posy, _vely, range.y, range.bottom)); 
  }
  
  //@override  
  void onEnd(MotionState state) {
    if (_snapTo != null) {
      _snapMotion = new LinearPathMotion(element, new Offset(_posx, _posy), _snapTo,
      move: (MotionState ms, Offset pos, num x, void defaultAction()) {
        defaultAction();
        if (_move != null)
          _move(pos, ms.currentTime);
      }, end: (MotionState ms) {
        if (_end != null)
          _end();
      }, period: 200, easing: (num x) => x * x)..run();
    } else if (_end != null)
      _end();
  }
  
  void stop() {
    if (_snapMotion != null)
      _snapMotion.stop();
    super.stop();
  }
  
  num _updatePosition(num pos, num vel, num dec, int elap, num lbnd, num rbnd) {
    num npos = pos + vel * elap;
    if (pos < lbnd && npos > lbnd && vel > 0)
      return lbnd;
    else if (pos > rbnd && npos < rbnd && vel < 0)
      return rbnd;
    return npos;
  }
  
  num _updateVelocity(num pos, num vel, num dec, int elap, num lbnd, num rbnd) {
    if ((pos == lbnd && vel > 0) || (pos == rbnd && vel < 0))
      return 0;
    num acc = pos < lbnd ? (lbnd - pos) * bounce :
              pos > rbnd ? (rbnd - pos) * bounce : -dec;
    num nvel = vel + acc * elap;
    if ((nvel > 0 && vel < 0) || (nvel < 0 && vel > 0)) // decelerate to 0 at most
      return 0;
    return nvel;
  }
  
  bool _shallStop(num pos, num vel, num lbnd, num rbnd) =>
    lbnd <= pos && pos <= rbnd && vel == 0;
  
  // snap //
  Offset _snapTo;
  
  bool _shallSnap() {
    // use max, not norm, as x/y motion should be considered independent
    // i.e. shall snap when both x & y motion are nearly stopped
    if (_snap == null || max(_velx.abs(), _vely.abs()) > snapSpeedThreshold)
      return false;
    // do not snap outside of the range
    if ((!_hor || _posx < range.x || _posx > range.right) &&
        (!_ver || _posy < range.y || _posy > range.bottom))
      return false;
    Offset scrPos = new Offset(-_posx, -_posy), scrSnapPos = _snap(scrPos);
    if (scrSnapPos == null)
      return false;
    scrSnapPos = range.snap(scrSnapPos * -1) * -1;
    if ((!_hor || scrSnapPos.x == scrPos.x) &&
        (!_ver || scrSnapPos.y == scrPos.y))
      return false;
    _snapTo = scrSnapPos * -1;
    return true;
  }
  
}
