//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 03, 2012  1:06:33 PM
// Author: tomyeh

/**
 * The callback when [Scroller] tries to start the scrolling.
 * If it returns false, the scroller won't be activated (i.e., ignored).
 */
typedef bool ScrollerStart(ScrollerState state);
/** The callback that [Scroller] uses to indicate the user is scrolling,
 * or the user ends the scrolling (i.e., releases the finger).
 */
typedef void ScrollerMove(ScrollerState state);

/** The scroller used to scroll an element by use of its style's
 * transform property.
 */
interface Scroller default _Scroller {
  /** Constructor.
   *
   * + [start] is the callback before starting scrolling.
   * If it returns false, the scrolling won't be activated.
   * + [dir]: the direction. If not specified, [Dir.BOTH] is assumed.
   */
  Scroller(Element owner, AsSize viewPortSize, AsSize contentSize,
    [Element handle, Dir direction, bool scrollbar, 
      ScrollerStart start, ScrollerMove moving, ScrollerMove end]);
  // TODO: inertial, bounce
  
  /** Destroys the scroller.
   * It shall be called to clean up the scroller, if it is no longer used.
   */
  void destroy();
  
  /** Returns the size of view port.
   */
  Size get viewPortSize();
  
  /** Returns the content size.
   */
  Size get contentSize();
  
  /** Returns the direction that the scrolling is allowed.
   */
  Dir get direction();
}

/**
 * The state in a scolling process, provided by [Scroller] in [ScrollerStart] and
 * [ScrollerMove] callback.
 */
interface ScrollerState default _ScrollerState {
  
  /** Returns the associated [Scroller].
   */
  Scroller get scroller();
  
  /** Returns the current scroll offset.
   */
  Offset get position();
  
  /** Returns the current scrolling velocity.
   */
  Offset get velocity();
  
  /** Returns the latest timestamp at which the scroll position is updated.
   */
  int get time();
  
}

/**
 * The controller of a virtual scroll bar which appears when scrolling.
 */
interface ScrollbarControl default _ScrollbarControl {
  
  /** Initialization of scroll bar.
   */
  void init(bool vertical);
  
  /** Destory the scroll bar.
   */
  void destroy(bool vertical);
  
  /** Called when scrolling starts.
   */
  void start(bool vertical, num position, num velocity, int time);
  
  /** Called at each scrolling iteraion.
   */
  void move(bool vertical, num position, num velocity, int time);
  
  /** Called when scrolling stops.
   */
  void end(bool vertical, num position, num velocity, int time);
  
}

class _ScrollerState implements ScrollerState {
  
  final Scroller scroller;
  final Offset startPosition;
  Offset _pos, _ppos;
  int _time, _ptime;
  
  _ScrollerState(_Scroller scroller, this._time) : 
    this.scroller = scroller,
    startPosition = new DOMQuery(scroller.owner).offset {
    _pos = startPosition;
  }
  
  Offset get position() => _pos;
  
  void snapshot(Offset pos, int time) {
    if (_time == null || time > _time) {
      _ppos = _pos;
      _ptime = _time;
      _pos = new Offset(-pos.x, -pos.y);
      _time = time;
    }
  }
  
  Offset get velocity() => _ppos == null || _pos == null || _time == null || _ptime == null ? 
      new Offset(0, 0) : ((_pos - _ppos) / (_time - _ptime));
  
  int get time() => _time;
  
}

class _ScrollbarControl implements ScrollbarControl {
  
  final Scroller scroller;
  final Element owner;
  Element _hbar, _vbar;
  
  _ScrollbarControl(this.scroller, this.owner);
  
  /* bar inner size: 4px
   * bar border: 1px
   * bar margin: 2px
   */
  static final _mgs = 2, _bds = 1, _ins = 4;
  
  void init(bool vertical) {
    if (vertical) {
      _vbar = new Element.tag("div");
      _vbar.classes = ["v-scrollbar-ver"];
      _vbar.style.width = CSS.px(_ins); // do here to have better sync
      owner.parent.insertBefore(_vbar, owner.nextElementSibling);
    } else {
      _hbar = new Element.tag("div");
      _hbar.classes = ["v-scrollbar-hor"];
      _hbar.style.height = CSS.px(_ins); // do here to have better sync
      owner.parent.insertBefore(_hbar, owner.nextElementSibling);
    }
  }
  
  void destroy(bool vertical) {
    if (vertical) {
      _vbar.remove();
      _vbar == null;
    } else {
      _hbar.remove();
      _hbar == null;
    }
  }
  
  void start(bool vertical, num position, num velocity, int time) {
    _updateBar(vertical, position);
    final Element bar = vertical ? _vbar : _hbar;
    bar.style.display = "block"; // TODO: animation + leave hook to cancel
  }
  
  void move(bool vertical, num position, num velocity, int time) {
    _updateBar(vertical, position);
  }
  
  void end(bool vertical, num position, num velocity, int time) {
    final Element bar = vertical ? _vbar : _hbar;
    bar.style.display = "none"; // TODO: animation + leave hook to skip
  }
  
  void _updateBar(bool ver, num pos) {
    final Size csize = scroller.contentSize;
    final Size vsize = scroller.viewPortSize;
    final num csize0 = ver ? csize.height : csize.width;
    final num vsize0 = ver ? vsize.height : vsize.width;
    final num s = ((vsize0 - _mgs * 2) * (csize0 > vsize0 ? vsize0 / csize0 : 1)).toInt() - _bds * 2;
    final num x = _mgs + (csize0 > vsize0 ? ((vsize0 - _mgs * 2) * pos / csize0) : 0);
    final num off = (ver ? vsize.width : vsize.height) - _mgs - _ins - _bds * 2;
    
    if (ver) {
      _vbar.style.height = CSS.px(s);
      _vbar.style.top = CSS.px(x);
      _vbar.style.left = CSS.px(off);
    } else {
      _hbar.style.width = CSS.px(s);
      _hbar.style.left = CSS.px(x);
      _hbar.style.top = CSS.px(off);
    }
  }
  
}

/**
 * A custom-scrolling handler.
 */
class _Scroller implements Scroller {
  final Element owner, handle;
  final Dir direction;
  final bool scrollbar;
  final ScrollerStart _start;
  final ScrollerMove _end, _moving;
  final AsSize _fnContentSize, _fnViewPortSize;
  
  DragGesture _dg;
  _BoundedInertialMotion _bim;
  _ScrollerState _state;
  ScrollbarControl _scrollbarCtrl;
  
  _Scroller(this.owner, this._fnViewPortSize, AsSize this._fnContentSize,
  [Element handle, Dir direction = Dir.BOTH, bool scrollbar = true, 
  ScrollerStart start, ScrollerMove moving, ScrollerMove end]) :
  this.handle = handle, this.direction = direction, this.scrollbar = scrollbar,
  _start = start, _moving = moving, _end = end {
    
    // TODO: transform
    _dg = new DragGesture(this.owner, handle: handle,
    start: (DragGestureState state) => onStart(state.time) ? owner : null,
    moving: (DragGestureState state) => onMoving(_state.startPosition + state.delta, state.time), 
    end: (DragGestureState state) {
      final Offset pos = new DOMQuery(owner).offset;
      final Rectangle range = _dragRange;
      _bim = new _BoundedInertialMotion(owner, state.velocity, range, moving: onMoving, end: onEnd);
    });
    
    // init scroll bar
    if (scrollbar) {
      _scrollbarCtrl = _scrollbarControl();
      if (_scrollbarCtrl != null)
        _applyScrollBarFunction0(_scrollbarCtrl.init);
    }
    
    //TODO: support desktop - if not in simulator, mousewheel/draggable scrollbar
  }
  
  bool onStart(int time) {
    if (_bim != null)
      _bim.stop();
    _state = new _ScrollerState(this, time);
    if (scrollbar && _scrollbarCtrl != null)
      _applyScrollBarFunction1(_scrollbarCtrl.start, _state);
    return _start == null || _start(_state);
  }
  
  void onMoving(Offset position, int time) {
    _state.snapshot(position, time);
    if (scrollbar && _scrollbarCtrl != null)
      _applyScrollBarFunction1(_scrollbarCtrl.move, _state);
    if (_moving != null)
      _moving(_state);
  }
  
  void onEnd() {
    if (_end != null)
      _end(_state);
    if (scrollbar && _scrollbarCtrl != null)
      _applyScrollBarFunction1(_scrollbarCtrl.end, _state);
    _state = null;
  }
  
  // scroll bar //
  ScrollbarControl _scrollbarControl() => new _ScrollbarControl(this, this.owner);
  
  void _applyScrollBarFunction0(Function f) {
    if (this.direction == Dir.HORIZONTAL || this.direction == Dir.BOTH)
      f(false);
    if (this.direction == Dir.VERTICAL || this.direction == Dir.BOTH)
      f(true);
  }
  
  void _applyScrollBarFunction1(Function f, ScrollerState state) {
    if (this.direction == Dir.HORIZONTAL || this.direction == Dir.BOTH)
      f(false, state.position.x, state.velocity.x, state.time);
    if (this.direction == Dir.VERTICAL || this.direction == Dir.BOTH)
      f(true, state.position.y, state.velocity.y, state.time);
  }
  
  // size cache //
  Size _contentSizeCache, _viewPortSizeCache;
  Rectangle _dragRangeCache;
  
  Rectangle get _dragRange() {
    if (_dragRangeCache == null) {
      Size vsize = viewPortSize,
          csize = contentSize;
      _dragRangeCache = new Rectangle(vsize.width - csize.width, vsize.height - csize.height, 0, 0);
    }
    return _dragRangeCache;
  }
  Size get contentSize() {
    if (_contentSizeCache == null)
      _contentSizeCache = _fnContentSize != null ? _fnContentSize() : new DOMQuery(owner).outerSize;
    return _contentSizeCache;
  }
  Size get viewPortSize() {
    if (_viewPortSizeCache == null)
      _viewPortSizeCache = _fnViewPortSize();
    return _viewPortSizeCache;
  }
  
  /**
   *
   */
  clearSizeCache() { // TODO: rename to notifySizeChange() ?
    _viewPortSizeCache = _contentSizeCache = null;
    _dragRangeCache = null;
  }
  
  void destroy() {
    _state = null;
    if (scrollbar && _scrollbarCtrl != null)
      _applyScrollBarFunction0(_scrollbarCtrl.destroy);
    _dg.destroy();
  }
  
}

class _BoundedInertialMotion extends Motion {
  
  final Element element;
  final num friction, bounce;
  final Rectangle range;
  final Function _moving, _end;
  Offset _pos, _vel;
  
  _BoundedInertialMotion(Element element, Offset velocity, this.range, 
  [num friction = 0.0005, num bounce = 1500, 
  void moving(Offset position, int time), void end()]) :
  this.element = element, this.friction = friction, this.bounce = bounce,
  _moving = moving, _end = end, 
  _pos = new DOMQuery(element).offset, _vel = velocity, super(null);
  
  bool onMoving(int time, int elapsed, int paused) {
    final num speed = VectorUtil.norm(_vel);
    final Offset dir = speed == 0 ? new Offset(0, 0) : _vel / speed;
    final Offset dec = dir * friction;
    
    _pos.x = _updatePosition(_pos.x, _vel.x, dec.x, elapsed, range.x, range.right);
    _pos.y = _updatePosition(_pos.y, _vel.y, dec.y, elapsed, range.y, range.bottom);
    
    _applyPosition(_pos);
    if (_moving != null)
      _moving(_pos, time);
    
    _vel.x = _updateVelocity(_pos.x, _vel.x, dec.x, elapsed, range.x, range.right);
    _vel.y = _updateVelocity(_pos.y, _vel.y, dec.y, elapsed, range.y, range.bottom);
    
    return !_shallStop(_pos.x, _vel.x, range.x, range.right) ||
        !_shallStop(_pos.y, _vel.y, range.y, range.bottom); 
  }
  
  void onEnd(int time, int elapsed, int paused) {
    if (_end != null)
      _end();
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
    num acc = pos < lbnd ? (lbnd - pos) / bounce :
              pos > rbnd ? (rbnd - pos) / bounce : -dec;
    num nvel = vel + acc * elap;
    if ((nvel > 0 && vel < 0) || (nvel < 0 && vel > 0)) // decelerate to 0 at most
      return 0;
    return nvel;
  }
  
  bool _shallStop(num pos, num vel, num lbnd, num rbnd) =>
    lbnd <= pos && pos <= rbnd && vel == 0;
  
  void _applyPosition(Offset pos) {
    element.style.left = CSS.px(pos.left.toInt());
    element.style.top = CSS.px(pos.top.toInt());
  }
  
}
