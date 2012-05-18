//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  09:17:04 AM
// Author: henrichen

/*abstract*/ class AbstractGeolocation implements XGeolocation, DeviceEventTarget {
	PositionEvents _on;
	List<WatchIDInfo> _listeners;
	
	AbstractGeolocation() {
		_listeners = new List<WatchIDInfo>();
	}

	PositionEvents get on() {
		if (_on === null)
		  _on = new PositionEvents(this);
		return _on;
	}

	void addEventListener(String type, PositionEventListener listener, [Map options]) {
		removeEventListener(type, listener);
		var watchID = watchPosition(_wrapListener(listener), (XPositionError error) => print("onPositionError: code:"+error.code+", message:"+error.message), options); //TODO: log and forget?
		_listeners.add(new WatchIDInfo(listener, watchID));
	}
	
	//parameter called back from javascript Cordova would be a {}, must convert paremeter type back to dart Position
	GeolocationSuccessCallback _wrapListener(PositionEventListener listener) {   
		return ((Position pos) { //Use Position to trick frogc to generate proper code
		  listener(new PositionEvent(this, 
			new Position(new XCoordinates(pos.coords.latitude, pos.coords.longitude, pos.coords.altitude, 
					pos.coords.accuracy, pos.coords.altitudeAccuracy, pos.coords.heading, pos.coords.speed), pos.timestamp)));});
	}

	void removeEventListener(String type, PositionEventListener listener) {
		for(int j = 0; j < _listeners.length; ++j) {
		  print("AbstractGeolocation.removeEventListener: j:"+j);        
			if (_listeners[j]._listener == listener) {
				var watchID = _listeners[j]._watchID;
				if (watchID !== null) {
				  clearWatch(watchID);
				}
				break;
			}
		}
	}
	
	bool isEventListened(String type) {
		return _listeners.isEmpty();
	}
	
	/**
	* Watches for position changes of this device.
	* The Position is returned via the onSuccess callback function.
	* @return a watchID that can be used to stop this watching later by #clearWatch() method.
	*/  
	abstract watchPosition(GeolocationSuccessCallback onSuccess, [GeolocationErrorCallback onError, Map options]);
	
	/**
	* Stop watching the motion Position.
	*/
	abstract void clearWatch(var watchID);
}