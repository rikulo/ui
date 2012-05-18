//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  09:13:10 AM
// Author: henrichen

/**
 * Geolocation implementation for Cordova device.
 */
class CordovaGeolocation extends AbstractGeolocation {
	void getCurrentPosition(GeolocationSuccessCallback onSuccess, [GeolocationErrorCallback onError, GeolocationOptions options]) {
		String opts = null;
		if (options === null) {
			opts = '{"enableHighAccuracy":true,"timeout":10000,"maximumAge":10000}';
		} else {
			StringBuffer sb = new StringBuffer();
			sb.add("'enableHighAccuracy':").add(options.enableHighAccuracy === null ? true : options.enableHighAccuracy)
				.add(",'timeout':").add(options.timeout === null ? 10000 : options.timeout)
				.add(",'maximumAge':").add(options.maximumAge === null ? 10000 : options.maximumAge)
				.add("}");
			opts = sb.toString();
		}
		_getCurrentPosition0(_wrapFunction(onSuccess), onError, opts);
	}

	GeolocationSuccessCallback _wrapFunction(GeolocationSuccessCallback fn) {   
		return ((Position pos) { //Use Position to trick frogc to generate proper code
		  fn(new Position(new XCoordinates(pos.coords.latitude, pos.coords.longitude, pos.coords.altitude, 
					pos.coords.accuracy, pos.coords.altitudeAccuracy, pos.coords.heading, pos.coords.speed), pos.timestamp));});
	}

	watchPosition(GeolocationSuccessCallback onSuccess, [GeolocationErrorCallback onError, Map options]) {
		String opts = options === null ? 
			'''{
				"enableHighAccuracy" : true,
				"timeout" : 10000,
				"maximumAge" : 10000
			}''' : JSON.stringify(options);
		return _watchPosition0(onSuccess, onError, opts);
	}
	
	void clearWatch(var watchID) {
		_clearWatch0(watchID);
	}

	void _getCurrentPosition0(GeolocationSuccessCallback onSuccess, GeolocationErrorCallback onError, String opts) native
		"navigator.geolocation.getCurrentPosition(onSuccess, onError, opts ? JSON.parse(opts) : null);";
	_watchPosition0(GeolocationSuccessCallback onSuccess, GeolocationErrorCallback onError, String opts) native
		"return navigator.geolocation.watchPosition(onSuccess, onError, opts ? JSON.parse(opts) : null);";
	void _clearWatch0(var watchID) native
		"navigator.geolocation.clearWatch(watchID);";
}
