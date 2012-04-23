//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Apr 23, 2012  2:45:26 PM
// Author: tomyeh

/**
 * The simulator.
 */
class Simulator extends Activity {
	Size _scrnSize;

	Simulator() {
		simulator = this;

		//TODO: the screen resolution shall be based on the device the user chose
		_setScreenSize(320, 480);
		_syncDashboardSize();
	}
	void _setScreenSize(int width, int height) {
		_scrnSize = new Size(width, height);

		CSSStyleDeclaration style = document.query("#v-main").style;
		style.width = "${width}px";
		style.height = "${height}px";
	}
	void _syncDashboardSize() {
		int left = screenSize.width + 50;
		CSSStyleDeclaration style = document.query("#v-dashboard").style;
		style.left = "${left}px";
		style.top = "0px";
		style.width = "${window.innerWidth - left}px";
		style.height = "${window.innerHeight}px";
	}

	/** Returns the screen's dimension.
	 */
	Size get screenSize() => _scrnSize;

	void onCreate_() {
		window.on.resize.add((event) {
			_syncDashboardSize();
		});
		TextView text = new TextView("Hello Simulator!");
		rootView.appendChild(text);
	}
}
Simulator simulator;

void main() {
	new Simulator().run(nodeId: "v-dashboard");
}
