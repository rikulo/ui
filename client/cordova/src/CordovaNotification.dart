//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  03:51:12 PM
// Author: henrichen

/**
 * A Cordova notification implementation.
 */
class CordovaNotification implements XNotification {
  static final String _ALERT = "notification.alert";
  static final String _CONFIRM = "notification.confirm";
  static final String _BEEP = "notification.beep";
  static final String _VIBRATE = "notification.vibrate";
  
  CordovaNotification() {
    _initJSFunctions();
  }
  alert(String message, NotificationAlertCallback alertCallback, [String title, String buttonName]) {
    if (title === null) title = "Alert";
    if (buttonName === null) buttonName = "OK";
    jsCall(_ALERT, [message, alertCallback, title, buttonName]);
  }
  
  confirm(String message, NotificationConfirmCallback confirmCallback, [String title, String buttonLabels]) {
    if (title === null) title = "Confirm";
    if (buttonLabels === null) buttonLabels = "OK,Cancel";
    jsCall(_CONFIRM, [message, confirmCallback, title, buttonLabels]);
  }
  
  beep(int times) {
    jsCall(_BEEP, [times]);
  }
  
  vibrate(int milliseconds) {
    jsCall(_VIBRATE, [milliseconds]);
  }
  
  void _initJSFunctions() {
    newJSFunction(_ALERT, ["message", "alertCallback", "title", "buttonName"], '''
      var fn = function() {alertCallback.\$call\$0();};
      navigator.notification.alert(message, fn, title, buttonName);
    ''');
    newJSFunction(_CONFIRM, ["message", "confirmCallback", "title", "buttonLabels"], '''
      var fn = function(btn) {confirmCallback.\$call\$1(btn);};
      navigator.notification.confirm(message, fn, title, buttonLabels);
    ''');
    newJSFunction(_BEEP, ["times"], "navigator.notification.beep(times);");
    newJSFunction(_VIBRATE, ["msecs"], "navigator.notification.vibrate(msecs);");
  }
}
