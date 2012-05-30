//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  10:11:22 AM
// Author: henrichen

class CompassHeading {
  final double magneticHeading; //0 ~ 359.99 degree
  final double trueHeading; //heading relative to geographic north pole
  final double headingAccuracy; //deviation in degrees between reported heading and true heading
  final int timestamp; //the time the heading was determined
  CompassHeading(this.magneticHeading, this.trueHeading, this.headingAccuracy, this.timestamp);
  CompassHeading.from(Map heading) : this.magneticHeading = heading["magneticHeading"],
      this.trueHeading = heading["trueHeading"], this.headingAccuracy = heading["headingAccuracy"],
      this.timestamp = heading["timestamp"];
}
