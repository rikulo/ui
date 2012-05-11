//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  10:48:26 AM
// Author: henrichen

/**
 * Event fired from the device.
 */
class DeviceEvent<Data> {
	/** Event target
	 */
	final DeviceEventTarget target;
	/** Event type
	 */
	final String type;
	/** Event payload
	 */
	final Data data;
	/** Whether to stop propagate this event.
	 */
	bool propagationStopped;
	
	DeviceEvent(DeviceEventTarget target, String type, Data data) : 
		this.target = target, this.type = type,  this.data = data {
	}
}
