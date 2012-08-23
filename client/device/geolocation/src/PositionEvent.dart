//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 18, 2012  09:20:22 AM
// Author: henrichen

class PositionEvent {
  PositionEvent(XGeolocation this.target, Position this.position);

  final XGeolocation target;
  final Position position;
  int get timeStamp => position.timeStamp;
}

class PositionErrorEvent {
  PositionErrorEvent(XGeolocation this.target, PositionError this.error);
  
  final XGeolocation target;
  final PositionError error;
}

/** [PositionEvent] listener function */
typedef void PositionEventListener(PositionEvent event);
/** [PositionErrorEvent] listener function */
typedef void PositionErrorEventListener(PositionErrorEvent event);
