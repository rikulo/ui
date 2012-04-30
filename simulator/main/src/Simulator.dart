//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Apr 23, 2012  2:45:26 PM
// Author: tomyeh

/**
 * The simulator.
 */
class Simulator extends Activity {
	Size _simSize;
	bool _horizontal;
	/** The dashboard. */
	Dashboard dashboard;
	/** The service for handling the communication between the simulator
	 * and the application.
	 */
	SimulatorService service;

	Simulator() {
		simulator = this;
		service = new SimulatorService();

		browser.size.width = window.innerWidth;
		browser.size.height = window.innerHeight;

		//TODO: the simulated size shall be based on what the user chose
		_setSimulatedSize(320, 480, false);
	}
	//@Override
	void onCreate_() {
		dashboard = new Dashboard();
		rootView.appendChild(dashboard);
		_syncDashboardSize();

		window.on.resize.add((event) {
			_syncDashboardSize();
		});
	}
	//@Override
	void mount_() {
		//does nothing
	}
	/** Returns the simulated dimension of the device.
	 */
	Size get simulatedSize() => _simSize;

	void setOrient(bool horizontal) {
		setSimulatedSize(_simSize.height, _simSize.width, horizontal);
	}
	void setSimulatedSize(int width, int height, bool horizontal) {
		_setSimulatedSize(width, height, horizontal);
		_syncDashboardSize();

		simulatorQueue.send({'name': 'setSize', 'orient': horizontal});
	}

	void _setSimulatedSize(int width, int height, bool horizontal) {
		_simSize = new Size(width, height);
		_horizontal = horizontal;

		CSSStyleDeclaration style = document.query("#v-main").style;
		style.width = StringUtil.px(width);
		style.height = StringUtil.px(height);

		Element simNode = document.query("#v-simulator");
		if (_horizontal) {
			style = simNode.query(".v-top").style;
			style.height = "0";
			style = simNode.query(".v-bottom").style;
			style.height = "0";
			style = simNode.query(".v-left").style;
			style.width = "20px";
			style = simNode.query(".v-right").style;
			style.width = "60px";
		} else {
			style = simNode.query(".v-top").style;
			style.height = "20px";
			style = simNode.query(".v-bottom").style;
			style.height = "60px";
			style = simNode.query(".v-left").style;
			style.width = "0";
			style = simNode.query(".v-right").style;
			style.width = "0";
		}
	}
	void _syncDashboardSize() {
		int left = simulatedSize.width + (_horizontal ? 110: 40);
		Element dashNode = document.query("#v-dashboard");
		CSSStyleDeclaration style = dashNode.style;
		style.left = StringUtil.px(left);
		style.top = "0px";
		style.width = StringUtil.px(window.innerWidth - left);
		style.height = StringUtil.px(window.innerHeight);

		dashboard.width = rootView.width = new DomQuery(dashNode).innerWidth;
		dashboard.height = rootView.height = new DomQuery(dashNode).innerHeight;
		dashboard.requestLayout();
	}
}
Simulator simulator;

void main() {
	new Application(name: "Simulator", inSimulator: false);
	new Simulator().run(nodeId: "v-dashboard");
}
