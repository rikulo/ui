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