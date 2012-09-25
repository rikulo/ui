//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  09:23:10 AM
// Author: henrichen, tomyeh

typedef GeolocationSuccessCallback(Position position);
typedef GeolocationErrorCallback(PositionError error);

/**
 * Capture device location information in latitude and longitude (generally come from a GPS sensor, etc.)
 */
interface XGeolocation { //rename to XGeolocation to avoid name confilct with dart:html Geolocation interface
  final PositionEvents on;

  /**
   * Returns the current Position of this device.
   * The Position is returned via the success callback function.
   */
  void getCurrentPosition(GeolocationSuccessCallback success,
    [GeolocationErrorCallback error, GeolocationOptions options]);
}

//abstract
class AbstractGeolocation implements XGeolocation {
  PositionEvents _on;
  
  PositionEvents get on {
    if (_on == null)
      _on = new PositionEvents._init(this);
    return _on;
  }

  /** Returns the wrapped GeolocationSuccessCallback from the given PositionEventListener */
  abstract GeolocationSuccessCallback wrapSuccessListener_(PositionEventListener listener);
  /** Returns the wrapped GeolocationErrorCallback from the given PositionEventListener */
  abstract GeolocationErrorCallback wrapErrorListener_(PositionErrorEventListener listener);

  /**
  * Watches for position changes of this device.
  * The Position is returned via the [success] callback function.
  *
  * It returns a watchID that can be used to stop this watching later by [clearWatch_].
  */  
  abstract watchPosition_(GeolocationSuccessCallback success,
    [GeolocationErrorCallback error, Map options]);
  
  /**
  * Stop watching the motion Position.
  */
  abstract void clearWatch_(var watchID);
}
