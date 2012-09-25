//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  10:11:22 AM
// Author: henrichen

interface CompassHeading default _CompassHeading {
  final double magneticHeading; //0 ~ 359.99 degree
  final double trueHeading; //heading relative to geographic north pole
  final double headingAccuracy; //deviation in degrees between reported heading and true heading
  final int timeStamp; //the time the heading was determined

  CompassHeading(double magneticHeading, double trueHeading,
  double headingAccuracy, int timeStamp);
  CompassHeading.from(Map heading);
}
class _CompassHeading implements CompassHeading {
  final double magneticHeading; //0 ~ 359.99 degree
  final double trueHeading; //heading relative to geographic north pole
  final double headingAccuracy; //deviation in degrees between reported heading and true heading
  final int timeStamp; //the time the heading was determined

  _CompassHeading(double this.magneticHeading, double this.trueHeading,
  double this.headingAccuracy, int this.timeStamp);
  _CompassHeading.from(Map heading) :
    this(heading["magneticHeading"], heading["trueHeading"],
      heading["headingAccuracy"], heading["timestamp"]);

  String toString() => "($timeStamp: $magneticHeading, $trueHeading, $headingAccuracy)";
}
