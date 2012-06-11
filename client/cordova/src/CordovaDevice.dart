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
  Map<String, Object> services; //services
  
  bool _ready; //indicate whether the device is ready for access

  Accelerometer get accelerometer() => services["accelerometer"];
  Camera get camera() => services["camera"];
  Capture get capture() => services["capture"];
  Compass get compass() => services["compass"];
  Connection get connection() => services["connection"];
  Contacts get contacts() => services["contacts"];
  XGeolocation get geolocation() => services["geolocation"];
  XNotification get notification() => services["notification"];
  
  CordovaDevice([String serviceURI = "cordova.js", 
                List<String> serviceNames = const ["accelerometer", "camera", "capture", "compass", "connection", "contacts", "geolocation", "notification"]]) {
    initJSCall();
    _initJSFunctions();
    _initCordova(serviceURI);
    
    if (serviceNames !== null) {
      services = new Map();
      for(String sname in serviceNames) {
        switch(sname) {
          case "accelerometer": services[sname] = new CordovaAccelerometer(); break;
          case "camera": services[sname] = new CordovaCamera(); break;
          case "capture": services[sname] = new CordovaCapture(); break;
          case "compass": services[sname] = new CordovaCompass(); break;
          case "connection": services[sname] = new CordovaConnection(); break;
          case "contacts": services[sname] = new CordovaContacts(); break;
          case "geolocation": services[sname] = new CordovaGeolocation(); break;
          case "notification": services[sname] = new CordovaNotification(); break;
        }
      }
    }
    
    application.addReadyCallback((then) {
      if (_ready) {
        then();
      } else {
        _doUntilReady(then);
      }
    });
  }
  
  void addService(String name, var service) {
    services[name] = service;
  }
  
  void _doUntilReady(Task then) {
    readyFunction = () {
      _ready = true;
      _registerDeviceEvents();
      then();
    };
    //init cordova
    waitCordovaLoaded(() => jsCall("document.addEventListener", ["deviceready", _onDeviceReady, false]), 10);
  }
  
  void waitCordovaLoaded(Function fn, int timeout) {
    window.setTimeout(() {
      if (jsCall("initCordova") !== null) //until window.cordova exists (@see cordova.js)
        fn(); 
      else
        waitCordovaLoaded(fn, timeout);
    }, timeout);
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
  
  void _initCordova(String uri) {
    if (jsCall("initCordova") === null) {
      injectJavaScriptSrc(uri); //load asynchronously
    }
  }
  
  void _initJSFunctions() {
    newJSFunction("initCordova", null, '''
      if (window.cordova) {
        if(window.cordova.require) {
          var channel = window.cordova.require("cordova/channel");
          if (!channel.onDOMContentLoaded.fired) {
            channel.onDOMContentLoaded.fire();
          }
        }
      }
      return window.cordova;
    ''');
    newJSFunction("document.addEventListener", ["evtname", "listener", "bubble"], '''
      var fn = function() {listener.\$call\$0();};
      document.addEventListener(evtname, fn, bubble);
    ''');
    newJSFunction("device.name", null, "return device.name;"); //name of this device
    newJSFunction("device.cordova", null, "return device.cordova;"); //version of Cordova running on the device
    newJSFunction("device.platform", null, "return device.plaform;"); //operating system name of this device
    newJSFunction("device.version", null, "return device.version;"); //operating system version of this device
    newJSFunction("device.uuid", null, "return device.uuid;"); //uuid of this device 
  }
}
