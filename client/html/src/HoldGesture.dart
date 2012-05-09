//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 09, 2012 12:46:09 PM
// Author: tomyeh

/** The action for the touch-and-hold gesture.
 */
typedef void HoldGestureAction();

/**
 * A touch-and-hold gesture handler.
 */
abstract class HoldGesture {
	final Element _owner;
	final int _dur;
	final int _mov;
	final HoldGestureAction _action;
	int _x, _y;
	int _timer;

	factory HoldGesture(Element owner, HoldGestureAction action, [int duration=1000, int movement=3]) {
		return browser.touch ?
			new _TouchHoldGesture(owner, action, duration, movement):
			new _MouseHoldGesture(owner, action, duration, movement);
	}
	HoldGesture._init(Element this._owner, HoldGestureAction this._action, int this._dur, int this._mov) {
		_listen();
	}

	/** Destroys the handler.
	 * It shall be called to clean up the handler, if it is no longer used.
	 */
	void destroy() {
		_unlisten();
	}

	/** The element that owns this handler.
	 */
	Element get owner() => _owner;
	/** Returns the duration that a user has to hold before calling the action ([action]).
	 */
	int get duration() => _dur;
	/** Returns the allowed movement to consider if a user is holding a touch.
	 * In other words, if the user moves more than the movement, it won't consider a hold.
	 */
	int get movement() => _mov;
	/** Returns the action to call when the touch-and-hold gesture is detected.
	 */
	HoldGestureAction get action() => _action;

	abstract void _listen();
	abstract void _unlisten();

	void _touchStart(int x, int y) {
		_x = x; _y = y;
		_clear();
		_timer = window.setTimeout(_call, duration);
	}
	void _touchMove(int x, int y) {
		if (x - _x > movement || y - _y > movement)
			_clear();
	}
	void _touchEnd() {
		_clear();
	}
	void _call() {
		_clear();
		action();
	}
	void _clear() {
		if (_timer !== null) {
			window.clearTimeout(_timer);
			_timer = null;
		}
	}
}

/** The touch-and-hold handler for touch devices.
 */
class _TouchHoldGesture extends HoldGesture {
	EventListener _elStart, _elMove, _elEnd;

	_TouchHoldGesture(Element owner, HoldGestureAction action, int duration, int movement)
	: super._init(owner, action, duration, movement) {
	}

	void _listen() {
		final ElementEvents on = owner.on;
		on.touchStart.add(_elStart = (TouchEvent event) {
			if (event.touches.length > 1)
				_touchEnd(); //ignore multiple fingers
			else
				_touchStart(event.pageX, event.pageY);
		});
		on.touchMove.add(_elMove = (TouchEvent event) {
			_touchMove(event.pageX, event.pageY);
		});
		on.touchEnd.add(_elEnd = (event) {
			_touchEnd();
		});
	}
	void _unlisten() {
		final ElementEvents on = owner.on;
		if (_elStart !== null) on.touchStart.remove(_elStart);
		if (_elMove !== null) on.touchMove.remove(_elMove);
		if (_elEnd !== null) on.touchEnd.remove(_elEnd);
	}
}
/** The touch-and-hold handler for mouse-based devices.
 */
class _MouseHoldGesture extends HoldGesture {
  EventListener _elStart, _elMove, _elEnd;
  bool _down = false;

  _MouseHoldGesture(Element owner, HoldGestureAction action, int duration, int movement)
	: super._init(owner, action, duration, movement) {
	}

	void _listen() {
		final ElementEvents on = owner.on;
		on.mouseDown.add(_elStart = (MouseEvent event) {
			_down = true;
			_touchStart(event.pageX, event.pageY);
		});
		on.mouseMove.add(_elMove = (MouseEvent event) {
			if (_down)
				_touchMove(event.pageX, event.pageY);
		});
		on.mouseUp.add(_elEnd = (event) {
			_down = false;
			_touchEnd();
		});
	}
	void _unlisten() {
		final ElementEvents on = owner.on;
		if (_elStart !== null) on.touchStart.remove(_elStart);
		if (_elMove !== null) on.touchMove.remove(_elMove);
		if (_elEnd !== null) on.touchEnd.remove(_elEnd);
	}
}