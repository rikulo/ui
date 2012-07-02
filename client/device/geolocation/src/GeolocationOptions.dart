//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  09:17:04 AM
// Author: henrichen

interface GeolocationOptions default _GeolocationOptions {
  /** Frequency to retrieve a Position information; default 10000 */
  int frequency = 10000;
  /** maximum time allowed in millisecond trying to retrieve a valid Position back */
  int timeout;
  /** maximum cached time in millisecond for a position */
  int maximumAge;
  /** Hint requesting best accuracy Position */
  bool enableHighAccuracy;
  
  GeolocationOptions([int frequency, bool enableHighAccuracy, int timeout, int maximumAge]);
}

class _GeolocationOptions implements GeolocationOptions {
  /** Frequency to retrieve a Position information; default 10000 */
  int frequency;
  /** maximum time allowed in millisecond trying to retrieve a valid Position back */
  int timeout;
  /** maximum cached time in millisecond for a position */
  int maximumAge;
  /** Hint requesting best accuracy Position */
  bool enableHighAccuracy;
  
  _GeolocationOptions([int frequency = 10000, bool enableHighAccuracy = true,
  int timeout, int maximumAge]) :
    this.frequency = frequency, this.enableHighAccuracy = enableHighAccuracy, 
    this.timeout = timeout, this.maximumAge = maximumAge;
}
