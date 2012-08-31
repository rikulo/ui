//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 12, 2012  9:26:04 AM
// Author: tomyeh

typedef bool _BrowserMatch(RegExp regex);

/**
 * The browser.
 */
class Browser {
  // all RegExp shall be lower case here
  static final RegExp _rwebkit = const RegExp(@"(webkit)[ /]([\w.]+)"),
    _rsafari = const RegExp(@"(safari)[ /]([\w.]+)"),
    _rchrome = const RegExp(@"(chrome)[ /]([\w.]+)"),
    _rmsie = const RegExp(@"(msie) ([\w.]+)"),
    _rmozilla = const RegExp(@"(mozilla)(?:.*? rv:([\w.]+))?"),
    _rios = const RegExp(@"os[ /]([\w_]+) like mac os"),
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

  Browser() {
    _initBrowserInfo();
  }
  /** Returns the URL of this page.
   * For example, "http://www.yourserver.com" and "file://".
   */
  String get url {
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
      if (m != null) {
        name = m.group(1);
        version = _versionOf(m.group(2));
        return true;
      }
      return false;
    };

    // os detection
    Match m2;
    if ((m2 = _randroid.firstMatch(ua)) != null) {
      touch = mobile = android = true;
      androidVersion = _versionOf(m2.group(1));
    } else if ((m2 = _rios.firstMatch(ua)) != null) {
      touch = mobile = ios = true;
      iosVersion = _versionOf(m2.group(1), '_');
    }
    
    if (bm(_rwebkit)) {
      webkit = true;
      CSS.prefix = "-webkit-";
      webkitVersion = version;

      if (bm(_rchrome)) {
        chrome = true;

      } else if (bm(_rsafari)) {
        safari = true;

      }
    } else if (bm(_rmsie)) {
      CSS.prefix = "-ms-";
      msie = true;
      touch = mobile = ua.indexOf("IEMobile") >= 0;
    } else if (ua.indexOf("compatible") < 0 && bm(_rmozilla)) {
      CSS.prefix = "-moz-";
      name = "firefox";
      firefox = true;
    } else {
      CSS.prefix = "";
      name = "unknown";
      version = 1.0;
    }

		//We don't consider v-main here since Activity will handle it
    final DOMQuery qcave = new DOMQuery(window);
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
      return parseDouble(version);
    } catch (e) {
      return 1.0; //ignore it
    }
  }
}

/** The current browser.
 */
Browser browser;
