//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 18, 2012  09:20:22 AM
// Author: henrichen

class PositionEvent extends DeviceEvent {
  PositionEvent(DeviceEventTarget target, Position data, [PositionError error = null]) :
    super(target, error === null), error = error, 
    coords = data === null ? null : data.coords, 
    timestamp = data === null ? null : data.timestamp;
  
  final PositionError error;
  final Coordinates coords;
  final int timestamp;
}

/** PositionEvent listener function */
typedef void PositionEventListener(PositionEvent event);