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
		browser.inSimulator = false;
		browser.size.width = window.innerWidth;
		browser.size.height = window.innerHeight;

		viewConfig.reset();
		viewConfig.uuidPrefix = "_v_";

		//TODO: the simulated size shall be based on what the user chose
		_setSimScreenSize(320, 480);
	}
	//@Override
	void onCreate_() {
		_dashboard = new Dashboard();
		rootView.appendChild(_dashboard);
		_syncDashboardSize();

		window.on.resize.add((event) {
			_syncDashboardSize();
		});
	}

	/** Returns the simulated dimension of the device.
	 */
	Size get simulatedSize() => _simSize;

	void _setSimScreenSize(int width, int height) {
		_simSize = new Size(width, height);

		CSSStyleDeclaration style = document.query("#v-main").style;
		style.width = StringUtil.px(width);
		style.height = StringUtil.px(height);
	}
	void _syncDashboardSize() {
		int left = simulatedSize.width + 40;
		Element dashNode = document.query("#v-dashboard");
		CSSStyleDeclaration style = dashNode.style;
		style.left = StringUtil.px(left);
		style.top = "0px";
		style.width = StringUtil.px(window.innerWidth - left);
		style.height = StringUtil.px(window.innerHeight);

		_dashboard.width = rootView.width = new DomQuery(dashNode).innerWidth;
		_dashboard.height = rootView.height = new DomQuery(dashNode).innerHeight;
		_dashboard.requestLayout();
	}
}
Simulator simulator;

void main() {
	new Simulator().run(nodeId: "v-dashboard");
}
