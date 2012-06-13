//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 13, 2012  04:21:22 PM
// Author: henrichen

class CompassHeadingErrorEvent extends DeviceEvent {
  CompassHeadingErrorEvent(DeviceEventTarget target) : super(target);
}

/** CompassHeadingErrorEvent listener function */
typedef void CompassHeadingErrorEventListener(CompassHeadingErrorEvent event);