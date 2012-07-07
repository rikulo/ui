//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jul 5, 2012  11:11:13 AM
// Author: hernichen

/**
 * Bridge Dart to Google Analytics JavaScript APIs; 
 * see <https://developers.google.com/analytics/devguides/> for details.
 */

class GAnalytics {
  static final String _PUSH_COMMAND = "ga.0";
  static final String _CREATE_TRACKER = "ga.1";
  static final String _DISABLE_TRACKING = "ga.2";
  static final String _GET_TRACKER_BY_NAME = "ga.3";
  
  /**
   * Push a List as a command with arguments to be executed by the Google Analytics engine.
   * It returns the number of commands that failed to execute.
   *
   * e.g. create the default tracker and start page tracking.
   *
   *     GAnalytics.push(['_setAccount', 'UA-65432-1']);
   *     GAnalytics.push(['_trackPageview']);
   *
   * e.g. track change event of Switch.
   *
   *     new Switch().on.change.add((event) {
   *        GAnalytics.push(['_trackEvent', 'switch1', 'change']);
   *        ... //handle the event
   *     });
   *
   * see <https://developers.google.com/analytics/devguides/> and 
   * <https://developers.google.com/analytics/devguides/collection/gajs/methods/gaJSApi_gaq#_gaq.push>
   * for details.
   * 
   * + [command] the command with arguments in the List to be executed by Analytics engine asynchronously.
   */ 
  static int push(List command) {
    _initJSFunctions();
    return JSUtil.jsCall(_PUSH_COMMAND, [JSUtil.toJSArray(command)]);
  }
  
  /**
   * Push a Function to be executed by the Google Analytics engine. This is
   * useful for calling the tracking APIs that return values.
   * It returns the number of function that failed to execute.
   *
   * e.g. builds a linker URL and sets the href property for the link.
   *
   *    GAnalytics.pushFunction(() {
   *      PageTracker tracker = GAnalytics.getTrackerByName(); //default tracker
   *      AnchorElement link = query('#mylink');
   *      link.href = tracker.getLinkerUrl("http://www.myiframe.com/");
   *    });
   *
   * see <https://developers.google.com/analytics/devguides/> and 
   * <https://developers.google.com/analytics/devguides/collection/gajs/methods/gaJSApi_gaq#_gaq.push>
   * for details.
   * 
   * + [fn] the function to be executed by Analytics engine asynchronously.
   */
  static int pushFunction(Function fn) {
    _initJSFunctions();
    return JSUtil.jsCall(_PUSH_COMMAND, [JSUtil.toJSFunction(fn, 0)]);
  }
  
  /**
   * Set disable-tracking flag. After set to true, no tracking information of the spcified account 
   * on this page would be sent to analytics server.
   *
   * + [account] tracking account
   * + [flag] optional boolean flag to disable the tracking of the specified account in this page; default to true.
   */
  static void setDisableTracking(String account, [bool flag = true]) {
    _initJSFunctions();
    JSUtil.jsCall(_DISABLE_TRACKING, [account, flag]);
  }
  
  /**
   * Create a tracker with the specified name.
   * + [account] tracking account
   * + [name] tracker name; if not given, default to empty string.
   */
  static PageTracker createTracker(String account, [String name]) {
    return new PageTracker.from(JSUtil.jsCall(_CREATE_TRACKER, [account, name]));
  }
  
  /**
   * Returns the tracker with the specified name. If no tracker with the specified name, a new
   * tracker will be created automatically.
   * + [name] tracker name; if not given, default to empty string.
   */
  static PageTracker getTrackerByName([String name]) {
    return JSUtil.jsCall(_GET_TRACKER_BY_NAME, [name]);
  }
  
  static bool _initDone = false;
  static void _initJSFunctions() {
    if (_initDone) return;
    
    JSUtil.injectJavaScript('''
var _gaq = _gaq || [];
(function() {
  if (!window._gat) {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  }
})();      
    ''', false);
    JSUtil.newJSFunction(_PUSH_COMMAND, ["cmd"], "return _gaq.push(cmd);");
    JSUtil.newJSFunction(_CREATE_TRACKER, ["acc", "nm"], "return _gat._createTracker(acc, nm);");
    JSUtil.newJSFunction(_DISABLE_TRACKING, ["acc", "flag"], "window['ga-disable-'+acc] = flag;");
    JSUtil.newJSFunction(_GET_TRACKER_BY_NAME, ["nm"], "return _gat._getTrackerByName(nm);");
    
    _initDone = true;
  }
}
