//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 27, 2012  10:25:10 AM
// Author: hernichen

#library("rikulo:cordova");

#import("dart:core");
#import("dart:html");
#import("dart:json");

#import("../app/app.dart");
#import("../util/util.dart");
#import("../device/device.dart");
#import("../device/impl/impl.dart");
#import("../device/accelerometer/accelerometer.dart");
#import("../device/camera/camera.dart");
#import("../device/capture/capture.dart");
#import("../device/compass/compass.dart");
#import("../device/connection/connection.dart");
#import("../device/contacts/contacts.dart");
#import("../device/geolocation/geolocation.dart");
#import("../device/notification/notification.dart");

#source("src/JSUtil.dart");
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
