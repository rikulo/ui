//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  07:00:09 PM
// Author: henrichen

/**
 * Compass implementation for Cordova device.
 */
class CordovaCompass extends AbstractCompass {
	void getCurrentHeading(CompassSuccessCallback onSuccess, CompassErrorCallback onError) {
		_getCurrentHeading0(_wrapFunction(onSuccess), onError);
	}

	CompassSuccessCallback _wrapFunction(CompassSuccessCallback fn) {   
		return ((CompassHeading heading) { //Use CompassHeading to trick frogc to generate proper code
		  fn(new CompassHeading(heading.magneticHeading, heading.trueHeading, heading.headingAccuracy, heading.timestamp));});
	}

	watchHeading(CompassSuccessCallback onSuccess, CompassErrorCallback onError, [Map options]) {
		String opts = options === null || options["frequency"] === null ? '{"frequency":100}' : JSON.stringify(options);
		return _watchHeading0(onSuccess, onError, opts);
	}
	
	void clearWatch(var watchID) {
		_clearWatch0(watchID);
	}
	
	void _getCurrentHeading0(CompassSuccessCallback onSuccess, CompassErrorCallback onError) native
		"navigator.compass.getCurrentCompassHeading(onSuccess, onError);";
	_watchHeading0(CompassSuccessCallback onSuccess, CompassErrorCallback onError, String opts) native
		"return navigator.compass.watchHeading(onSuccess, onError, opts ? JSON.parse(opts) : null);";
	void _clearWatch0(var watchID) native
		"navigator.compass.clearWatch(watchID);";
}
