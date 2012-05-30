//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  09:23:10 AM
// Author: henrichen

typedef GeolocationSuccessCallback(Position position);
typedef GeolocationErrorCallback(PositionError error);

/**
 * Capture device location information in latitude and longitude (generally come from a GPS sensor, etc.)
 */
interface XGeolocation extends DeviceEventTarget { //rename to XGeolocation to avoid name confilct with dart:html Geolocation interface
  final PositionEvents on;

  /**
   * Returns the current Position of this device.
   * The Position is returned via the onSuccess callback function.
   */
  void getCurrentPosition(GeolocationSuccessCallback onSuccess, [GeolocationErrorCallback onError, GeolocationOptions options]);
}
