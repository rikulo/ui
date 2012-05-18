//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  03:51:12 PM
// Author: henrichen

/**
 * A Cordova notification implementation.
 */
class CordovaNotification implements XNotification {
	alert(String message, NotificationAlertCallback alertCallback, [String title = "Alert", String buttonName = "OK"]) {
		_alert0(message, alertCallback, title, buttonName);
	}
	
	confirm(String message, NotificationConfirmCallback confirmCallback, [String title = "Confirm", String buttonLabels = "OK,Cancel"]) {
		_confirm0(message, confirmCallback, title, buttonLabels);
	}
	
	beep(int times) {
		_beep0(times);
	}
	
	vibrate(int milliseconds) {
		_vibrate0(milliseconds);
	}

	_alert0(String message, NotificationAlertCallback alertCallback, String title, String buttonName) native
		"navigator.notification.alert(message, alertCallback, title, buttonName);";
	
	_confirm0(String message, NotificationConfirmCallback confirmCallback, String title, String buttonLabels) native
		"navigator.notification.confirm(message, confirmCallback, title, buttonLabels);";

	_beep0(int times) native
		"navigator.notification.beep(times);";

	_vibrate0(int milliseconds) native
		"navigator.notification.vibrate(milliseconds);";
}
