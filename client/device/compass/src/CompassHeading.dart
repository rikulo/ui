//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  10:11:22 AM
// Author: henrichen

/** Accleration */
class CompassHeading {
  final double magneticHeading; //0 ~ 359.99 degree
  final double trueHeading; //heading relative to geographic north pole
  final double headingAccuracy; //deviation in degrees between reported heading and true heading
  final int timestamp; //the time the heading was determined
  CompassHeading(this.magneticHeading, this.trueHeading, this.headingAccuracy, this.timestamp);
}
