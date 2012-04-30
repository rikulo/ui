//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Apr 30, 2012 10:10:20 AM
// Author: tomyeh

/**
 * The simulator stub handles the request sent from the simulator.
 * <p>Note: it is part of an application. Don't use this class in the simulator.
 * The simulator shall use SimulatorService instead.
 */
class SimulatorStub {
	SimulatorStub() {
		simulatorQueue.add((message) {
			_serve(message);
		});
	}

	void _serve(SimulatorMessage message) {
		final data = message["data"];
		switch (message["name"]) {
		case "changeOrient":
			
			break;
		case "setSize":
			print('${data["width"]}, ${data["height"]}'); //TODO
			break;
		}
	}
}
