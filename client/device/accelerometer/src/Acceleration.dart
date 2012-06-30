//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  11:22:40 AM
// Author: henrichen, tomyeh

/** The acecleration information.
 */
interface Acceleration default _Acceleration {
  final double x;
  final double y;
  final double z;
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
    this.x = accel["x"], this.y = accel["y"],
    this.z = accel["z"], this.timeStamp = accel["timestamp"];

  String toString() => "($timeStamp: $x, $y, $z)";
}
