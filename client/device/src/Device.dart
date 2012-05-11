//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 2, 2012  12:32:56 PM
// Author: henrichen

interface Device {
	String name; //name of this device
	String cordovaVersion; //version of Cordove running on the device
	String platform; //operating system name of this device
	String version; //operating system version of this device
	String uuid; //uuid of this device

	ThenCallback readyFunction; //function called when the device is ready
	
	final Accelerometer accelerometer; //accelerometer of this device
	final Camera camera; //camera of this device
}
