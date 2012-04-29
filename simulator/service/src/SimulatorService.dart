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
		print("$message");
	}
}
