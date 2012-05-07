//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  10:48:26 AM
// Author: henrichen

/**
 * Event fired from the device.
 */
class DeviceEvent {
	/** Event target
	 */
	final DeviceEventTarget _target;
	/** Event type
	 */
	final String type;
	/** Whether to stop propagate this event.
	 */
	bool propagationStopped;
	
	DeviceEvent(DeviceEventTarget target, String type) : 
	_target = target, this.type = type {
	}
}
