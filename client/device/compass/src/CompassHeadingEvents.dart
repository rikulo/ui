//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  11:22:40 AM
// Author: henrichen

/** CompassHeading events */
class CompassHeadingEvents extends DeviceEvents {
  CompassHeadingEvents(ptr) : super(ptr);
  CompassHeadingEventListenerList get heading() 
    => get_('heading', new CompassHeadingEventListenerList(this.getEventTarget_(), 'heading'));
  CompassHeadingEventListenerList get headingFilter() 
    => get_('headingFilter', new CompassHeadingEventListenerList(this.getEventTarget_(), 'headingFilter'));
}

