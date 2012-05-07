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

	ThenCallback readyFunction;
	
	bool _ready; //indicate whether the device is ready for access

	Accelerometer accelerometer;
	
	CordovaDevice() {
		accelerometer = new CordovaAccelerometer();
		application.addReadyCallback((then) {
			if (_ready) {
				then();
			} else {
				_doUntilReady(then);
			}
		});
	}
	
	void _doUntilReady(ThenCallback then) {
		var f = _onDeviceReady; //avoid frogc tree shaking
		readyFunction = () {_ready = true; then();};
		_initCordova();
	}
	void _initCordova() native "document.addEventListener('deviceready', _onDeviceReady, false);";
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