//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 10, 2012 12:16:20 PM
// Author: tomyeh

/**
 * The broadcaster used to broadcast events.
 */
interface Broadcaster {
	/** Returns [BroadcastEvents] for adding or removing event listeners.
	 */
	BroadcastEvents get on();
	/** Broadcasts an event to all registered listeners.
	 */
	bool sendEvent(ViewEvent event, [String type]);
	/** Posts an event to all registered listeners.
	 * Unlike [sendEvent], [postEvent] puts the event in a queue and returns
	 * immediately. The event will be handled later.
	 */
	void postEvent(ViewEvent event, [String type]);
}
/** The broadcaster used to broadcast events.
 */
Broadcaster get broadcaster() {
	if (_cachedBroadcaster === null)
		_cachedBroadcaster = new _Broadcaster();
	return _cachedBroadcaster;
}
Broadcaster _cachedBroadcaster;

/** An implementation of [Broadcaster].
 */
class _Broadcaster implements Broadcaster {
	_BroadcastListeners _listeners;
	BroadcastEvents _on;

	_Broadcaster() {
		_listeners = new _BroadcastListeners(this);
		_on = new BroadcastEvents(_listeners);
	}

	BroadcastEvents get on() => _on;

	bool sendEvent(ViewEvent event, [String type])
	=> _listeners.sendEvent(event, type);
	void postEvent(ViewEvent event, [String type]) {
		window.setTimeout(() {sendEvent(event, type);}, 0);
			//note: the order of messages is preserved across all views (and message queues)
			//CONSIDER if it is better to have a queue shared by views/message queues/broadcaster
	}
}
class _BroadcastListeners {
	final Broadcaster _owner;
	final Map<String, List<ViewEventListener>> _listeners;

	_BroadcastListeners(Broadcaster this._owner): _listeners = new Map() {
	}

	void addEventListener(String type, ViewEventListener listener) {
		if (listener == null)
			throw const UIException("listener required");

		_listeners.putIfAbsent(type, () => []).add(listener);
	}

	/** Removes an event listener.
	 * <code>addEventListener("click", listener)</code> is the same as
	 * <code>on.click.remove(listener)</code>.
	 */
	bool removeEventListener(String type, ViewEventListener listener) {
		List<ViewEventListener> ls;
		bool found = false;
		if ((ls = _listeners[type]) != null) {
			int j = ls.indexOf(listener);
			Element n;
			if (j >= 0) {
				found = true;
				ls.removeRange(j, 1);
			}
		}
		return found;
	}
	/** Sends an event to this view.
	 * <p>Example: <code>view.sendEvent(new PopupEvent(view))</code>.
	 * If the type parameter is not specified, it is assumed to be [ViewEvent.type].
	 */
	bool sendEvent(ViewEvent event, [String type]) {
		if (type == null)
			type = event.type;

		List<ViewEventListener> ls;
		bool dispatched = false;
		if ((ls = _listeners[type]) != null) {
			for (final ViewEventListener listener in new List.from(ls)) { //we have to make a copy since the listener might change it
				dispatched = true;
				listener(event);
				if (event.propagationStopped)
					return true; //done
			}
		}
		return dispatched;
	}
}