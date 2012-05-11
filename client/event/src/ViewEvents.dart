//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 17, 2012

/** A map of event listeners for [View].
 */
interface ViewEvents extends Events default _ViewEvents {
	ViewEvents(var ptr);

	/** Tests if the given event type is listened.
	 */
	bool isListened(String type);

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

	EventListenerList get check();

	EventListenerList get layout();
	EventListenerList get enterDocument();
	EventListenerList get exitDocument();
}

/** An implementation of [Events].
 */
class _Events implements Events {
	//raw event target
	final _ptr;
	final Map<String, EventListenerList> _lnlist;

	_Events(this._ptr): _lnlist = new Map() {
	}

	EventListenerList operator [](String type) => _get(type); 
  _EventListenerList _get(String type) {
		return _lnlist.putIfAbsent(type, () => new _EventListenerList(_ptr, type));
	}

	bool isListened(String type) {
		final p = _lnlist[type];
		return p == null || p.isEmpty();
	}
}

/** An implementation of [ViewEvents].
 */
class _ViewEvents extends _Events implements ViewEvents {
	_ViewEvents(var ptr): super(ptr) {
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

	EventListenerList get layout() => _get("layout");
	EventListenerList get enterDocument() => _get("enterDocument");
	EventListenerList get exitDocument() => _get("exitDocument");

	EventListenerList get check() => _get("check");
}

/** An implementation of [EventListenerList].
 */
class _EventListenerList implements EventListenerList {
	final _ptr;
	final String _type;

	_EventListenerList(this._ptr, this._type);

	EventListenerList add(void listener(Event event), [bool useCapture]) {
		_ptr.addEventListener(_type, listener);
		return this;
	}
	bool dispatch(Event event) {
		return _ptr.sendEvent(event, type: _type);
	}
	EventListenerList remove(void listener(Event event), [bool useCapture]) {
		_ptr.removeEventListener(_type, listener);
		return this;
	}
	/** Tests if any listener is registered.
	 */
	bool isEmpty() {
		return _ptr.isEventListened(_type);
	}
}
