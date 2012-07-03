//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  03:31:33 PM
// Author: henrichen

/**
 * Access to the device notification facility.
 */
typedef NotificationAlertCallback();
typedef NotificationConfirmCallback(int buttonId);

interface XNotification { //rename to avoide name conflict with dart:html Notification
  /** Show a custom alert/dialog box.
   * + [message] dialog message.
   * + [alertCallback] callback function when the alert dialog is closed.
   * + [title] dialog title; default to "Alert".
   * + [buttonName] button name of the dialog; default to "OK".
   */
  alert(String message, NotificationAlertCallback alertCallback, [String title, String buttonName]);
  
  /** Show a customizable confirmation dialog box.
   * + [message] dialog message.
   * + [confirmCallback] callback function invoked with index of button pressed(1, 2, or 3) when the confirm dialog is closed.
   * + [title] dialog title; default to "Confirm".
   * + [buttonLabels] comma separated button names of the dialog; default to "OK,Cancel".
   */
  confirm(String message, NotificationConfirmCallback confirmCallback, [String title, String buttonLabels]);
  
  /** Play a beep sound.
   * + [times] the number of times to beep.
   */
  beep(int times);
  
  /** Vibrates device the specified duration in milliseconds.
   */
  vibrate(int milliseconds);
}
