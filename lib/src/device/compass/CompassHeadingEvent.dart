//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  09:12:22 AM
// Author: henrichen

class CompassHeadingEvent {
  CompassHeadingEvent(Compass this.target, CompassHeading this.heading);

  final Compass target;
  final CompassHeading heading;
  /** Returns the time stamp. */
  int get timeStamp => heading.timeStamp;
}

class CompassHeadingErrorEvent {
  CompassHeadingErrorEvent(Compass this.target);

  final Compass target;
}

/** CompassHeadingEvent listener function */
typedef void CompassHeadingEventListener(CompassHeadingEvent event);
/** CompassHeadingErrorEvent listener function */
typedef void CompassHeadingErrorEventListener(CompassHeadingErrorEvent event);
