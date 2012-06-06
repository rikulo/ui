//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 2, 2012  09:12:33 AM
// Author: henrichen

/**
 * A Cordova device implementation.
 */
class CordovaDevice implements Device {
  String get name() => jsCall("device.name"); //name of this device
  String get cordovaVersion() => jsCall("device.cordova"); //version of Cordova running on the device
  String get platform() => jsCall("device.platform"); //operating system name of this device
  String get version() => jsCall("device.version"); //operating system version of this device
  String get uuid() => jsCall("device.uuid"); //uuid of this device

  Task readyFunction;
  
  bool _ready; //indicate whether the device is ready for access

  Accelerometer accelerometer;
  Camera camera;
  Capture capture;
  Compass compass;
  Contacts contacts;
  XGeolocation geolocation;
  XNotification notification;
  
  CordovaDevice() {
    accelerometer = new CordovaAccelerometer();
    camera = new CordovaCamera();
    capture = new CordovaCapture();
    compass = new CordovaCompass();
    contacts = new CordovaContacts();
    geolocation = new CordovaGeolocation();
    notification = new CordovaNotification();
    
    initJSCall(); //initialize jsutil.js
    application.addReadyCallback((then) {
      if (_ready) {
        then();
      } else {
        _doUntilReady(then);
      }
    });
  }
  
  void _doUntilReady(Task then) {
    readyFunction = () {
      _ready = true;
      _registerDeviceEvents();
      then();

    };
    //init cordova
    jsCall("document.addEventListener", ["deviceready", _onDeviceReady, false]);
  }
  
  void _registerDeviceEvents() {
    jsCall("document.addEventListener", ["pause", _onPause, false]);
    jsCall("document.addEventListener", ["resume", _onResume, false]);
    jsCall("document.addEventListener", ["online", _onOnline, false]);
    jsCall("document.addEventListener", ["offline", _onOffline, false]);
    jsCall("document.addEventListener", ["backbutton", _onBackButton, false]);
    jsCall("document.addEventListener", ["batterycritical", _onBatteryCritical, false]);
    jsCall("document.addEventListener", ["batterylow", _onBatteryLow, false]);
    jsCall("document.addEventListener", ["batterystatus", _onBatteryStatus, false]);
    jsCall("document.addEventListener", ["menubutton", _onMenuButton, false]);
    jsCall("document.addEventListener", ["searchbutton", _onSearchButton, false]);
    jsCall("document.addEventListener", ["startcallbutton", _onStartCallButton, false]);
    jsCall("document.addEventListener", ["endcallbutton", _onEndCallButton, false]);
    jsCall("document.addEventListener", ["volumedownbutton", _onVolumeDownButton, false]);
    jsCall("document.addEventListener", ["volumeupbutton", _onVolumeUpButton, false]);
  }
  
  void _onDeviceReady() {
    device.readyFunction();
  }
  
  void _onPause() {
    if (activity !== null)
      activity.onPause_();
  }
  
  void _onResume() {
    if (activity !== null)
      activity.onResume_();
  }
  
  void _onOnline() {
    //TODO
  }
  
  void _onOffline() {
    //TODO
  }
  
  void _onBackButton() {
    //TODO
  }
  
  void _onBatteryPause() {
    //TODO
  }
  
  void _onBatteryCritical() {
    //TODO
  }
  
  void _onBatteryLow() {
    //TODO
  }
  
  void _onBatteryStatus() {
    //TODO
  }
  
  void _onMenuButton() {
    //TODO
  }
  
  void _onSearchButton() {
    //TODO
  }
  
  void _onStartCallButton() {
    //TODO
  }
  
  void _onEndCallButton() {
    //TODO
  }
  
  void _onVolumeDownButton() {
    //TODO
  }
  
  void _onVolumeUpButton() {
    //TODO
  }
}