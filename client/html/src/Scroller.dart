//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 03, 2012  1:06:33 PM
// Author: tomyeh

/** The scroller callback.
 *
 * Notice that for [start], [delaX] and [deltaY] are actually pageX and pageY
 * (offset to document's origin).
 * On the hand, it is the number of pixels that a user has scrolled for
 * [scrollTo] and [scrolling] (that is why it is called deltaX and deltaY).
 */
typedef ScrollerCallback(Element touched, int deltaX, int deltaY);

/**
 * A custom-scrolling handler.
 */
abstract class Scroller {
  final Element _owner;
  final Dir _dir;
  final ScrollerCallback _start, _scrollTo, _scrolling;
  final AsSize _fnTotalSize, _fnViewSize;
  Size _totalSize; //cached size
  Element _touched;
  int _pageX, _pageY;
  Offset3d _initOfs;

  /** Constructor.
   *
   * + [start] is the callback before starting scrolling.
   * If it returns false, the scrolling won't be activated.
   */
  factory Scroller(Element owner, [Dir dir=Dir.BOTH,
  AsSize totalSize, AsSize viewSize,
  ScrollerCallback start, ScrollerCallback scrollTo, ScrollerCallback scrolling]) {
    return browser.touch ?
      new _TouchScroller(owner, dir, totalSize, viewSize, start, scrollTo, scrolling):
      new _MouseScroller(owner, dir, totalSize, viewSize, start, scrollTo, scrolling);
      //TODO: support desktop - if not in simulator, mousewheel/draggable scrollbar
  }
  Scroller._init(Element this._owner, Dir this._dir,
  AsSize this._fnTotalSize, AsSize this._fnViewSize,
  ScrollerCallback this._start, ScrollerCallback this._scrollTo,
  ScrollerCallback this._scrolling) {
    _listen();
  }

  /** Destroys the scroller.
   * It shall be called to clean up the scroller, if it is no longer used.
   */
  void destroy() {
    _stop();
    _unlisten();
  }

  /** The element that owns this scroller.
   */
  Element get owner() => _owner;
  /** Returns the direction that the scrolling is allowed.
   */
  Dir get dir() => _dir;

  /** Returns the callback to call when the user starts scrolling,
   * or null if not specified.
   */
  ScrollerCallback get start() => _start;
  /** Returns the callback that will be called when the scrolling is ended,
   * or null if not specified.
   */
  ScrollerCallback get scrollTo() => _scrollTo;
  /** Returns the callback that will be called when the user is scrolling
   * the content, or null if not specified.
   */
  ScrollerCallback get scrolling() => _scrolling;

  abstract void _listen();
  abstract void _unlisten();

  void _stop() {
    _touched = null;
  }
  bool _touchStart(Element touched, int pageX, int pageY) {
    _stop();

    if (_start !== null) {
      bool c = _start(touched, pageX, pageY); //not deltaX/deltaY
      if (c !== null && !c)
        return false; //don't start it
    }

    _initOfs = CSS.offset3dOf(owner.style.transform);
    _pageX = pageX;
    _pageY = pageY;
    _touched = touched;
    return true;
  }
  void _touchMove(int pageX, int pageY) {
    if (_touched !== null) {
      _moveBy(pageX - _pageX, pageY - _pageY, _scrolling); 
    }
  }
  void _touchEnd(int pageX, int pageY) {
    if (_touched !== null) {
      _moveBy(pageX - _pageX, pageY - _pageY, _scrollTo); 
      _stop();
    }
  }
  void _moveBy(int deltaX, int deltaY, [ScrollerCallback callback]) {
    final Offset move = _constraint(deltaX + _initOfs.x, deltaY + _initOfs.y);
    _owner.style.transform = CSS.translate3d(move.x, move.y);

    if (callback !== null)
      callback(_touched, move.x, move.y);
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

    if (x >= 0) {
      x = 0;
    } else {
      final int right = viewSize.width - _totalSize.width;
      if (right >= 0) x = 0;
      else if (x < right) x = right;
    }
    if (y >= 0) {
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
class _TouchScroller extends Scroller {
  EventListener _elStart, _elMove, _elEnd;

  _TouchScroller(Element owner, Dir dir, AsSize totalSize, AsSize viewSize,
  ScrollerCallback start, ScrollerCallback scrollTo, ScrollerCallback scrolling)
  : super._init(owner, dir, totalSize, viewSize, start, scrollTo, scrolling) {
  }

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
class _MouseScroller extends Scroller {
  EventListener _elStart, _elMove, _elEnd;
  bool _captured = false;

  _MouseScroller(Element owner, Dir dir, AsSize totalSize, AsSize viewSize,
  ScrollerCallback start, ScrollerCallback scrollTo, ScrollerCallback scrolling)
  : super._init(owner, dir, totalSize, viewSize, start, scrollTo, scrolling) {
  }

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
    //TO capture, we have to register to document
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
