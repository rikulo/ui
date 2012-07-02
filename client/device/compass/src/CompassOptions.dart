/** Options to setup heading event listener */
interface CompassOptions default _CompassOptions {
  /** interval in milliseconds to retrieve CompassHeading back, default to 100 */
  int frequency;
  /** changes in degrees required to initiate a success callback. */
  double filter;
  
  CompassOptions([int frequency, double filter]);
}

class _CompassOptions implements CompassOptions {
  /** interval in milliseconds to retrieve CompassHeading back, default to 100 */
  int frequency;
  /** changes in degrees required to initiate aa sucess callback. */
  double filter;
  
  _CompassOptions([int frequency = 100, double filter]) : 
    this.frequency = frequency, this.filter = filter;

  String toString() => "($frequency, $filter)";
}
