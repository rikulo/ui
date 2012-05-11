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

	/** Whehter it is running on a mobile device.
	 * By mobile we mean the browser takes the full screen and non-sizable.
	 * If false, the browser is assumed to run on a desktop and
	 * it can be resized by the user.
	 */
	bool mobile = false;
	/** Whether it supports the touch events.
	 */
	bool touch = false;

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

	/** The screen size. */
	Size size;
	/** The prefix used for non-standard CSS property.
	 * For example, it is <code>-webkit-</code> for a Webkit-based browser.
	 * If you're not sure whether to prefix a CSS property, please use
	 * [css] instead.
	 */
	String cssPrefix;

	Browser() {
		_initBrowserInfo();
	}
	/** Returns the URL of this page.
	 * For example, "http://www.yourserver.com" and "file://".
	 */
	String get url() {
		final Location l = window.location;
		final StringBuffer sb = new StringBuffer();
		sb.add(l.protocol).add("//").add(l.hostname);
		if (l.port != "80" && !l.port.isEmpty())
			sb.add(':').add(l.port);
		return sb.toString();
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
			cssPrefix = "-webkit-";
			webkitVersion = version;

			if (bm(_rchrome)) {
				chrome = true;

				Match m = _randroid.firstMatch(ua);
				if (m !== null) {
					touch = mobile = android = true;
					androidVersion = _versionOf(m.group(1));
				}
			} else if (bm(_rsafari)) {
				safari = true;

				Match m = _rios.firstMatch(ua);
				if (m !== null) {
					touch = mobile = ios = true;
					iosVersion = _versionOf(m.group(1), '_');
				}
			}
		} else if (bm(_rmsie)) {
			cssPrefix = "-ms-";
			msie = true;
			touch = mobile = ua.indexOf("IEMobile") >= 0;
		} else if (ua.indexOf("compatible") < 0 && bm(_rmozilla)) {
			cssPrefix = "-moz-";
			name = "firefox";
			firefox = true;
		} else {
			cssPrefix = "";
			name = "unknown";
			version = 1.0;
		}

		final Element caveNode = document.query("#v-main");
		final DomQuery qcave = new DomQuery(caveNode !== null ? caveNode: window);
		size = new Size(qcave.innerWidth, qcave.innerHeight);
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

	/** Returns the corrected name for the given CSS property.
	 * For example, <code>css('text-size-adjust')</code> will return
	 * <code>'-webkit-text-size-adjust'</code> if the browser is Webkit-based.
	 * <p>Notice that the prefix is defined in [cssPrefix].
	 */
	String css(String name) {
		if (_nsnms === null) {
			_nsnms = new Set();
			//TODO: no need to check null when Dart can compare null with number
			//TODO: check other attributes for non-standard properties (like we did for box-sizing)
			//CONSIDER: auto-generate this file with a tool
			if ((browser.ios && browser.iosVersion < 5)
			|| (browser.android && browser.androidVersion < 2.4)
			|| browser.firefox)
				_nsnms.add('box-sizing');

			for (final String nm in const [
				'animation', 'animation-delay', 'animation-direction',
				'animation-duration', 'animation-fill-mode',
				'animation-iteration-count', 'animation-name',
				'animation-play-state', 'animation-timing-function',
				'appearance', 'backface-visibility',
				'background-composite',
				'border-after', 'border-after-color',
				'border-after-style', 'border-after-width',
				'border-before', 'border-before-color',
				'border-before-style', 'border-before-width',
				'border-end', 'border-end-color', 'border-end-style',
				'border-end-width', 'border-fit',
				'border-horizontal-spacing',
				'border-start', 'border-start-color',
				'border-start-style', 'border-start-width',
				'border-vertical-spacing',
				'box-align', 'box-direction', 'box-flex',
				'box-flex-group', 'box-lines', 'box-ordinal-group',
				'box-orient', 'box-pack', 'box-reflect',
				'color-correction', 'column-break-after',
				'column-break-before', 'column-break-inside',
				'column-count', 'column-gap', 'column-rule',
				'column-rule-color', 'column-rule-style',
				'column-rule-width', 'column-span', 'column-width',
				'columns', 'filter',
				'flex-align', 'flex-flow', 'flex-order',
				'flex-pack',
				'flow-from', 'flow-into',
				'font-feature-settings', 'font-size-delta',
				'font-smoothing',
				'highlight', 'hyphenate-character',
				'hyphenate-limit-after', 'hyphenate-limit-before',
				'hyphenate-limit-lines', 'hyphens',
				'line-box-contain', 'line-break', 'line-clamp',
				'locale', 'logical-height', 'logical-width',
				'margin-after', 'margin-after-collapse',
				'margin-before', 'margin-before-collapse',
				'margin-bottom-collapse', 'margin-collapse',
				'margin-end', 'margin-start', 'margin-top-collapse',
				'marquee', 'marquee-direction', 'marquee-increment',
				'marquee-repetition', 'marquee-speed', 'marquee-style',
				'mask', 'mask-attachment', 'mask-box-image',
				'mask-box-image-outset', 'mask-box-image-repeat',
				'mask-box-image-slice', 'mask-box-image-source',
				'mask-box-image-width', 'mask-clip', 'mask-composite',
				'mask-image', 'mask-origin', 'mask-position',
				'mask-position-x', 'mask-position-y', 'mask-repeat',
				'mask-repeat-x', 'mask-repeat-y', 'mask-size',
				'match-nearest-mail-blockquote-color',
				'max-logical-height', 'max-logical-width',
				'min-logical-height', 'min-logical-width',
				'nbsp-mode',
				'padding-after', 'padding-before', 'padding-end',
				'padding-start',
				'perspective', 'perspective-origin',
				'perspective-origin-x', 'perspective-origin-y',
				'region-break-after', 'region-break-before',
				'region-break-inside', 'region-overflow',
				'rtl-ordering', 'tap-highlight-color',
				'text-combine', 'text-decorations-in-effect',
				'text-emphasis', 'text-emphasis-color',
				'text-emphasis-position', 'text-emphasis-style',
				'text-fill-color', 'text-orientation',
				'text-security', 'text-size-adjust',
				'text-stroke', 'text-stroke-color', 'text-stroke-width',
				'transform', 'transform-origin', 'transform-origin-x',
				'transform-origin-y', 'transform-origin-z',
				'transform-style',
				'transition', 'transition-delay', 'transition-duration',
				'transition-property', 'transition-timing-function',
				'user-drag', 'user-modify', 'user-select',
				'wrap-shape', 'writing-mode']) {
				_nsnms.add(nm);
			}
		}
		return _nsnms.contains(name) ? "$cssPrefix$name": name;
	}
	static Set<String> _nsnms; //non-standard CSS property names
}

/** The current browser.
 */
Browser browser;
