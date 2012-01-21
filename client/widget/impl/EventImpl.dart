/* EventImpl.dart

	Event utilities for implementation.
	It is included by ../Widget.dart

	History:
		Tue Jan 17 17:03:33 TST 2012, Created by tomyeh

Copyright (C) 2012 Potix Corporation. All Rights Reserved.
*/

/**
 * An implementation of [Events].
 */
class _EventsImpl implements Events {
	//raw event target
	final _ptr;
	Map<String, EventListenerList> _listeners;

	_EventsImpl(this._ptr) {
		_listeners = {};
	}
	EventListenerList operator [](String type) {
		return _listeners.putIfAbsent(type,
			() => new _EventListenerListImpl(_ptr, type));
	}
	noSuchMethod(String name, List args) {
		if (name.startsWith("get:"))
			return this[name.substring(4)];
	super.noSuchMethod(name, args);
	}
	/** Tests if the given event type is listened.
	 */
	bool isListened(String type) {
		final p = _listeners[type];
		return p == null || p.isEmpty();
	}
}

/** An implementation of [EventListenerList].
 */
class _EventListenerListImpl implements EventListenerList {
	final _ptr;
	final String _type;

	_EventListenerListImpl(this._ptr, this._type);

	EventListenerList add(void listener(Event event), [bool useCapture = false]) {
		_ptr.addEventListener(_type, listener, useCapture);
		return this;
	}
	bool dispatch(Event event) {
		return _ptr.dispatchEvent(_type, event);
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
