//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 3, 2012  10:48:26 AM
// Author: henrichen

/** DeviceEvent target */
interface DeviceEventTarget {
  /** Register event listener into this event target.
  */
  void addEventListener(String type, Function listener, [Function errListener, Map options]);

  /** Unregister event listener from this event target.
  */
  void removeEventListener(String type, Function listener);

  /** Tests if any listener is registered in this event target.
  */
  bool isEventListened(String type);
}

