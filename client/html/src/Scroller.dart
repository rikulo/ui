//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 03, 2012  1:06:33 PM
// Author: tomyeh

/** The scroller callback.
 * <p>Notice that for [start], [delaX] and [deltaY] are actually pageX and pageY
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
	Element _touched;
	int _pageX, _pageY;

	/** Constructor.
	 * <p>[start] is the callback before starting scrolling.
	 * If it returns false, the scrolling won't be activated.
	 */
	factory Scroller(Element owner, [Dir dir=Dir.BOTH, ScrollerCallback start,
	ScrollerCallback scrollTo, ScrollerCallback scrolling]) {
		return browser.touch ?
			new _TouchScroller(owner, dir, start, scrollTo, scrolling):
			new _MouseScroller(owner, dir, start, scrollTo, scrolling);
	}
	Scroller._init(Element this._owner, Dir this._dir, ScrollerCallback this._start,
	ScrollerCallback this._scrollTo, ScrollerCallback this._scrolling) {
		_listen();
	}

	/** Destroys the scroller.
	 * It shall be called to clean up the scroller, if it is no longer used.
	 */
	void destroy() {
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

		_pageX = pageX;
		_pageY = pageY;
		_touched = touched;
		return true;
	}
	void _touchMove(int pageX, int pageY) {
		if (_touched !== null) {
			final int
				deltaX = pageX - _pageX,
				deltaY = pageY - _pageY;
			_owner.style.transform = CSS.translate3d(deltaX, deltaY);

			if (_scrolling !== null)
				_scrolling(_touched, deltaX, deltaY);
		}
	}
	void _touchEnd(int pageX, int pageY) {
		if (_touched !== null) {
			final int
				deltaX = pageX - _pageX,
				deltaY = pageY - _pageY;
			_owner.style.transform = CSS.translate3d(deltaX, deltaY);

			if (_scrollTo !== null)
				_scrollTo(_touched, deltaX, deltaY);

			_stop();
		}
	}
}

/** The scroller for touch devices.
 */
class _TouchScroller extends Scroller {
  EventListener _elStart, _elMove, _elEnd;

	_TouchScroller(Element owner, Dir dir, ScrollerCallback start,
	ScrollerCallback scrollTo, ScrollerCallback scrolling)
	: super._init(owner, dir, start, scrollTo, scrolling) {
	}

	void _listen() {
	}
	void _unlisten() {
	}
}

/** The scroller for mouse-based devices.
 */
class _MouseScroller extends Scroller {
  EventListener _elStart, _elMove, _elEnd;

	_MouseScroller(Element owner, Dir dir, ScrollerCallback start,
	ScrollerCallback scrollTo, ScrollerCallback scrolling)
	: super._init(owner, dir, start, scrollTo, scrolling) {
	}

	void _listen() {
		final ElementEvents on = owner.on;
		on.mouseDown.add(_elStart = (MouseEvent event) {
			_touchStart(event.target, event.pageX, event.pageY);
		});
		on.mouseMove.add(_elMove = (MouseEvent event) {
			_touchMove(event.pageX, event.pageY);
		});
		on.mouseUp.add(_elEnd = (event) {
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
