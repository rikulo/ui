//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Apr 23, 2012  2:45:26 PM
// Author: tomyeh

/**
 * The simulator.
 */
class Simulator extends Activity {
	Size _simSize;
	Dashboard _dashboard;

	Simulator() {
		simulator = this;
		browser.size.width = window.innerWidth;
		browser.size.width = window.innerHeight;

		//TODO: the simulated size shall be based on what the user chose
		_setSimScreenSize(320, 480);
	}
	void _setSimScreenSize(int width, int height) {
		_simSize = new Size(width, height);

		CSSStyleDeclaration style = document.query("#v-main").style;
		style.width = "${width}px";
		style.height = "${height}px";
	}
	void _syncDashboardSize() {
		int left = simulatedSize.width + 40;
		Element dashNode = document.query("#v-dashboard");
		CSSStyleDeclaration style = dashNode.style;
		style.left = "${left}px";
		style.top = "0px";
		style.width = "${window.innerWidth - left}px";
		style.height = "${window.innerHeight}px";

		_dashboard.width = rootView.width = new DomQuery(dashNode).innerWidth;
		_dashboard.height = rootView.height = new DomQuery(dashNode).innerHeight;
		_dashboard.requestLayout();
	}

	/** Returns the simulated dimension of the device.
	 */
	Size get simulatedSize() => _simSize;

	void onCreate_() {
		_dashboard = new Dashboard();
		rootView.appendChild(_dashboard);
		_syncDashboardSize();

		window.on.resize.add((event) {
			_syncDashboardSize();
		});
	}
}
Simulator simulator;

void main() {
	new Simulator().run(nodeId: "v-dashboard");
}
