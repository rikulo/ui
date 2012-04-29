//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Sat, Apr 28, 2012 10:45:13 PM
// Author: tomyeh

/**
 * A message used to communicate between the simulator and the application
 * running on the simulator.
 */
class SimulatorMessage extends HashMapImplementation<String, Object> {
	SimulatorMessage(String name, var data) {
		this["name"] = name;
		this["data"] = data;
	}
	/** Returns the message's name.
	 */
	String get name() => this["name"];
	/** Returns the message's data.
	 */
	String get data() => this["data"];

	String toString() => "SimulatorMessage($name, $data)";
}

MessageQueue<SimulatorMessage> get simulatorMessageQueue() {
	if (_cachedSMQ == null) {
		_cachedSMQ = new MessageQueue();
		_cachedSBMB = new BrowserMessageBridge();
		_cachedSBMB.subscribe(_cachedSMQ);
	}
	return _cachedSMQ;
}
MessageQueue<SimulatorMessage> _cachedSMQ;
BrowserMessageBridge<SimulatorMessage> _cachedSBMB;