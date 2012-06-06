//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  03:51:12 PM
// Author: henrichen

/**
 * A Cordova notification implementation.
 */
class CordovaNotification implements XNotification {
  alert(String message, NotificationAlertCallback alertCallback, [String title = "Alert", String buttonName = "OK"]) {
    jsCall("notification.alert", [message, alertCallback, title, buttonName]);
  }
  
  confirm(String message, NotificationConfirmCallback confirmCallback, [String title = "Confirm", String buttonLabels = "OK,Cancel"]) {
    jsCall("notification.confirm", [message, confirmCallback, title, buttonLabels]);
  }
  
  beep(int times) {
    jsCall("notification.beep", [times]);
  }
  
  vibrate(int milliseconds) {
    jsCall("notification.vibrate", [milliseconds]);
  }
}
