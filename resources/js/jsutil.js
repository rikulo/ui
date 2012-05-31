//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 24, 2012  02:27:12 PM
// Author: henrichen

/**
 * Bridge between Dart and Cordova/Javascript
 */
//20120528, henrichen: tricky!
//dart2js wrap a Dart function into a JavaScript prototype and refers it with an attribute 
//in the name pattern of "$call$x" where x is the number of arguments of the function. 
//e.g. 
//1. xyz() with no argument will be wrapped to a JavaScript prototype 
//	MyABC = {
//		$call$0: function() {xyz();}
//	};
//
//2. xyz(arg1) with one argument will be wrapped to a JavaScript prototype
//  MyABC = {
//		$call$1: function(arg1) {xyz(arg1);}
//	};
//
//3. xyz(arg1, arg2) with two arguments will be wrapped to a JavaScript prototype
//  MyABC = {
//		$call$2: function(arg1,arg2) {xyz(arg1,arg2);}
//	};
var _natives = {
	//Utilities
	"get" : function(obj, attr) {
		return obj[attr];
	},
	"set" : function(obj, attr, val) {
		obj[attr] = val;
	},
	"forEach" : function(jslist, fn) {
		if (jslist) {
			for(var j = 0; j < jslist.length; ++j) {
				fn.$call$1(jslist[j]);
			}
		}
	},
	"forEachKey" : function(jsmap, fn) {
		if (jsmap) {
			for(var key in jsmap) {
				fn.$call$2(key, jsmap[key]);
			}
		}
	},
	"_newItem" : function(result, item) {
		if (result.length == 0) result[0] = [];
		result[0].push(item);
	},
	"_newEntry" : function(result, k, v) {
		if (result.length == 0) result[0] = {};
		result[0][k] = v;
	},
	"date.getTime" : function(jsdate) {
		return jsdate ? jsdate.getTime() : null;
	},
	"new Date" : function(msecs) {
		return msecs != null ? new Date(msecs) : null;
	},
	"{}" : function() { //empty map
		return {};
	},
	"[]" : function() { //empty array
		return [];
	},
	
	//CordovaAccelerometer
	"accelerometer.getCurrentAcceleration" : function(onSuccess, onError) {
		var fnSuccess = function(accel) {onSuccess.$call$1(accel);},
			fnError = function() {onError.$call$0();};
		navigator.accelerometer.getCurrentAcceleration(fnSuccess, fnError);
	},
	"accelerometer.watchAcceleration" : function(onSuccess, onError, opts) {
		var fnSuccess = function(accel) {onSuccess.$call$1(accel);},
			fnError = function() {onError.$call$0();};
		return navigator.accelerometer.watchAcceleration(fnSuccess, fnError, opts);
	},
	"accelerometer.clearWatch" : function(watchID) {
		navigator.accelerometer.clearWatch(watchID);
	},
	
	//CordovaCamera
	"camera.getPicture" : function(onSuccess, onError, opts) {
		var fnSuccess = function(data) {onSuccess.$call$1(data);},
			fnError = function(meg) {onError.$call$1(msg);};
		navigator.camera.getPicture(fnSuccess, fnError, opts);
	},
	
	//CordovaCapture
	"capture.supportedAudioModes" : function() {
		return navigator.device.capture.supportedAudioModes;
	},
	"capture.supportedImageModes" : function() {
		return navigator.device.capture.supportedImageModes;
	},
	"capture.supportedVideoModes" : function() {
		return navigator.device.capture.supportedVideoModes;
	},
	"capture.captureAudio" : function(onSuccess, onError, opts) {
		var fnSuccess = function(files) {onSuccess.$call$1(files);},
			fnError = function(err) {onError.$call$1(err);};
		navigator.device.capture.captureAudio(fnSuccess, fnError, opts);
	},
	"capture.captureImage" : function(onSuccess, onError, opts) {
		var fnSuccess = function(files) {onSuccess.$call$1(files);},
			fnError = function(err) {onError.$call$1(err);};
		navigator.device.capture.captureImage(fnSuccess, fnError, opts);
	},
	"capture.captureVideo" : function(onSuccess, onError, opts) {
		var fnSuccess = function(files) {onSuccess.$call$1(files);},
			fnError = function(err) {onError.$call$1(err);};
		navigator.device.capture.captureVideo(fnSuccess, fnError, opts);
	},
	"MediaFile.getFormatData" : function(mediaFile, onSuccess, onError) {
		var fnSuccess = function(data) {onSuccess.$call$1(data);},
			fnError = function() {onError.$call$0();};
		mediaFile.getFormatData(fnSuccess, fnError);
	},
		
	//CordovaCompass
	"compass.getCurrentCompassHeading" : function(onSuccess, onError) {
		var fnSuccess = function(heading) {onSuccess.$call$1(heading);},
			fnError = function() {onError.$call$0();};
		navigator.compass.getCurrentCompassHeading(fnSuccess, fnError);
	},
	"compass.watchHeading" : function(onSuccess, onError, opts) {
		var fnSuccess = function(heading) {onSuccess.$call$1(heading);},
			fnError = function() {onError.$call$0();};
		return navigator.compass.watchHeading(fnSuccess, fnError, opts);
	},
	"compass.clearWatch" : function(watchID) {
		navigator.compass.clearWatch(watchID);
	},
	
	//CordovaConnection
	"connection.type" : function() {
		return navigator.network.connection.type;
	},
	
	//CordovaContacts
	"contacts.create" : function() {
		return navigator.contacts.create({});
	},
	"contacts.find" : function(fields, onSuccess, onError, opts) {
		var fnSuccess = function(contacts) {onSuccess.$call$1(contacts);},
			fnError = function(err) {onError.$call$1(err);};
		navigator.contacts.find(fields, fnSuccess, fnError, opts);
	},
	"contact.clone" : function(contact) {
		return contact.clone();
	},
	"contact.remove" : function(contact, onSuccess, onError) {
		var fnSuccess = function(contact0) {onSuccess.$call$1(contact0);},
			fnError = function(err) {onError.$call$1(err);};
		contact.remove(fnSuccess, fnError);
	},
	"contact.save" : function(contact, onSuccess, onError) {
		var fnSuccess = function(contact0) {onSuccess.$call$1(contact0);},
			fnError = function(err) {onError.$call$1(err);};
		contact.save(fnSuccess, fnError);
	},
	
	
	//CordovaDevice
	"document.addEventListener" : function(evtname, listener, bubble) {
		var fn = function() {listener.$call$0();};
		document.addEventListener(evtname, fn, bubble);
	},
	"device.name" : function() { 
		return device.name; //name of this device
	},
	"device.cordova" : function() {
		return device.cordova; //version of Cordova running on the device
	},
	"device.platform" : function() {
		return device.plaform; //operating system name of this device
	},
	"device.version" : function() {
		return device.version; //operating system version of this device
	},
	"device.uuid" : function() {
		return device.uuid; //uuid of this device	
	},
	
	//CordovaGeolocation
	"geolocation.getCurrentPosition" : function(onSuccess, onError, opts) {
		var fnSuccess = function(pos) {onSuccess.$call$1(pos);},
			fnError = function() {onError.$call$0();};
		navigator.geolocation.getCurrentPosition(fnSuccess, fnError, opts);
	},
	"geolocation.watchPostion" : function(onSuccess, onError, opts) {
		var fnSuccess = function(pos) {onSuccess.$call$1(pos);},
			fnError = function() {onError.$call$0();};
		return navigator.geolocation.watchPosition(fnSuccess, fnError, opts);
	},
	"geolocation.clearWatch" : function(watchID) {
		navigator.geolocation.clearWatch(watchID);
	},
	
	//CordovaNotification
	"notification.alert" : function(message, alertCallback, title, buttonName) {
		var fn = function() {alertCallback.$call$0();};
		navigator.notification.alert(message, fn, title, buttonName);
	},
	"notification.confirm" : function(message, confirmCallback, title, buttonLabels) {
		var fn = function(btn) {confirmCallback.$call$1(btn);};
		navigator.notification.confirm(message, fn, title, buttonLabels);
	},
	"notification.beep" : function(times) {
		navigator.notification.beep(times);
	},
	"notification.vibrate" : function(msecs) {
		navigator.notification.vibrate(msecs);
	}
};

//bridge for Dart to JavaScript(@see JSUtil.dart#initJSCall)
function overrideJSCallX() {
	if (window.Isolate && window.Isolate.$isolateProperties) {
		window.Isolate.$isolateProperties._JSCallX.prototype.exec$2 = //tricky, follow dart2js 
			function(name, args) { 
				return _natives[name].apply(this, args);
			};
	}
}
