//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  09:19:11 AM
// Author: henrichen

/** Position events */
class PositionEvents extends DeviceEvents {
	PositionEvents(ptr) : super(ptr);
	PositionEventListenerList get position() 
		=> get_('position', new PositionEventListenerList(this.getEventTarget_(), 'position'));
}

