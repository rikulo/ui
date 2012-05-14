/* ViewEvent.dart

	History:
		Fri Jan 20 14:42:46 TST 2012, Created by tomyeh

Copyright (C) 2012 Potix Corporation. All Rights Reserved.
*/

/** A listener for handling [ViewEvent].
 */
typedef void ViewEventListener(ViewEvent event);

/**
 * A view event.
 * The event received by [View]'s event listener must be an instance of this class.
 */
class ViewEvent {
	View _target;
	final Event _domEvt;
	final String _type;
	final int _stamp;
	bool _propStop = false;

	ViewEvent(View target, String type):
	_domEvt = null, _type = type, _stamp = new Date.now().value {
		if (type == null)
			throw const UIException("type required");
		_target = currentTarget = target;
	}
	/** Constructs a view event from a DOM event.
	 * It is rarely called unless you'd like to wrap a DOM event.
	 */
	ViewEvent.dom(View target, Event domEvent, [String type]) : 
	_domEvt = domEvent, _type = type != null ? type: domEvent.type,
	_stamp = domEvent.timeStamp {
		_target = currentTarget = target;
	}

	/** Returns the view that this event is targeting  to.
	 */
	View get target() => _target;
	/** The view that is handling this event currently.
	 */
	View currentTarget;

	/** The DOM event that causes this view event, or null if not available.
	 */
	Event get domEvent() => _domEvt;

	/** Returns the time stamp. */
	int get timeStamp() => _stamp;
	/** Returns the event's type. */
	String get type() => _type;

	/** Returns whether this event's propagation is stopped.
	 * <p>Default: false.
	 * <p>It becomes true if {@link #stopPropagation} is called,
	 * and then all remaining event listeners are ignored.
	 */
	bool get propagationStopped() => _propStop;
	/** Stops the propagation.
	 *Once called, all remaining event listeners, if any, are ignored.
	 */
	void stopPropagation() {
		_propStop = true;
	}
}
