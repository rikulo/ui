//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 10, 2012 12:24:23 PM
// Author: tomyeh

/**
 * A map of event listeners for handling the broadcasted events.
 */
interface BroadcastEvents extends ViewEventListenerMap default _BroadcastEvents {
  BroadcastEvents(var ptr);

  /** Listeners for the popup event ([PopupEvent]).
   */
  ViewEventListenerList get popup();
}

/** An implementation of [BroadcastEvents].
 */
class _BroadcastEvents extends _ViewEventListenerMap implements BroadcastEvents {
  _BroadcastEvents(var ptr): super(ptr);

  ViewEventListenerList get popup() => _get('popup');
}
