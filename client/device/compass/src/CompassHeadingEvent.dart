//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  09:12:22 AM
// Author: henrichen

class CompassHeadingEvent extends DeviceEvent<CompassHeading> {
	CompassHeadingEvent(DeviceEventTarget target, CompassHeading data) : super(target, "heading", data);

	double get magneticHeading() => data.magneticHeading;
	double get trueHeading() => data.trueHeading;
	double get headingAccuracy() => data.headingAccuracy;
	int get timestamp() => data.timestamp;
}

/** CompassHeadingEvent listener function */
typedef void CompassHeadingEventListener(CompassHeadingEvent event);