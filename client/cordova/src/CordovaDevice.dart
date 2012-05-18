//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 2, 2012  09:12:33 AM
// Author: henrichen

/**
 * A Cordova device implementation.
 */
class CordovaDevice implements Device {
	String get name() {_getName();} //name of this device
	String get cordovaVersion() {_getCordovaVersion();} //version of Cordova running on the device
	String get platform() {_getPlatform();} //operating system name of this device
	String get version() {_getVersion();} //operating system version of this device
	String get uuid() {_getUuid();} //uuid of this device

	Task readyFunction;
	
	bool _ready; //indicate whether the device is ready for access

	Accelerometer accelerometer;
	Camera camera;
	Compass compass;
	Contacts contacts;
	XGeolocation geolocation;
	XNotification notification;
	
	CordovaDevice() {
		accelerometer = new CordovaAccelerometer();
		camera = new CordovaCamera();
		compass = new CordovaCompass();
		contacts = new CordovaContacts();
		geolocation = new CordovaGeolocation();
		notification = new CordovaNotification();
		
		application.addReadyCallback((then) {
			if (_ready) {
				then();
			} else {
				_doUntilReady(then);
			}
		});
	}
	
	void _doUntilReady(Task then) {
		var f = _onDeviceReady; //avoid frogc tree shaking
		readyFunction = () {
			_ready = true;
			f = _onPause; //avoid frogc tree shaking
			f = _onResume; //avoid frogc tree shaking
			f = _onOnline; //avoid frogc tree shaking
			f = _onOffline; //avoid frogc tree shaking
			f = _onBackButton; //avoid frogc tree shaking
			f = _onBatteryCritical; //avoid frogc tree shaking
			f = _onBatteryLow; //avoid frogc tree shaking
			f = _onBatteryStatus; //avoid frogc tree shaking
			f = _onMenuButton; //avoid frogc tree shaking
			f = _onSearchButton; //avoid frogc tree shaking
			f = _onStartCallButton; //avoid frogc tree shaking
			f = _onEndCallButton; //avoid frogc tree shaking
			f = _onVolumeDownButton; //avoid frogc tree shaking
			f = _onVolumeUpButton; //avoid frogc tree shaking
			_registerDeviceEvents();
			then();
		};
		_initCordova();
	}
	void _initCordova() native "document.addEventListener('deviceready', _onDeviceReady, false);";
	void _registerDeviceEvents() native """
		document.addEventListener('pause', _onPause, false);
		document.addEventListener('resume', _onResume, false);
		document.addEventListener('online', _onOnline, false);
		document.addEventListener('offline', _onOffline, false);
		document.addEventListener('backbutton', _onBackButton, false);
		document.addEventListener('batterycritical', _onBatteryCritical, false);
		document.addEventListener('batterylow', _onBatteryLow, false);
		document.addEventListener('batterystatus', _onBatteryStatus, false);
		document.addEventListener('menubutton', _onMenuButton, false);
		document.addEventListener('searchbutton', _onSearchButton, false);
		document.addEventListener('startcallbutton', _onStartCallButton, false);
		document.addEventListener('endcallbutton', _onEndCallButton, false);
		document.addEventListener('volumedownbutton', _onVolumeDownButton, false);
		document.addEventListener('volumeupbutton', _onVolumeUpButton, false);
	""";
	void _getName() native "return device.name;"; //name of this device
	void _getCordovaVersion() native "return device.cordova;"; //version of Cordova running on the device
	void _getPlatform() native "return device.platform;"; //operating system name of this device
	void _getVersion() native "return device.version;"; //operating system version of this device
	void _getUuid() native "return device.uuid;"; //uuid of this device	
}

Function _onDeviceReady() {
print("_onDeviceReady()");
	device.readyFunction();
}
Function _onPause() {
	if (activity !== null)
		activity.onPause_();
}
Function _onResume() {
	if (activity !== null)
		activity.onResume_();
}
Function _onOnline() {
	//TODO
}
Function _onOffline() {
	//TODO
}
Function _onBackButton() {
	//TODO
}
Function _onBatteryPause() {
	//TODO
}
Function _onBatteryCritical() {
	//TODO
}
Function _onBatteryLow() {
	//TODO
}
Function _onBatteryStatus() {
	//TODO
}
Function _onMenuButton() {
	//TODO
}
Function _onSearchButton() {
	//TODO
}
Function _onStartCallButton() {
	//TODO
}
Function _onEndCallButton() {
	//TODO
}
Function _onVolumeDownButton() {
	//TODO
}
Function _onVolumeUpButton() {
	//TODO
}
