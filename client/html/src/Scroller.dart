//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 03, 2012  1:06:33 PM
// Author: tomyeh

/**
 * The callback when [Scroller] tries to start the scrolling.
 * If it returns false, the scroller won't be activated (i.e., ignored).
 *
 * [ofsX] and [ofsY] provide the touch point's offset relative to
 * the left-top corner of the owner element (right before scrolling).
 */
typedef bool ScrollerStart(Scroller scroller, int ofsX, int ofsY);
/** The callback that [Scroller] uses to indicate the user is scrolling,
 * or the user ends the scrolling (i.e., releases the finger).
 *
 * [ofsX] and [ofsY] provide the touch point's offset relative to
 * the left-top corner of the owner element (right before scrolling).
 *
 * [deltaX] and [deltaY] provide the number of pixels
 * that a user has scrolled (since `start` was called).
 */
typedef void ScrollerMove(Scroller scroller,
  int ofsX, int ofsY, int deltaX, int deltaY);

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
  /** The element that the scrolling starts with, or null if the scrolling
   * is not started.
   */
  Element get touched();

  /** Returns the direction that the scrolling is allowed.
   */
  Dir get dir();
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
  Size _totalSize; //cached size
  Element _touched;
  Offset _ownerOfs, _initPgOfs, _initTxOfs;

  factory _Scroller(Element owner, [Dir dir, AsSize totalSize, AsSize viewSize,
    ScrollerStart start, ScrollerMove end, ScrollerMove moving]) {
    if (dir === null) dir = Dir.BOTH;
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
  Element get touched() => _touched;
  Dir get dir() => _dir;

  abstract void _listen();
  abstract void _unlisten();

  void _stop() {
    _touched = null;
    _totalSize = null; //force recalculation
  }
  bool _touchStart(Element touched, int pageX, int pageY) {
    _stop();

    _touched = touched;
    _ownerOfs = new DOMQuery(owner).documentOffset;
    if (_start !== null) {
      bool c = _start(this, pageX - _ownerOfs.x, pageY - _ownerOfs.y);
      if (c !== null && !c) {
        _touched = null; //not started
        return false; //don't start it
      }
    }

    _initTxOfs = CSS.offset3dOf(owner.style.transform);
    _initPgOfs = new Offset(pageX, pageY);
    return true;
  }
  void _touchMove(int pageX, int pageY) {
    if (_touched !== null) {
      _moveBy(pageX - _ownerOfs.x, pageY - _ownerOfs.y,
        pageX - _initPgOfs.x, pageY - _initPgOfs.y, _moving); 
    }
  }
  void _touchEnd(int pageX, int pageY) {
    if (_touched !== null) {
      _moveBy(pageX - _ownerOfs.x, pageY - _ownerOfs.y,
        pageX - _initPgOfs.x, pageY - _initPgOfs.y, _end); 
      _stop();
    }
  }
  void _moveBy(int ofsX, int ofsY, int deltaX, int deltaY,
    ScrollerMove callback) {
    final Offset move = _constraint(deltaX + _initTxOfs.x, deltaY + _initTxOfs.y);
    _owner.style.transform = CSS.translate3d(move.x, move.y);

    if (callback !== null)
      callback(this, ofsX, ofsY, deltaX, deltaY);
  }
  Offset _constraint(int x, int y) {
    if (_totalSize === null)
      _totalSize = _fnTotalSize();

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
      final int right = viewSize.width - _totalSize.width;
      if (right >= 0) x = 0;
      else if (x < right) x = right;
    }
    if (dir == Dir.HORIZONTAL || y >= 0) {
      y = 0;
    } else {
      final int bottom = viewSize.height - _totalSize.height;
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
