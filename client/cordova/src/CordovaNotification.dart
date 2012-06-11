//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  03:51:12 PM
// Author: henrichen

/**
 * A Cordova notification implementation.
 */
class CordovaNotification implements XNotification {
  CordovaNotification() {
    _initJSFunctions();
  }
  alert(String message, NotificationAlertCallback alertCallback, [String title, String buttonName]) {
    if (title === null) title = "Alert";
    if (buttonName === null) buttonName = "OK";
    jsCall("notification.alert", [message, alertCallback, title, buttonName]);
  }
  
  confirm(String message, NotificationConfirmCallback confirmCallback, [String title, String buttonLabels]) {
    if (title === null) title = "Confirm";
    if (buttonLabels === null) buttonLabels = "OK,Cancel";
    jsCall("notification.confirm", [message, confirmCallback, title, buttonLabels]);
  }
  
  beep(int times) {
    jsCall("notification.beep", [times]);
  }
  
  vibrate(int milliseconds) {
    jsCall("notification.vibrate", [milliseconds]);
  }
  
  void _initJSFunctions() {
    newJSFunction("notification.alert", ["message", "alertCallback", "title", "buttonName"], '''
      var fn = function() {alertCallback.\$call\$0();};
      navigator.notification.alert(message, fn, title, buttonName);
    ''');
    newJSFunction("notification.confirm", ["message", "confirmCallback", "title", "buttonLabels"], '''
      var fn = function(btn) {confirmCallback.\$call\$1(btn);};
      navigator.notification.confirm(message, fn, title, buttonLabels);
    ''');
    newJSFunction("notification.beep", ["times"], "navigator.notification.beep(times);");
    newJSFunction("notification.vibrate", ["msecs"], "navigator.notification.vibrate(msecs);");
  }
}
