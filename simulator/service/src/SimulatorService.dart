//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Sat, Apr 28, 2012 11:02:48 PM
// Author: tomyeh

/**
 * The simulator server handling the messages for communication between the simulator
 * and the application.
 * <p>A command is an instance of [SimulatorMessage].
 */
class SimulatorService {
	SimulatorService() {
		simulatorMessageQueue.add((message) {
			_serve(message);
		});
	}
	void _serve(SimulatorMessage message) {
		final data = message["data"];
		switch (message["name"]) {
		case "log":
			_log(data);
			break;
		}
	}
	void _log(String msg) {
		if (_logNode === null) {
			_logNode = document.query("#v-dashboard .v-dashboard-log");
			if (_logNode === null) { //not ready yet
				print(msg);
				return;
			}
		}
		_logNode.insertAdjacentHTML("beforeEnd", StringUtil.encodeXML(msg));
	}
	Element _logNode;
}
