//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 2, 2012  09:12:33 AM
// Author: henrichen

/**
 * A Cordova device implementation.
 */
class CordovaDevice implements Device {
  static final String _NAME = "device.name";
  static final String _CORDOVA = "device.cordova";
  static final String _PLATFORM = "device.platform";
  static final String _VERSION = "device.version";
  static final String _UUID = "device.uuid";
  static final String _ADD_EVENT_LISTENER = "document.addEventListener";
  static final String _INIT_CORDOVA = "initCordova";
  
  String get name() => jsCall(_NAME); //name of this device
  String get cordovaVersion() => jsCall(_CORDOVA); //version of Cordova running on the device
  String get platform() => jsCall(_PLATFORM); //operating system name of this device
  String get version() => jsCall(_VERSION); //operating system version of this device
  String get uuid() => jsCall(_UUID); //uuid of this device

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
        _doWhenDeviceReady(then);
      }
    });
  }
  
  void addService(String name, var service) {
    services[name] = service;
  }
  
  void _doWhenDeviceReady(Task then) {
    readyFunction = () {
      _ready = true;
      _registerDeviceEvents();
      then();
    };
    //init cordova
    doWhenReady(() => jsCall(_ADD_EVENT_LISTENER, ["deviceready", _onDeviceReady, false]), 
        () => jsCall(_INIT_CORDOVA) !== null, //until window.cordova exists (@see cordova.js)
        (int msec) {if(msec == 0) log("Fail to load cordova.js!");},
        10, 60000); //try every 10 ms, try total 60 seconds. 
  }
  
  void _registerDeviceEvents() {
    jsCall(_ADD_EVENT_LISTENER, ["pause", _onPause, false]);
    jsCall(_ADD_EVENT_LISTENER, ["resume", _onResume, false]);
    jsCall(_ADD_EVENT_LISTENER, ["online", _onOnline, false]);
    jsCall(_ADD_EVENT_LISTENER, ["offline", _onOffline, false]);
    jsCall(_ADD_EVENT_LISTENER, ["backbutton", _onBackButton, false]);
    jsCall(_ADD_EVENT_LISTENER, ["batterycritical", _onBatteryCritical, false]);
    jsCall(_ADD_EVENT_LISTENER, ["batterylow", _onBatteryLow, false]);
    jsCall(_ADD_EVENT_LISTENER, ["batterystatus", _onBatteryStatus, false]);
    jsCall(_ADD_EVENT_LISTENER, ["menubutton", _onMenuButton, false]);
    jsCall(_ADD_EVENT_LISTENER, ["searchbutton", _onSearchButton, false]);
    jsCall(_ADD_EVENT_LISTENER, ["startcallbutton", _onStartCallButton, false]);
    jsCall(_ADD_EVENT_LISTENER, ["endcallbutton", _onEndCallButton, false]);
    jsCall(_ADD_EVENT_LISTENER, ["volumedownbutton", _onVolumeDownButton, false]);
    jsCall(_ADD_EVENT_LISTENER, ["volumeupbutton", _onVolumeUpButton, false]);
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
    if (jsCall(_INIT_CORDOVA) === null) {
      injectJavaScriptSrc(uri); //load asynchronously
    }
  }
  
  void _initJSFunctions() {
    newJSFunction(_INIT_CORDOVA, null, '''
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
    newJSFunction(_ADD_EVENT_LISTENER, ["evtname", "listener", "bubble"], '''
      var fn = function() {listener.\$call\$0();};
      document.addEventListener(evtname, fn, bubble);
    ''');
    newJSFunction(_NAME, null, "return device.name;"); //name of this device
    newJSFunction(_CORDOVA, null, "return device.cordova;"); //version of Cordova running on the device
    newJSFunction(_PLATFORM, null, "return device.plaform;"); //operating system name of this device
    newJSFunction(_VERSION, null, "return device.version;"); //operating system version of this device
    newJSFunction(_UUID, null, "return device.uuid;"); //uuid of this device 
  }
}
