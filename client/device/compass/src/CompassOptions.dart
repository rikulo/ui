/** Options to setup heading event listener */
class CompassOptions {
  /** interval in milliseconds to retrieve CompassHeading back, default to 100 */
  int frequency;
  /** changes in degrees required to initiate aa watchHeading sucess callback. */
  double filter;
  
  CompassOptions(this.frequency, this.filter);
}

