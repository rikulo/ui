//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  11:22:40 AM
// Author: henrichen

class AccelerationEvent extends DeviceEvent {
  AccelerationEvent(Accelerometer target, Acceleration data) : 
    super(target), x = data.x, y = data.y, z = data.z, timestamp = data.timestamp;
  
  final double x;
  final double y;
  final double z;
  final int timestamp;
}

/** AcclerationEvent listener function */
typedef void AccelerationEventListener(AccelerationEvent event);