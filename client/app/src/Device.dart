//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 12, 2012  9:26:04 AM
// Author: tomyeh

/**
 * The device;
 */
class Device {
	static final RegExp _rwebkit = const RegExp(@".*(webkit)[ /]([\w.]+).*"),
		_rsafari = const RegExp(@".*(safari)[ /]([\w.]+).*"),
		_rchrome = const RegExp(@".*(chrome)[ /]([\w.]+).*"),
		_rmsie = const RegExp(@".*(msie) ([\w.]+).*"),
		_rmozilla = const RegExp(@".*(mozilla)(?:.*? rv:([\w.]+))?.*");

	/** The brower's information. */
	Browser browser;
	double safari;
	double chrome;
	double webkit;
	double mozilla;
	double ie;

	Device() {
		_initBrowserInfo();
	}
	void _initBrowserInfo() {
		String name;
		double version;
		final String ua = window.navigator.userAgent.toLowerCase();
		Match m = _rwebkit.firstMatch(ua);
		if (m !== null) {
			webkit = version = _getVersion(m);

			m = _rchrome.firstMatch(ua);
			if (m !== null) {
				name = "chrome";
				chrome = version = _getVersion(m);
			} else {
				m = _rsafari.firstMatch(ua);
				if (m !== null) {
					name = "safari";
					safari = version = _getVersion(m);
				} else {
					name = "webkit";
				}
			}
		} else {
			m = _rmsie.firstMatch(ua);
			if (m !== null) {
				name = "ie";
				ie = version = _getVersion(m);
			} else if (ua.indexOf("compatible") < 0) {
				m = _rmozilla.firstMatch(ua);
				if (m !== null) {
					name = "mozilla";
					mozilla = version = _getVersion(m);
				}
			}

			if (name === null) {
				name = "unknown";
				version = 1.0;
			}
		}
		browser = new Browser(name, version);
	}
	static double _getVersion(Match m) {
		return m.groupCount() < 2 ? 1/*ignore it*/: _versionOf(m.group(2));
	}
	static double _versionOf(String version) {
		int j = version.indexOf('.');
		if (j >= 0) {
			j = version.indexOf('.', j + 1);
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

class Browser {
	/** The browser's name, such as safari, chrome, mozilla and ie.
	 */
	final String name;
	/** The browser's version.
	 */
	final double version;

	const Browser(this.name, this.version);
}

/** The current device.
 */
Device get device() {
	if (_device === null)
		_device = new Device();
	return _device;
}
Device _device;
