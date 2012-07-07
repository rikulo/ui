//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jul 5, 2012  11:11:13 AM
// Author: hernichen

/** 
 * Bridge Dart to Google Analytics JavaScript Object *Tracker*; 
 * see <https://developers.google.com/analytics/devguides/> for details.
 *
 * This is used when you need to write function to push into analytics command queue. 
 */
class PageTracker implements JSAgent {
  static final _GET_NAME = "pgtrk.0";
  static final _GET_ACCOUNT = "pgtrk.1";
  static final _GET_VERSION = "pgtrk.2";
  static final _GET_VISITOR_VAR = "pgtrk.3";
  static final _GET_LINKER_URL = "pgtrk.4";
  static final _GET_CLIENT_INFO = "pgtrk.5";
  static final _GET_DETECT_FLASH = "pgtrk.6";
  static final _GET_DETECT_TITLE = "pgtrk.7";
  
  var _tracker;
  PageTracker.from(this._tracker) {
    _initJSFunctions();
  }
  
  /** Returns the name of the tracker.
   * e.g.
   *    GAnalytics.pushFunction(() {
   *      PageTracker tracker = GAnalytics.getTrackerByName(); //default tracker
   *      String name = tracker.getName();
   *    });
   */
  String getName() {
    return JSUtil.jsCall(_GET_NAME, [_tracker]);
  }
  
  /** Returns the analytics account ID for this tracker.
   * e.g.
   *    GAnalytics.pushFunction(() {
   *      PageTracker tracker = GAnalytics.getTrackerByName(); //default tracker
   *      String account = tracker.getAccount();
   *    });
   */
  String getAccount() {
    return JSUtil.jsCall(_GET_ACCOUNT, [_tracker]);
  }
  
  /** Returns the analytics version 
   * e.g.
   *    GAnalytics.pushFunction(() {
   *      PageTracker tracker = GAnalytics.getTrackerByName(); //default tracker
   *      String version = tracker.getVersion();
   *    });
   */
  String getVersion() {
    return JSUtil.jsCall(_GET_VERSION, [_tracker]);
  }
  
  /** Returns visitor level custom variable value assigned for the specified [index].
   * e.g.
   *    GAnalytics.pushFunction(() {
   *      PageTracker tracker = GAnalytics.getTrackerByName(); //default tracker
   *      String name = tracker.getVisitorCustomVar(1);
   *    });
   */
  String getVisitorCustomVar(int index) {
    return JSUtil.jsCall(_GET_VISITOR_VAR, [_tracker, index]);
  }
  
  /** Returns a string of all GATC cookie data from the initiating link by appending it to the URL parameter.
   * e.g.
   *    GAnalytics.pushFunction(() {
   *      PageTracker tracker = GAnalytics.getTrackerByName(); //default tracker
   *      String linkerUrl = tracker.getLinkerUrl("http://www.myiframe.com/");
   *    });
   */
  String getLinkerUrl(String targetUrl, bool useHash) {
    return JSUtil.jsCall(_GET_LINKER_URL, [_tracker, targetUrl, "${useHash}"]);
  }
  
  /** Returns whether the browser tracking module is enabled.
   * e.g.
   *    GAnalytics.pushFunction(() {
   *      PageTracker tracker = GAnalytics.getTrackerByName(); //default tracker
   *      bool clientInfo = tracker.getClientInfo();
   *    });
   */
  bool getClientInfo() {
    return JSUtil.jsCall(_GET_CLIENT_INFO, [_tracker]);
  }
  
  /** Returns whether detect Flash.
   * e.g.
   *    GAnalytics.pushFunction(() {
   *      PageTracker tracker = GAnalytics.getTrackerByName(); //default tracker
   *      bool detectFlash = tracker.getDetectFlash();
   *    });
   */
  bool getDetectFlash() {
    return JSUtil.jsCall(_GET_DETECT_FLASH, [_tracker]);
  }
  
  /** Returns whether detect title.
   * e.g.
   *    GAnalytics.pushFunction(() {
   *      PageTracker tracker = GAnalytics.getTrackerByName(); //default tracker
   *      bool dectectTitle = tracker.getDetectTitle();
   *    });
   */
  bool getDetectTitle() {
    return JSUtil.jsCall(_GET_DETECT_TITLE, [_tracker]);
  }
  
  toJSObject() {
    return _tracker;
  }
  
  static bool _initDone = false;
  void _initJSFunctions() {
    if (_initDone) return;
    
    JSUtil.newJSFunction(_GET_NAME, ["tracker"], "return tracker._getName();");
    JSUtil.newJSFunction(_GET_ACCOUNT, ["tracker"], "return tracker._getAccount();");
    JSUtil.newJSFunction(_GET_VERSION, ["tracker"], "return tracker._getVersion();");
    JSUtil.newJSFunction(_GET_VISITOR_VAR, ["tracker", "idx"], "return tracker._getVisitorCustomVar(idx);");
    JSUtil.newJSFunction(_GET_LINKER_URL, ["tracker", "url", "useHash"], "return tracker._getLinkerUrl(url,useHash);");
    JSUtil.newJSFunction(_GET_CLIENT_INFO, ["tracker"], "return tracker._getClientInfo();");
    JSUtil.newJSFunction(_GET_DETECT_FLASH, ["tracker"], "return tracker._getDetectFlash();");
    JSUtil.newJSFunction(_GET_DETECT_TITLE, ["tracker"], "return tracker._getDetectTitle();");
    
    _initDone = true;
  }
}
