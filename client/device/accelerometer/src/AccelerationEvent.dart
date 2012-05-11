//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  11:22:40 AM
// Author: henrichen

class AccelerationEvent extends DeviceEvent<Acceleration> {
	AccelerationEvent(DeviceEventTarget target, Acceleration data) : super(target, "accelerate", data);
	
	double get x() => data.x;
	double get y() => data.y;
	double get z() => data.z;
	int get timestamp() => data.timestamp;
}

/** AcclerationEvent listener function */
typedef void AccelerationEventListener(AccelerationEvent event);