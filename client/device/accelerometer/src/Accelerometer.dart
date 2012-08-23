//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 27, 2012  10:26:33 AM
// Author: henrichen, tomyeh

typedef AccelerometerSuccessCallback(Acceleration accel);
typedef AccelerometerErrorCallback();

/**
 * Capture device motion in x, y, and z direction.
 */
interface Accelerometer {
  final AccelerationEvents on;

  /**
   * Returns the current motion Acceleration along x, y, and z axis.
   * The acceleration is returned via the [success] callback.
   */
  void getCurrentAcceleration(AccelerometerSuccessCallback success,
    AccelerometerErrorCallback error);
}

/** A skeletal implementation of [Accelerometer].
 */
//abstract
class AbstractAccelerometer implements Accelerometer {
  AccelerationEvents _on;
  
  AccelerationEvents get on {
    if (_on == null)
      _on = new AccelerationEvents._init(this);
    return _on;
  }

  /** Returns the wrapped AccelerometerSuccessCallback from the given AccelerationEventListener */
  abstract AccelerometerSuccessCallback wrapSuccessListener_(AccelerationEventListener listener);
  /** Returns the wrapped AccelerometerErrorCallback from the given AccelerationEventListener */
  abstract AccelerometerErrorCallback wrapErrorListener_(AccelerationErrorEventListener listener);
  
  /**
  * Returns the motion Acceleration along x, y, and z axis at a specified(optional) regular interval.
  * The Acceleration is returned via the [success] callback function at a regular interval.
  *
  *     options = {"frequency" : 3000}; //update every 3 seconds
  *
  * It returns a watchID that can be used to stop this watching later by [clearWatch_].
  */  
  abstract watchAcceleration_(AccelerometerSuccessCallback success,
  AccelerometerErrorCallback error, [Map options]);
  
  /**
  * Stop watching the motion acceleration.
  */
  abstract void clearWatch_(var watchID);
}
