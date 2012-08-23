//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  11:22:40 AM
// Author: henrichen

class AccelerationEvent {
  AccelerationEvent(Accelerometer this.target, Acceleration this.acceleration);
  
  final Accelerometer target;
  final Acceleration acceleration;
  /** Returns the time stamp. */
  int get timeStamp => acceleration.timeStamp;
}

class AccelerationErrorEvent {
  AccelerationErrorEvent(Accelerometer this.target);

  final Accelerometer target;
}

/** [AcclerationEvent] listener function */
typedef void AccelerationEventListener(AccelerationEvent event);
/** [AccelerationErrorEvent] listener function */
typedef void AccelerationErrorEventListener(AccelerationErrorEvent event);
