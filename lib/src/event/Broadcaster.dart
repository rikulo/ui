//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 10, 2012 12:16:20 PM
// Author: tomyeh
part of rikulo_event;

/**
 * The broadcaster used to broadcast events.
 *
 * The bradcasted event will be sent to every root views if they are mounted
 * (i.e., `inDocument`). Thus, to listen a broadcast event, you can register
 * a listenber to either [broadcaster] or one of the moutned root views.
 */
abstract class Broadcaster {
  /** Returns [BroadcastEvents] for adding or removing event listeners.
   */
  BroadcastEvents get on;
  /** Broadcasts an event to all registered listeners.
   */
  bool sendEvent(ViewEvent event, [String type]);
  /** Posts an event to all registered listeners.
   * Unlike [sendEvent], [postEvent] puts the event in a queue and returns
   * immediately. The event will be handled later.
   */
  void postEvent(ViewEvent event, [String type]);
}
/** The broadcaster used to broadcast events.
 *
 * You can assign your own implementation if you'd like.
 */
Broadcaster broadcaster = new _Broadcaster();

/**
 * A map of event listeners for handling the broadcasted events.
 */
class BroadcastEvents extends ViewEventListenerMap {
  BroadcastEvents(var ptr): super(ptr);

  /** Listeners for the activate event ([ActivateEvent]).
   */
  ViewEventListenerList get activate => _get('activate');
}

/** An implementation of [Broadcaster].
 */
class _Broadcaster extends Broadcaster {
  _BroadcastListeners _listeners;
  BroadcastEvents _on;

  _Broadcaster() {
    _listeners = new _BroadcastListeners(this);
    _on = new BroadcastEvents(_listeners);
  }

  BroadcastEvents get on => _on;

  bool sendEvent(ViewEvent event, [String type])
  => _listeners.send(event, type);
  void postEvent(ViewEvent event, [String type]) {
    window.setTimeout(() {sendEvent(event, type);}, 0);
      //note: the order of messages is preserved across all views (and message queues)
      //CONSIDER if it is better to have a queue shared by views/message queues/broadcaster
  }
}
class _BroadcastListeners {
  final Broadcaster _owner;
  final Map<String, List<ViewEventListener>> _listeners;

  _BroadcastListeners(Broadcaster this._owner): _listeners = new Map() {
  }

  /** Returns if no event listener registered to the given type. (Called by ViewEvents)
   */
  bool isEmpty(String type) {
    List<ViewEventListener> ls;
    return _listeners == null || (ls = _listeners[type]) == null || ls.isEmpty;
  }
  /** Adds an event listener.  (Called by ViewEvents)
   */
  void add(String type, ViewEventListener listener) {
    if (listener == null)
      throw new ArgumentError("listener");

    _listeners.putIfAbsent(type, () => []).add(listener);
  }
  /** Removes an event listener. (Called by ViewEvents)
   */
  bool remove(String type, ViewEventListener listener) {
    List<ViewEventListener> ls;
    return (ls = _listeners[type]) != null && ListUtil.remove(ls, listener);
  }
  /** Sends an event. (Called by ViewEvents)
   */
  bool send(ViewEvent event, [String type]) {
    if (type == null)
      type = event.type;

    List<ViewEventListener> ls;
    bool dispatched = false;
    if ((ls = _listeners[type]) != null) {
      //Note: we make a copy of ls since listener might remove other listeners
      //It means the removing and adding of listeners won't take effect until next event
      for (final ViewEventListener listener in new List.from(ls)) {
        dispatched = true;
        listener(event);
        if (event.isPropagationStopped)
          return true; //done
      }
    }

		//broadcast to all root views
    for (final v in rootViews)
      if (v.sendEvent(event, type))
        dispatched = true;
    return dispatched;
  }
}