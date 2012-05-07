interface Device {
	String name; //name of this device
	String cordovaVersion; //version of Cordove running on the device
	String platform; //operating system name of this device
	String version; //operating system version of this device
	String uuid; //uuid of this device

	bool ready; //indicate whether the device is ready for access
	
	void runOnReady(Function runFn, String nodeId); //register function to be run when device is ready
	
	Function deviceReadyFunction; //function to run when device is ready 
	
	final Accelerometer accelerometer; //accelerometer of this device
}
