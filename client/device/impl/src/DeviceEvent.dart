//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  10:48:26 AM
// Author: henrichen

/**
 * Event fired from the device.
 */
class DeviceEvent {
  bool _propStop;
  bool success; //indicate whether this is a success event(true) or an error event(false)
  DeviceEventTarget target;
  
  /** Returns whether this event's propagation is stopped.
   *
   * Default: false.
   *
   * It becomes true if {[stopPropagation] is called,
   * and then all remaining event listeners are ignored.
   */
  bool isPropagationStopped() => _propStop;
  /** Stops the propagation.
   *Once called, all remaining event listeners, if any, are ignored.
   */
  void stopPropagation() {
    _propStop = true;
  }
  
  DeviceEvent(target, success) : this.target = target, this.success = success;
}
