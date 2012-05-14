//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  09:12:22 AM
// Author: henrichen

class CompassHeadingEvent extends DeviceEvent {
	CompassHeadingEvent(DeviceEventTarget target, CompassHeading data) : 
	  magneticHeading = data.magneticHeading, trueHeading = data.trueHeading,
	  headingAccuracy = data.headingAccuracy, timestamp = data.timestamp;

	final double magneticHeading;
	final double trueHeading;
	final double headingAccuracy;
	final int timestamp;
}

/** CompassHeadingEvent listener function */
typedef void CompassHeadingEventListener(CompassHeadingEvent event);