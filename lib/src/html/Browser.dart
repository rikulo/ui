//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 12, 2012  9:26:04 AM
// Author: tomyeh
part of rikulo_html;

typedef bool _BrowserMatch(RegExp regex);

/**
 * The browser.
 */
class Browser {
  // all RegExp shall be lower case here
  static final RegExp _rwebkit = new RegExp(r"(webkit)[ /]([\w.]+)"),
    _rsafari = new RegExp(r"(safari)[ /]([\w.]+)"),
    _rchrome = new RegExp(r"(chrome)[ /]([\w.]+)"),
    _rmsie = new RegExp(r"(msie) ([\w.]+)"),
    _rmozilla = new RegExp(r"(mozilla)(?:.*? rv:([\w.]+))?"),
    _ropera = new RegExp(r"(opera)(?:.*version)?[ /]([\w.]+)"),
    _rios = new RegExp(r"os[ /]([\w_]+) like mac os"),
    _randroid = new RegExp(r"android[ /]([\w.]+)");

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
  /** Whether it is Opera. */
  bool opera = false;

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
  /** Whether it supports the touch gestures.
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

  /** The browser size (outer), including the margins and borders.
   *
   * For the inner size, please use [innerSize] instead.
   */
  Size size;

  Browser() {
    _initBrowserInfo();
  }
  /** Returns the URL of this page.
   * For example, "http://www.yourserver.com" and "file://".
   */
  String get url {
    final l = window.location;
    final sb = new StringBuffer();
    sb..write(l.protocol)..write("//")..write(l.hostname);
    if (l.port != "80" && !l.port.isEmpty)
      sb..write(':')..write(l.port);
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
      webkitVersion = version;

      if (bm(_rchrome)) {
        chrome = true;

      } else if (bm(_rsafari)) {
        safari = true;

      }
    } else if (bm(_rmsie)) {
      msie = true;
      touch = mobile = ua.indexOf("IEMobile") >= 0;
    } else if (bm(_ropera)) {
      opera = true;
    } else if (ua.indexOf("compatible") < 0 && bm(_rmozilla)) {
      name = "firefox"; //rename it
      firefox = true;
    } else {
      name = "unknown";
      version = 1.0;
    }

    final q = new WindowAgent(window);
    size = new Size(q.innerWidth, q.innerHeight);
  }
  static double _versionOf(String version, [String separator='.']) {
    int j = version.indexOf(separator);
    if (j >= 0) {
      j = version.indexOf(separator, j + 1);
      if (j >= 0)
        version = version.substring(0, j);
    }
    try {
      return double.parse(version);
    } catch (e) {
      return 1.0; //ignore it
    }
  }

  /** Updates the browser's size. It is called when the browser's size
   * is changed (including device's orientation is changed).
   *
   * Notice that it is called automatically, so the application rarely need to call it
   * unless it changed the margin or border of `document.body`.
   */
  void updateSize() {
    final q = new WindowAgent(window);
    size = new Size(q.innerWidth, q.innerHeight);
  }
}

/** The browser information.
 */
final Browser browser = new Browser();
