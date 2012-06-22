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

/** The state of scroller.
 */
interface ScrollerState extends MovementState {
  Scroller get scroller();

  /** Returns the total size that can be scrolled.
   */
  Size get totalSize();
}

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
  Scroller(Element owner, [Dir dir, AsSize totalSize, AsSize viewSize,
  ScrollerStart start, ScrollerMove end, ScrollerMove moving]);

  /** Destroys the scroller.
   * It shall be called to clean up the scroller, if it is no longer used.
   */
  void destroy();

  /** The element that owns this scroller.
   */
  Element get owner();

  /** Returns the direction that the scrolling is allowed.
   */
  Dir get dir();
}

class _ScrollerState implements ScrollerState {
  final _Scroller _scroller;
  final Element _touched;
  final Offset _ownerOfs, _initPgOfs, _delta;
  Offset _ofs, _initTxOfs;
  Size _totalSize; //cached size
  var data;
  bool _moved = false;

  _ScrollerState(_Scroller scroller, Element this._touched, int pageX, int pageY):
  _scroller = scroller, _delta = new Offset(0, 0),
  _initPgOfs = new Offset(pageX, pageY),
  _ownerOfs = new DOMQuery(scroller.owner).documentOffset {
    _ofs = _initPgOfs - _ownerOfs;
  }

  Scroller get scroller() => _scroller;
  Offset get offset() => _ofs;
  Offset get delta() => _delta;
  Element get touched() => _touched;
  bool get moved() => _moved;

  Size get totalSize() {
    if (_totalSize === null)
      _totalSize = _scroller._fnTotalSize();
    return _totalSize;
  }
  void _setOfs(int x, int y) {
    _ofs.x = x;
    _ofs.y = y;
  }
  void _setDelta(int x, int y) {
    _delta.x = x;
    _delta.y = y;
  }
}

/**
 * A custom-scrolling handler.
 */
abstract class _Scroller implements Scroller {
  final Element _owner;
  final Dir _dir;
  final ScrollerStart _start;
  final ScrollerMove _end, _moving;
  final AsSize _fnTotalSize, _fnViewSize;
  _ScrollerState _state;

  factory _Scroller(Element owner, [Dir dir=Dir.BOTH,
    AsSize totalSize, AsSize viewSize,
    ScrollerStart start, ScrollerMove end, ScrollerMove moving]) {
    return browser.touch ?
      new _TouchScroller(owner, dir, totalSize, viewSize, start, end, moving):
      new _MouseScroller(owner, dir, totalSize, viewSize, start, end, moving);
      //TODO: support desktop - if not in simulator, mousewheel/draggable scrollbar
  }
  _Scroller._init(Element this._owner, Dir this._dir,
    AsSize this._fnTotalSize, AsSize this._fnViewSize,
    ScrollerStart this._start, ScrollerMove this._end,
    ScrollerMove this._moving) {
    _listen();
  }

  void destroy() {
    _stop();
    _unlisten();
  }

  Element get owner() => _owner;
  Dir get dir() => _dir;

  abstract void _listen();
  abstract void _unlisten();

  void _stop() {
    _state = null;
  }
  bool _touchStart(Element touched, int pageX, int pageY) {
    _stop();

    _state = new _ScrollerState(this, touched, pageX, pageY);
    if (_start !== null) {
      final bool c = _start(_state);
      if (c !== null && !c) {
        _stop();
        return false;
      }
    }

    _state._initTxOfs = CSS.offset3dOf(owner.style.transform);
    return true;
  }
  void _touchMove(int pageX, int pageY) {
    if (_state !== null) {
      _moveBy(pageX - _state._ownerOfs.x, pageY - _state._ownerOfs.y,
        pageX - _state._initPgOfs.x, pageY - _state._initPgOfs.y, _moving); 
    }
  }
  void _touchEnd(int pageX, int pageY) {
    if (_state !== null) {
      _moveBy(pageX - _state._ownerOfs.x, pageY - _state._ownerOfs.y,
        pageX - _state._initPgOfs.x, pageY - _state._initPgOfs.y, _end); 
      _stop();
    }
  }
  void _moveBy(int ofsX, int ofsY, int deltaX, int deltaY,
    ScrollerMove callback) {
    final Offset initofs = _state._initTxOfs,
      move = _constraint(deltaX + initofs.x, deltaY + initofs.y);

    if (callback !== null) {
      _state._setOfs(ofsX, ofsY);
      _state._setDelta(move.x - initofs.x, move.y - initofs.y);
      _state._moved = _state._moved || deltaX != 0 || deltaY != 0;
      callback(_state);
    }

    _owner.style.transform = CSS.translate3d(move.x, move.y);
  }
  Offset _constraint(int x, int y) {
    Size viewSize;
    if (_fnViewSize !== null) {
      viewSize = _fnViewSize();
    } else {
      final DOMQuery q = new DOMQuery(_owner);
      viewSize = new Size(q.outerWidth, q.outerHeight);
    }

    if (dir == Dir.VERTICAL || x >= 0) {
      x = 0;
    } else {
      final int right = viewSize.width - _state.totalSize.width;
      if (right >= 0) x = 0;
      else if (x < right) x = right;
    }
    if (dir == Dir.HORIZONTAL || y >= 0) {
      y = 0;
    } else {
      final int bottom = viewSize.height - _state.totalSize.height;
      if (bottom >= 0) y = 0;
      else if (y < bottom) y = bottom;
    }
    return new Offset(x, y);
  }
}

/** The scroller for touch devices.
 */
class _TouchScroller extends _Scroller {
  EventListener _elStart, _elMove, _elEnd;

  _TouchScroller(Element owner, Dir dir, AsSize totalSize, AsSize viewSize,
  ScrollerStart start, ScrollerMove end, ScrollerMove moving)
  : super._init(owner, dir, totalSize, viewSize, start, end, moving);

  void _listen() {
    final ElementEvents on = owner.on;
    on.touchStart.add(_elStart = (TouchEvent event) {
      if (event.touches.length > 1)
        _touchEnd(event.pageX, event.pageY); //ignore multiple fingers
      else
        _touchStart(event.target, event.pageX, event.pageY);
    });
    on.touchMove.add(_elMove = (TouchEvent event) {
      _touchMove(event.pageX, event.pageY);
    });
    on.touchEnd.add(_elEnd = (TouchEvent event) {
      _touchEnd(event.pageX, event.pageY);
    });
  }
  void _unlisten() {
    final ElementEvents on = owner.on;
    if (_elStart !== null) on.touchStart.remove(_elStart);
    if (_elMove !== null) on.touchMove.remove(_elMove);
    if (_elEnd !== null) on.touchEnd.remove(_elEnd);
  }
}

/** The scroller for mouse-based devices.
 */
class _MouseScroller extends _Scroller {
  EventListener _elStart, _elMove, _elEnd;
  bool _captured = false;

  _MouseScroller(Element owner, Dir dir, AsSize totalSize, AsSize viewSize,
  ScrollerStart start, ScrollerMove end, ScrollerMove moving)
  : super._init(owner, dir, totalSize, viewSize, start, end, moving);

  //@Override
  void _stop() {
    if (_captured) {
      _captured = false;
      final ElementEvents on = document.on;
      if (_elMove !== null)
        on.mouseMove.remove(_elMove);
      if (_elEnd !== null)
        on.mouseUp.remove(_elEnd);
    }
    super._stop();
  }
  void _capture() {
    _captured = true;
    final ElementEvents on = document.on;
    on.mouseMove.add(_elMove = (MouseEvent event) {
      _touchMove(event.pageX, event.pageY);
    });
    on.mouseUp.add(_elEnd = (MouseEvent event) {
      _touchEnd(event.pageX, event.pageY);
    });
  }
  void _listen() {
    owner.on.mouseDown.add(_elStart = (MouseEvent event) {
      if (_touchStart(event.target, event.pageX, event.pageY))
        _capture();
    });
  }
  void _unlisten() {
    if (_elStart !== null)
      owner.on.mouseDown.remove(_elStart);
  }
}
