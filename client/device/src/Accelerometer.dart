//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 27, 2012  10:26:33 AM
// Author: henrichen

/**
 * Capture device motion in x, y, and z direction.
 */
interface Accelerometer extends DeviceEventTarget {
  final AccelerationEvents on;

  /**
   * Returns the current motion Acceleration along x, y, and z axis.
   * The Acceleration is returned via the onSuccess callback function.
   */
  void getCurrentAcceleration(AccelerationEventListener onSuccess, ErrorListener onError);
}
