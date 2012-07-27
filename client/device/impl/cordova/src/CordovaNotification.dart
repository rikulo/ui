//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  03:51:12 PM
// Author: henrichen

/**
 * A Cordova notification implementation.
 */
class CordovaNotification implements XNotification {
  static final String _ALERT = "noti.1";
  static final String _CONFIRM = "noti.2";
  static final String _BEEP = "noti.3";
  static final String _VIBRATE = "noti.4";
  
  CordovaNotification() {
    _initJSFunctions();
  }
  alert(String message, NotificationAlertCallback alertCallback, [String title, String buttonName]) {
    if (title == null) title = "Alert";
    if (buttonName == null) buttonName = "OK";
    JSUtil.jsCall(_ALERT, [message, JSUtil.toJSFunction(alertCallback, 0), title, buttonName]);
  }
  
  confirm(String message, NotificationConfirmCallback confirmCallback, [String title, String buttonLabels]) {
    if (title == null) title = "Confirm";
    if (buttonLabels == null) buttonLabels = "OK,Cancel";
    JSUtil.jsCall(_CONFIRM, [message, JSUtil.toJSFunction(confirmCallback, 1), title, buttonLabels]);
  }
  
  beep(int times) {
    JSUtil.jsCall(_BEEP, [times]);
  }
  
  vibrate(int milliseconds) {
    JSUtil.jsCall(_VIBRATE, [milliseconds]);
  }
  
  static bool _doneInit = false;
  void _initJSFunctions() {
    if (_doneInit) return;
    
    JSUtil.newJSFunction(_ALERT, ["message", "alertCallback", "title", "buttonName"],
      "navigator.notification.alert(message, alertCallback, title, buttonName);");
    JSUtil.newJSFunction(_CONFIRM, ["message", "confirmCallback", "title", "buttonLabels"],
      "navigator.notification.confirm(message, confirmCallback, title, buttonLabels);");
    JSUtil.newJSFunction(_BEEP, ["times"], "navigator.notification.beep(times);");
    JSUtil.newJSFunction(_VIBRATE, ["msecs"], "navigator.notification.vibrate(msecs);");
    
    _doneInit = true;
  }
}
