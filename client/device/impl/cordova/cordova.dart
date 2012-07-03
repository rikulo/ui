//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 27, 2012  10:25:10 AM
// Author: hernichen

#library("rikulo:device/impl/cordova");

#import("dart:html");
#import("dart:json");

#import("../../../app/app.dart");
#import("../../../util/util.dart");
#import("../../../html/html.dart");
#import("../../device.dart");
#import("../../accelerometer/accelerometer.dart");
#import("../../camera/camera.dart");
#import("../../capture/capture.dart");
#import("../../compass/compass.dart");
#import("../../connection/connection.dart");
#import("../../contacts/contacts.dart");
#import("../../geolocation/geolocation.dart");
#import("../../notification/notification.dart");

#source("src/CordovaDevice.dart");
#source("src/CordovaAccelerometer.dart");
#source("src/CordovaCamera.dart");
#source("src/CordovaCapture.dart");
#source("src/CordovaCompass.dart");
#source("src/CordovaConnection.dart");
#source("src/CordovaContact.dart");
#source("src/CordovaContacts.dart");
#source("src/CordovaGeolocation.dart");
#source("src/CordovaMediaFile.dart");
#source("src/CordovaNotification.dart");
