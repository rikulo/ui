//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 2, 2012  12:32:56 PM
// Author: henrichen

/** The device.
 */
interface Device {
  /** The name of this device */
  String name;
  /** The version of Cordove running on the device. */
//  String cordovaVersion;
  /** The operating system name of this device. */
  String platform;
  /** The operating system version of this device. */
  String version;
  /** The uuid of this device. */
  String uuid;

  Task readyFunction; //function called when the device is ready

  /** The accelerometer of this device. */
  final Accelerometer accelerometer;
  /** The camera of this device.*/
  final Camera camera;
  /** The capture. */
  final Capture capture;
  /** The compass of this device. */
  final Compass compass;
  /** The connection of this device. */
  final Connection connection;
  /** The contacts of this device. */
  final Contacts contacts;
  /** The geolocation of this device. */
  final XGeolocation geolocation;
  /** The notification facility of this device. */
  final XNotification notification;
}

/** Enable the device accesibility.
 *
 * Notice that this method will instantiate the default application if
 * the application is not instantiated. Thus, if you subclass the application,
 * you shall instantiate it before invoking this method, such as
 *
 *     new FooApplication();
 *     initSimulator();
 *
 * This method can be called multiple times, but the second invocation
 * will be ignored.
 *
 * + [serviceURI] the URI of the device access service uri; e.g. "cordova.js".
 * + [serviceNames] the name of the services you want to enable; e.g. "accelerometer", 
 * "camera", "capture", "compass", "connection", "contacts", "geolocation", "notification"; 
 *  default enable all device services. 
 */
void enableDeviceAccess([String serviceURI = "cordova.js", 
  List<String> serviceNames = const ["accelerometer", "camera", "capture", "compass", "connection", "contacts", "geolocation", "notification"]]) {
  //Initilize Cordova device if not in simulator
  if (device === null) {
    if (application.inSimulator)
      throw const SystemException("enableSimulator() must be called first");
    device = new CordovaDevice(serviceURI, serviceNames);
  }
}
Device device; //singleton device per application
