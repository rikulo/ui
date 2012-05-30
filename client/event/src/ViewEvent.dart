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
	/** The offset relative to [target]'s coordinate.
	 */
	Offset offset;
	bool _propStop = false;

	/** Constructor.
	 *
	 * <p>[target] is the view that this event is targeting.
	 * [type] is the event type, such as click.
	 * <p>[pageX] and [pageY] is the mouse pointer relative to the document.
	 * If this event is constructed from a DOM event, it is
	 */
	ViewEvent(View target, String type, [int pageX=0, int pageY=0]):
	_domEvt = null, _type = type, _stamp = new Date.now().value {
		if (type == null)
			throw const UIException("type required");
		_target = currentTarget = target;
		_updateOffset(pageX, pageY);
	}
	/** Constructs a view event from a DOM event.
	 * It is rarely called unless you'd like to wrap a DOM event.
	 */
	ViewEvent.dom(View target, Event domEvent, [String type]) : 
	_domEvt = domEvent, _type = type != null ? type: domEvent.type,
	_stamp = domEvent.timeStamp {
		_target = currentTarget = target;
		_updateOffset(domEvent.pageX, domEvent.pageY);
	}
	void _updateOffset(int pageX, int pageY) {
		offset = new Offset(pageX, pageY);
		try {
			if (pageX != 0 || pageY != 0) {
				final Offset ofs = new DOMQuery(target).documentOffset;
				offset.left -= ofs.left;
				offset.top -= ofs.top;
			}
		} catch (final e) {
		}
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

	String toString() => "ViewEvent($target,$type)";
}
