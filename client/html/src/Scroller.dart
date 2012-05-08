//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 03, 2012  1:06:33 PM
// Author: tomyeh

/**
 * A custom-scrolling handler.
 */
interface Scroller default _ScrollerImpl {
	Scroller(Element node, Dir dir);

	/** Destroys the scroller.
	 * It shall be called to clean up the scroller, if it is no longer used.
	 */
	void destroy();

	/** The element that owns this scroller.
	 */
	Element get owner();
}

abstract class _ScrollerImpl implements Scroller {
	factory _ScrollerImpl(Element node, Dir dir) {
		return new _Tx3dScroller(node, dir);
		//FUTURE: to support non-touch browser, we can introduce factory
		//to use _owner.parent.style.overflow = "auto";
		//Or, make the scrollbar visible when mouseover
	}
}

/** An implementation of [Scroller] that is based on CSS transform:translate3d.
 */
class _Tx3dScroller implements _ScrollerImpl {
	final Element _owner;
	Dir _dir;
	EventListener _touchStart, _touchMove, _touchEnd;

	_Tx3dScroller(Element this._owner, Dir this._dir) {
		_initListeners();
		_listen();
	}

	Element get owner() => _owner;

	void destroy() {
		_unlisten();
	}

	void _initListeners() {
		if (browser.touch) {
			_touchStart = (TouchEvent event) {
				event.preventDefault();
			};
			_touchMove = (TouchEvent event) {
				event.preventDefault();
			};
			_touchEnd = (TouchEvent event) {
				event.preventDefault();
			};
		} else {
		}
	}
	void _listen() {
		final Events on = _owner.on;
		if (browser.touch) {
			on.touchStart.add(_touchStart);
			on.touchMove.add(_touchMove);
			on.touchEnd.add(_touchEnd);
		} else {
		}
	}
	void _unlisten() {
		final Events on = _owner.on;
		if (browser.touch) {
			on.touchStart.add(_touchStart);
			on.touchMove.add(_touchMove);
			on.touchEnd.add(_touchEnd);
		} else {
		}
	}
}
