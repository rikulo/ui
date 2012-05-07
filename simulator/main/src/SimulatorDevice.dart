//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 2, 2012  09:12:33 AM
// Author: henrichen

/**
 * A simulator device implementation.
 */
class SimulatorDevice implements Device {
	String name = "Simulator"; //name of this device
	String cordovaVersion = "N/A"; //version of Cordova running on the device
	String platform = "Simulator"; //operating system name of this device
	String version = "1.0"; //operating system version of this device
	String uuid = "1234567890"; //uuid of this device

	ThenCallback readyFunction;
	
	Accelerometer accelerometer;
	
	SimulatorDevice() {
		accelerometer = new SimulatorAccelerometer();
	}
}
