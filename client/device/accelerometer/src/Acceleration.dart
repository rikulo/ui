//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  11:22:40 AM
// Author: henrichen, tomyeh

/** The acecleration information. When a device lying flat on a table and facing up, the value
 * is x = 0, y = 0, and z = 9.81 (one gravity in meter/sec^2)
 */
interface Acceleration default _Acceleration {
  /** Acceleration in x axis in meters/sec^2. */
  final double x;
  /** Acceleration in y axis in meters/sec^2. */
  final double y;
  /** Acceleration in z axis in meters/sec^2. */
  final double z;
  /** The time stamp in milliseconds this value is created */
  final int timeStamp;

  Acceleration(double x, double y, double z, int timeStamp);
  Acceleration.from(Map accel);
}
class _Acceleration implements Acceleration {
  final double x;
  final double y;
  final double z;
  final int timeStamp;

  _Acceleration(double this.x, double this.y, double this.z, int this.timeStamp);
  _Acceleration.from(Map accel) :
    this(accel["x"], accel["y"], accel["z"], accel["timestamp"]);

  String toString() => "($timeStamp: $x, $y, $z)";
}
