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

	watchHeading(CompassSuccessCallback onSuccess, CompassErrorCallback onError, [Map options]) {
		String opts = options === null || options["frequency"] === null ? '{"frequency":100}' : JSON.stringify(options);
		return _watchHeading0(_wrapFunction(onSuccess), onError, opts);
	}
	
	void clearWatch(var watchID) {
		_clearWatch0(watchID);
	}

	watchHeadingFilter(CompassSuccessCallback onSuccess, CompassErrorCallback onError, [Map options]) {
		String opts = options === null || options["filter"] === null ? '{"fiter":10}' : JSON.stringify(options);
		return _watchHeadingFilter0(_wrapFunction(onSuccess), onError, opts);
	}
	
	void clearWatchFilter(var watchID) {
		_clearWatchFilter0(watchID);
	}

	//parameter called back from javascript Cordova would be a {}, must convert paremeter type back to dart CompassHeading
	_wrapFunction(dartFn) {   
		var $dartFn = dartFn;
		return ((CompassHeading heading) { //Use CompassHeading to trick frogc to generate proper code
		  $dartFn(new CompassHeadingEvent(this, new CompassHeading(heading.magneticHeading, heading.trueHeading, heading.headingAccuracy, heading.timestamp)));});
	}

	void _getCurrentHeading0(CompassSuccessCallback onSuccess, CompassErrorCallback onError) native
		"navigator.compass.getCurrentCompassHeading(onSuccess, onError);";
	_watchHeading0(CompassSuccessCallback onSuccess, CompassErrorCallback onError, String opts) native
		"return navigator.compass.watchHeading(onSuccess, onError, opts ? JSON.parse(opts) : null);";
	void _clearWatch0(var watchID) native
		"navigator.compass.clearWatch(watchID);";
	_watchHeadingFilter0(CompassSuccessCallback onSuccess, CompassErrorCallback onError, String opts) native
		"return navigator.compass.watchHeadingFilter(onSuccess, onError, opts ? JSON.parse(opts) : null);";
	void _clearWatchFilter0(var watchID) native
		"navigator.compass.clearWatchFilter(watchID);";
}
