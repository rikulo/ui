//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 13, 2012  04:20:11 PM
// Author: henrichen

class AccelerationErrorEvent extends DeviceEvent {
  AccelerationErrorEvent(Accelerometer target) : super(target);
}

/** AccelerationErrorEvent listener function */
typedef void AccelerationErrorEventListener(AccelerationErrorEvent event);

