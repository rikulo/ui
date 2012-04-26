//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 12, 2012  9:26:04 AM
// Author: tomyeh

typedef bool _BrowserMatch(RegExp regex);

/**
 * The browser.
 */
class Browser {
	static final RegExp _rwebkit = const RegExp(@"(webkit)[ /]([\w.]+)"),
		_rsafari = const RegExp(@"(safari)[ /]([\w.]+)"),
		_rchrome = const RegExp(@"(chrome)[ /]([\w.]+)"),
		_rmsie = const RegExp(@"(msie) ([\w.]+)"),
		_rmozilla = const RegExp(@"(mozilla)(?:.*? rv:([\w.]+))?"),
		_rios = const RegExp(@"OS[ /]([\w_]+) like Mac OS"),
		_randroid = const RegExp(@"android[ /]([\w.]+)");

	/** The browser's name. */
	String name;
	/** The browser's version. */
	double version;

	/** Whether it is Safari. */
	bool safari = false;
	/** Whether it is Chrome. */
	bool chrome = false;
	/** Whether it is Internet Explorer. */
	bool msie = false;
	/** Whether it is Firefox. */
	bool firefox = false;
	/** Whether it is WebKit-based. */
	bool webkit = false;

	/** Whether it is running on iOS. */
	bool ios = false;
	/** Whether it is running on Android. */
	bool android = false;

	/** Whether it is running on a simulator. */
	bool inSimulator = false;

	/** The webkit's version if this is a webkit-based browser, or null
	 * if it is not webkit-based.
	 */
	double webkitVersion;
	/** The version of iOS if it is running on iOS, or null if not.
	 */
	double iosVersion;
	/** The version of Android if it is running on Android, or null if not.
	 */
	double androidVersion;
	Size size;

	Browser() {
		_initBrowserInfo();
	}
	String toString() {
		return "$name(v$version, $size)";
	}
	void _initBrowserInfo() {
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
			webkit = true;
			webkitVersion = version;

			if (bm(_rchrome)) {
				chrome = true;

				Match m = _randroid.firstMatch(ua);
				if (m !== null) {
					android = true;
					androidVersion = _versionOf(m.group(1));
				}
			} else if (bm(_rsafari)) {
				safari = true;

				Match m = _rios.firstMatch(ua);
				if (m !== null) {
					ios = true;
					iosVersion = _versionOf(m.group(1), '_');
				}
			}
		} else if (bm(_rmsie)) {
			msie = true;
		} else if (ua.indexOf("compatible") < 0 && bm(_rmozilla)) {
			name = "firefox";
			firefox = true;
		} else {
			name = "unknown";
			version = 1.0;
		}

		final Element simNode = document.query("#v-main");
		inSimulator = simNode !== null;
		final DomQuery simQuery = new DomQuery(inSimulator ? simNode: window);
		size = new Size(simQuery.innerWidth, simQuery.innerHeight);
	}
	static double _versionOf(String version, [String separator='.']) {
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

/** The current browser.
 */
Browser browser;
