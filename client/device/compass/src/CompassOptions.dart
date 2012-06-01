/** Options to setup heading event listener */
interface CompassOptions default _CompassOptions {
  /** interval in milliseconds to retrieve CompassHeading back, default to 100 */
  int frequency;
  /** changes in degrees required to initiate aa watchHeading sucess callback. */
  double filter;
  
  CompassOptions([frequency, filter]);
}

class _CompassOptions implements CompassOptions {
  /** interval in milliseconds to retrieve CompassHeading back, default to 100 */
  int frequency;
  /** changes in degrees required to initiate aa watchHeading sucess callback. */
  double filter;
  
  _CompassOptions([frequency = 100, filter]) : 
    this.frequency = frequency, this.filter = filter;
}

