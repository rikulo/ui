//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  08:35:26 AM
// Author: henrichen

typedef CompassSuccessCallback(CompassHeading);
typedef CompassErrorCallback();

/**
 * Obtain direction this device is pointing.
 */
interface Compass extends DeviceEventTarget {
  final CompassHeadingEvents on;

  /**
   * Returns the current direction this device is pointing in degree(north is 0, east is 90, south is 180, west is 270).
   * The CompassHeading is returned via the onSuccess callback function.
   */
  void getCurrentHeading(CompassSuccessCallback onSuccess, CompassErrorCallback onError);
}

/** error code */
class CompassError {
  static final int COMPASS_INTERNAL_ERR = 0;
  static final int COMPASS_NOT_SUPPORTED = 20;
  int code;
  
  CompassError(this.code);
}