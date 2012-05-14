//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  06:03:45 PM
// Author: henrichen

/*abstract*/ class AbstractCompass implements Compass, DeviceEventTarget {
	CompassHeadingEvents _on;
	List<_WatchIDInfo> _listeners;
	
	AbstractCompass() {
		_listeners = new List<_WatchIDInfo>();
	}

	CompassHeadingEvents get on() {
		if (_on === null)
		  _on = new CompassHeadingEvents(this);
		return _on;
	}

	void addEventListener(String type, CompassHeadingEventListener listener, [Map options]) {
		removeEventListener(type, listener);
		var watchID = "heading" == type ? 
			watchHeading(listener, () => print("onHeading error!"), options):
			watchHeadingFilter(listener, () => print("onHeadingFilter error!"), options);
		_listeners.add(new _WatchIDInfo(listener, watchID));
	}
	
	void removeEventListener(String type, CompassHeadingEventListener listener) {
		for(int j = 0; j < _listeners.length; ++j) {
			if (_listeners[j]._listener == listener) {
				var watchID = _listeners[j]._watchID;
				if (watchID !== null) {
					if ("heading" == type) 
						clearWatch(watchID);
					else
						clearWatchFilter(watchID);
				}
				break;
			}
		}
	}
	
	bool isEventListened(String type) {
		return _listeners.isEmpty();
	}
	
	/**
	* Returns the direction this device pointing in degree at a specified(optional) regular interval.
	* The CompassHeading is returned via the onSuccess callback function at a regular interval.
	* options = {"frequency" : 100}; //update every 0.1 second
	* @return a watchID that can be used to stop this watching later by #clearWatch() method.
	*/  
	abstract watchHeading(CompassSuccessCallback onSuccess, CompassErrorCallback onError, [Map options]);
	
	/**
	* Stop watching the heading.
	*/
	abstract void clearWatch(var watchID);

	/**
	* [This is only availbe in iOS platform]
	* Returns the direction this device pointing in degree only when degree change beyond the specified degree.
	* The CompassHeading is returned via the onSuccess callback function whenever the degree change beyond the specified degree.
	* options = {"filter" : 10}; //update if degree change is beyond 10 degree
	* @return a watchID that can be used to stop this watching later by #clearWatchFilter() method.
	*/  
	abstract watchHeadingFilter(CompassSuccessCallback onSuccess, CompassErrorCallback onError, [Map options]);
	
	/**
	* [This is only availbe in iOS platform]
	* Stop watching the heading filter.
	*/
	abstract void clearWatchFilter(var watchID);
}

class _WatchIDInfo {
	final CompassHeadingEventListener _listener;
	final _watchID;
	_WatchIDInfo(this._listener, this._watchID);
}
