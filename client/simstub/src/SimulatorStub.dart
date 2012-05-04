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
			case "setSize":
				_setSize(message);
				break;
		}
	}
	void _setSize(SimulatorMessage message) {
		final DomQuery qcave = new DomQuery(document.query("#v-main"));
		browser.size.width = qcave.innerWidth;
		browser.size.height = qcave.innerHeight;

		//Unable to dispatch event to window, so we invoke requestLayout directly
		//window.on.deviceOrientation.dispatch(new Event("deviceOrientation"));
		View rootView = activity.rootView;
		if (rootView !== null) {
			rootView.width = browser.size.width;
			rootView.height = browser.size.height;

			activity.rootView.requestLayout();
		}
	}
}
