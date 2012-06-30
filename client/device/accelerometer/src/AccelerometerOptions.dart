//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  11:22:40 AM
// Author: henrichen

interface AccelerometerOptions default _AccelerometerOptions {
  /** interval in milliseconds to retrieve Accleration back; default to 3000 */
  int frequency;
  
  AccelerometerOptions([int frequency]);
}

class _AccelerometerOptions implements AccelerometerOptions {
  /** interval in milliseconds to retrieve Accleration back; default to 3000 */
  int frequency;
  
  _AccelerometerOptions([int frequency = 3000]) : this.frequency = frequency;
}
