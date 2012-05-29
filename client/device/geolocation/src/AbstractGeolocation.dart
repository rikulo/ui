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
		var watchID = watchPosition(wrapListener_(listener), (PositionError error) => print("onPositionError: code:"+error.code+", message:"+error.message), options); //TODO: log and forget?
		_listeners.add(new WatchIDInfo(listener, watchID));
	}
	
	void removeEventListener(String type, PositionEventListener listener) {
		for(int j = 0; j < _listeners.length; ++j) {
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
	
	/** Returns the wrapped GeolocationSuccessCallback from the given PositionEventListener */
	abstract GeolocationSuccessCallback wrapListener_(PositionEventListener listener);
	
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


/** Coordinates */
class CoordinatesImpl implements Coordinates {
	/** Latitude in decimal degrees. */
	double latitude;
	/** Longitude in decimal degrees. */
	double longitude;
	/** Height of the position in meters above the ellipsoid. */
	double altitude;
	/** Accuracy level of the latitude and longitude in meters. */
	double accuracy;
	/** Accuracy level of altitude in meters. */
	double altitudeAccuracy;
	/** Direction of travel in degrees to true north (north is 0 degree, east is 90 degree, south is 180 degree, west is 270 degree) */
	double heading;
	/** Ground speed in meters per second */
	double speed;
	
	CoordinatesImpl(this.latitude, this.longitude, this.altitude, 
		this.accuracy, this.altitudeAccuracy, this.heading, this.speed);
  CoordinatesImpl.from(Map coords) : this.latitude = coords["latitude"], this.longitude = coords["longitude"],
      this.altitude = coords["altitude"], this.accuracy = coords["accuracy"], 
      this.altitudeAccuracy = coords["altitudeAccuracy"], this.heading = coords["heading"],
      this.speed = coords["speed"];
}
