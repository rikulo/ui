//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  09:23:10 AM
// Author: henrichen

typedef GeolocationSuccessCallback(Position position);
typedef GeolocationErrorCallback(XPositionError error);

/**
 * Capture device location information in latitude and longitude (generally come from a GPS sensor, etc.)
 */
interface XGeolocation { //rename to XGeolocation to avoid name confilct with dart:html Geolocation interface
  final PositionEvents on;

  /**
   * Returns the current Position of this device.
   * The Position is returned via the onSuccess callback function.
   */
  void getCurrentPosition(GeolocationSuccessCallback onSuccess, [GeolocationErrorCallback onError, GeolocationOptions]);
}

class XPositionError { //rename to XPositionError to avoid name confilct with dart:html PostionError interface
	final static int PERMISSION_DENIED = 1;
	final static int POSITION_UNAVAILABLE = 2;
	final static int TIMEOUT = 3;
	
	int code;
	String message;
}

class GeolocationOptions {
	/** Frequency to retrieve a Position information; default 10000 */
	int frequency = 10000;
	/** Hint requesting best accuracy Position */
	bool enableHighAccuracy;
	/** maximum time allowed in millisecond trying to retrieve a valid Position back */
	int timeout;
	/** maximum cached time in millisecond for a position */
	int maximumAge;
}