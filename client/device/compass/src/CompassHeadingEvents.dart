//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  11:22:40 AM
// Author: henrichen

/** Options to setup heading event listener */
class CompassOptions {
  /** interval in milliseconds to retrieve CompassHeading back, default to 100 */
  int frequency;
  /** required degree change to fire an watchHeadingFilter sucess callback. */
  double filter;
}

/** CompassHeading events */
class CompassHeadingEvents extends DeviceEvents {
	CompassHeadingEvents(ptr) : super(ptr);
	CompassHeadingEventListenerList get heading() 
		=> get_('heading', new CompassHeadingEventListenerList(this.getEventTarget_(), 'heading'));
	CompassHeadingEventListenerList get headingFilter() 
		=> get_('headingFilter', new CompassHeadingEventListenerList(this.getEventTarget_(), 'headingFilter'));
}

/** CompassHeadingEvent listener list */
class CompassHeadingEventListenerList implements DeviceEventListenerList {
	DeviceEventListenerList _delegate;
	CompassHeadingEventListenerList(var ptr, var type) {
		_delegate = new DeviceEventListenerList(ptr, type);
	}

	CompassHeadingEventListenerList add(CompassHeadingEventListener listener, [CompassOptions options]) {
		print("CompassHeadingEventListenerList.add()");
		_delegate.add(listener, _toMap(options));
		return this;
	}
	CompassHeadingEventListenerList remove(CompassHeadingEventListener listener) {
		_delegate.remove(listener);
		return this;
	}
	/** Tests if any listener is registered.
	*/
	bool isEventListened() {
		return _delegate.isEventListened();
	}
	Map _toMap(CompassOptions opts) {
		return {"frequency" : opts === null || opts.frequency === null ? 100 : opts.frequency,
				"filter" : opts === null || opts.filter === null ? 10 : opts.filter};
	}
}

