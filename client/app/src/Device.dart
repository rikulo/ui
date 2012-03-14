//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 12, 2012  9:26:04 AM
// Author: tomyeh

typedef bool _BrowserMatch(RegExp regex);

/**
 * The device;
 */
class Device {
	static final RegExp _rwebkit = const RegExp(@"(webkit)[ /]([\w.]+)"),
		_rsafari = const RegExp(@"(safari)[ /]([\w.]+)"),
		_rchrome = const RegExp(@"(chrome)[ /]([\w.]+)"),
		_rmsie = const RegExp(@"(msie) ([\w.]+)"),
		_rmozilla = const RegExp(@"(mozilla)(?:.*? rv:([\w.]+))?"),
		_rios = const RegExp(@"OS[ /]([\w_]+) like Mac OS"),
		_randroid = const RegExp(@"android[ /]([\w.]+)");

	/** The brower's information. */
	VersionInfo browser;
	double safari;
	double chrome;
	double webkit;
	double mozilla;
	double msie;
	double ios;
	double android;
	ScreenInfo screen;

	Device() {
		_initBrowserInfo();
	}
	void _initBrowserInfo() {
		String name;
		double version;
		final String ua = window.navigator.userAgent.toLowerCase();
		final _BrowserMatch bm = (RegExp regex) {
			Match m = regex.firstMatch(ua);
			if (m !== null) {
				name = m.group(1);
				version = _versionOf(m.group(2));
				return true;
			}
			return false;
		};

		if (bm(_rwebkit)) {
			webkit = version;

			if (bm(_rchrome)) {
				chrome = version;

				Match m = _randroid.firstMatch(ua);
				if (m !== null)
					android = _versionOf(m.group(1));

			} else if (bm(_rsafari)) {
				safari = version;

				Match m = _rios.firstMatch(ua);
				if (m !== null)
					ios = _versionOf(m.group(1), '_');
			}

		} else if (bm(_rmsie)) {
				msie = version;

		} else {
			if (ua.indexOf("compatible") < 0 && bm(_rmozilla)) {
				mozilla = version;
			}

			if (name === null) {
				name = "unknown";
				version = 1.0;
			}
		}

		browser = new VersionInfo(name, version);
		screen = new ScreenInfo(window.innerWidth, window.innerHeight);
	}
	static double _versionOf(String version, [char separator='.']) {
		int j = version.indexOf(separator);
		if (j >= 0) {
			j = version.indexOf(separator, j + 1);
			if (j >= 0)
				version = version.substring(0, j);
		}
		try {
			return Math.parseDouble(version);
		} catch (var t) {
			return 1.0; //ignore it
		}
	}
}

class VersionInfo {
	/** The browser's name, such as safari, chrome, mozilla and msie.
	 */
	final String name;
	/** The browser's version.
	 */
	final double version;

	const VersionInfo(this.name, this.version);
}
/** The screen information. */
class ScreenInfo extends Size {
	ScreenInfo(int width, int height) : super(width, height) {
	}
}

/** The current device.
 */
Device device;
