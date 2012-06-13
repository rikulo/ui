//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jun 13, 2012  04:12:20 PM
// Author: henrichen

class PositionErrorEvent extends DeviceEvent {
  PositionErrorEvent(DeviceEventTarget target, PositionError data) :
    super(target), error = data;
  
  final PositionError error;
}

/** PositionErrorEvent listener function */
typedef void PositionErrorEventListener(PositionErrorEvent event);
