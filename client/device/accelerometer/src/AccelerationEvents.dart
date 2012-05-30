//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  11:22:40 AM
// Author: henrichen

/** Acceleration events */
class AccelerationEvents extends DeviceEvents {
	AccelerationEvents(ptr) : super(ptr);
	AccelerationEventListenerList get accelerate() 
		=> get_('accelerate', new AccelerationEventListenerList(this.getEventTarget_(), 'accelerate'));
}