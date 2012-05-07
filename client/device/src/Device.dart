interface Device {
	String name; //name of this device
	String cordovaVersion; //version of Cordove running on the device
	String platform; //operating system name of this device
	String version; //operating system version of this device
	String uuid; //uuid of this device

	ThenCallback readyFunction; //function called when the device is ready
	
	final Accelerometer accelerometer; //accelerometer of this device
}
