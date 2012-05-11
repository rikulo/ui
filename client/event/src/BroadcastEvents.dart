//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 10, 2012 12:24:23 PM
// Author: tomyeh

/**
 * A map of event listeners for handling the broadcasted events.
 */
interface BroadcastEvents extends Events default _BroadcastEvents {
	BroadcastEvents(var ptr);

	/** Tests if the given event type is listened.
	 */
	bool isListened(String type);

	/** Listeners for the popup event ([PopupEvent]).
	 */
	EventListenerList get popup();
}

/** An implementation of [BroadcastEvents].
 */
class _BroadcastEvents extends _Events implements BroadcastEvents {
	_BroadcastEvents(var ptr): super(ptr) {
	}

	EventListenerList get popup() => _get('popup');
}
