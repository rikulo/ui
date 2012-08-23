//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  08:35:26 AM
// Author: henrichen, tomyeh

typedef CompassSuccessCallback(CompassHeading heading);
typedef CompassErrorCallback();

/**
 * Obtain direction this device is pointing.
 */
interface Compass {
  final CompassHeadingEvents on;

  /**
   * Returns the current direction this device is pointing in degree
   * (north is 0, east is 90, south is 180, west is 270).
   * The CompassHeading is returned via the [success] callback function.
   */
  void getCurrentHeading(CompassSuccessCallback success, CompassErrorCallback error);
}

//abstract
class AbstractCompass implements Compass {
  CompassHeadingEvents _on;
  
  CompassHeadingEvents get on {
    if (_on == null)
      _on = new CompassHeadingEvents._init(this);
    return _on;
  }

  /** Returns the wrapped CompassSuccessCallback from the given CompassHeadingEventListener */
  abstract CompassSuccessCallback wrapSuccessListener_(CompassHeadingEventListener listener);
  /** Returns the wrapped CompassErrorCallback from the given CompassHeadingEventListener */
  abstract CompassErrorCallback wrapErrorListener_(CompassHeadingErrorEventListener listener);

  /**
  * Returns the direction this device pointing in degree at a specified(optional) regular interval.
  * The CompassHeading is returned via the [success] callback function at a regular interval.
  *
  *     options = {"frequency" : 100}; //update every 0.1 second
  *
  * It returns a watchID that can be used to stop this watching later by [clearWatch_].
  */  
  abstract watchHeading_(CompassSuccessCallback success,
  CompassErrorCallback error, [Map options]);
  
  /**
  * Stop watching the heading.
  */
  abstract void clearWatch_(var watchID);
}
