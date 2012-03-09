/* ViewEvent.dart

	History:
		Fri Jan 20 14:42:46 TST 2012, Created by tomyeh

Copyright (C) 2012 Potix Corporation. All Rights Reserved.
*/

/**
 * A view event.
 * The event received by [View]'s event listener must be an instance of this class.
 */
class ViewEvent<Data> implements Event {
	View _target;
	Event _domEvt;
	View _curTarget;
	String _type;
	Data _data;
	int _stamp;
	bool _defPrevt = false, _propStop = true;

	ViewEvent(View target, [Event domEvent, String type, Data data]) {
		_target = _curTarget = target;
		_domEvt = domEvent;
		_stamp = domEvent != null ? domEvent.timeStamp: 0; //TODO
		_type = type != null ? type: _domEvt.type;
		_data = data;
	}

	EventTarget get target() => _target;
	EventTarget get currentTarget() => _curTarget;
	void set currentTarget(View target) {
		_curTarget = target;
	}
	EventTarget get srcElement() => _domEvt != null ? _domEvt.srcElement: null;

	/** Returns the data, or null if not available
	 */
	Data get data() => _data;

	/** The DOM event that causes this view event, or null if not available.
	 */
	Event get domEvent() => _domEvt;

	/** Returns the time stamp. */
	int get timeStamp() => _stamp;
	/** Returns the event's type. */
	String get type() => _type;

	/** Returns whether to prevent the default behavior from taking place.
	 * The default behavior and the prevention depend on the view.
	 */
	bool get defaultPrevented() => _defPrevt;
	/** Prevent the default behavior from taking place.
	 * <p>Notice that it doesn't invoke [domEvent]'s preventDefault().
	 * If you'd like to prevent browser's default behavior, you have to invoke
	 * [domEvent]'s preventDefault() explicitly.
	 */
	void preventDefault() {
		_defPrevt = true;
	}
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

	/** Useless; always true. */
	bool get bubbles() => true;
	/** Useless; always true. */
	bool get cancelable() => true;
	/** Useless; always true. */
	bool get cancelBubble() => true;
	/** Useless; does nothing. */
	void set cancelBubble(bool value) {
	}
	/** Useless; always 0. */
	int get eventPhase() => 0;
	/** Useless; always false. */
	bool get returnValue() => false;
	/** Useless; does nothing. */
	void set returnValue(bool value) {
	}
	/** Useless; does nothing. */
	void stopImmediatePropagation() {
	}
	/** Useless; returns null. */
	Clipboard get clipboardData() => null;
	/** Useless; does nothing. */
	void set clipboardData(Clipboard data) {
	}
}
