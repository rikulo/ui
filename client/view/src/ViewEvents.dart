//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 17, 2012

/** A map of event handlers for [View].
 */
interface ViewEvents extends Events default _ViewEvents {
	ViewEvents(var ptr);

	EventListenerList get blur();
	EventListenerList get change();
	EventListenerList get click();
	EventListenerList get focus();
	EventListenerList get keyDown();
	EventListenerList get keyPress();
	EventListenerList get keyUp();
	EventListenerList get mouseDown();
	EventListenerList get mouseMove();
	EventListenerList get mouseOut();
	EventListenerList get mouseOver();
	EventListenerList get mouseUp();
	EventListenerList get mouseWheel();
	EventListenerList get scroll();
}

/**
 * An implementation of [ViewEvents].
 */
class _ViewEvents implements ViewEvents {
	//raw event target
	final _ptr;
	Map<String, EventListenerList> _listeners;

	_ViewEvents(this._ptr) {
		_listeners = {};
	}
	EventListenerList operator [](String type) => _get(type); 
  _EventListenerList _get(String type) {
		return _listeners.putIfAbsent(type,
			() => new _EventListenerList(_ptr, type));
	}

	EventListenerList get blur() => _get('blur');
	EventListenerList get change() => _get('change');
	EventListenerList get click() => _get('click');
	EventListenerList get focus() => _get('focus');
	EventListenerList get keyDown() => _get('keyDown');
	EventListenerList get keyPress() => _get('keyPress');
	EventListenerList get keyUp() => _get('keyUp');
	EventListenerList get mouseDown() => _get('mouseDown');
	EventListenerList get mouseMove() => _get('mouseMove');
	EventListenerList get mouseOut() => _get('mouseOut');
	EventListenerList get mouseOver() => _get('mouseOver');
	EventListenerList get mouseUp() => _get('mouseUp');
	EventListenerList get mouseWheel() => _get('mouseWheel');
	EventListenerList get scroll() => _get('scroll');

	/** Tests if the given event type is listened.
	 */
	bool isListened(String type) {
		final p = _listeners[type];
		return p == null || p.isEmpty();
	}
}

/** An implementation of [EventListenerList].
 */
class _EventListenerList implements EventListenerList {
	final _ptr;
	final String _type;

	_EventListenerList(this._ptr, this._type);

	EventListenerList add(void listener(Event event), [bool useCapture = false]) {
		_ptr.addEventListener(_type, listener, useCapture);
		return this;
	}
	bool dispatch(Event event) {
		return _ptr.dispatchEvent(event, type: _type);
	}
	EventListenerList remove(void listener(Event event), [bool useCapture = false]) {
		_ptr.removeEventListener(_type, listener, useCapture);
		return this;
	}
	/** Tests if any listener is registered.
	 */
	bool isEmpty() {
		return _ptr.isEventListened(_type);
	}
}
