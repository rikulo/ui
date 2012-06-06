//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 2, 2012  12:32:56 PM
// Author: henrichen

interface Device {
  String name; //name of this device
  String cordovaVersion; //version of Cordove running on the device
  String platform; //operating system name of this device
  String version; //operating system version of this device
  String uuid; //uuid of this device

  Task readyFunction; //function called when the device is ready
  
  final Accelerometer accelerometer; //accelerometer of this device
  final Camera camera; //camera of this device
  final Compass compass; //compass of this device
  final Contacts contacts; //contacts of this device
  final XGeolocation geolocation; //geolocation of this device
  final XNotification notification; //notification facility of this device
}

/** Enable the device accesibility.
 *
 * <p>Notice that this method will instantiate the default application if
 * the application is not instantiated. Thus, if you subclass the application,
 * you shall instantiate it before invoking this method, such as
 * <pre><code>new FooApplication();
 *initSimulator();</code></pre>
 *
 * <p>This method can be called multiple times, but the second invocation
 * will be ignored.
 */
void enableDeviceAccess() {
  //Initilize Cordova device if not in simulator
  if (device === null) {
    if (application.inSimulator)
      throw const SystemException("enableSimulator() must be called first");
    device = new CordovaDevice();
  }
}
Device device; //singleton device per application
