//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Sat, Apr 28, 2012  3:09:21 PM
// Author: tomyeh

/**
 * A bridge for inter-application communication among message queues.
 * By connecting this bridge to a message queue (by use of [connect]),
 * the messages can be sent to, or received from another applications,
 * as long as they also connect to a bridge with the same name.
   *
 * Message queues connecting the same bridge are considered
 * as the same group. They are distinquished by [name].
 *
 * The implementation is based on the browser's cross-window messaging.
 * It means the applications can reside even on different browser windows.
 *
 * Notice: the message will be converted to a JSON string, so
 * the message must be null, double, String, bool, list (recursively)
 * and map (recursively). Also notice that num will be converted to
 * double.
 */
class InterApplicationBridge<Message> {
  final List<MessageQueue<Message>> _receives;
  final List<MessageQueue<Message>> _sends;
  final String _name;
  final String _origin;
  EventListener _evtListener;
  MessageListener _msgListener;
  bool _ignoreMessage = false;

  /** Instantiates a bridge.
   * The bridges with the same name ([name]) are considered as the same group.
   * The messages will be forwarded among bridges within the same group.
   *
   * + [origin] specifies the origin of the other window to communicate with.
   * It is either as the literal string "*" (indicating no preference), as "self"
   * (indicating the same window) or as a URI.
   * Please refer to <a href="https://developer.mozilla.org/en/DOM/window.postMessage">DOM API</a>
   * for detailed description (so called `targetOrigin`).
   * For better security, "*" is not suggested.
   */
  factory InterApplicationBridge(String name, [String origin="self"]) {
    if (origin == "self" || origin == null) {
      origin = browser.url;
      if (origin.startsWith("file:"))
        origin = "*";
    }
    return new InterApplicationBridge._with(name, origin);
  }
  InterApplicationBridge._with(this._name, this._origin):
  _receives = [], _sends = [] {
    _evtListener = (event) { //DOM event
      var data;
      try {
        data = JSON.parse(event.data);

        if (data["iabId"] != _name || (_origin != "*" && _origin != event.origin))
          return; //not matched
      } catch (e) {
        return; //ignored (since the message might not be recognizable)
      }

      final String queId = data["queId"];
      final message = data["message"];
      for (final MessageQueue<Message> queue in _sends) {
        if (queue.uuid != queId) { //skip the sending queue to avoid dead loop
          _ignoreMessage = true; //avoid dead loop
          try {
            queue.send(message);
          } finally {
            _ignoreMessage = false;
          }
        }
      }
    };
    _msgListener = (message) {
      if (!_ignoreMessage) {
        for (final MessageQueue<Message> queue in _receives) {
          window.postMessage(JSON.stringify({
            "queId": queue.uuid,
            "iabId": _name,
            "message": message}), _origin);
        }
      }
    };
  }

  /** Returns the name of this bridge.
   * Bridges with the same name are considered as the same group.
   */
  String get name => _name;

  /** Connects this bridge to a message queue such that the messages will
   * be forward to/from another applications if they also connect
   * to a bridge with the same name.
   *
   * If [receive] is true, this bridge will receive the messages from
   * the given message queue. In other words, the message will be forwarded
   * to other browser windows and/or other Dart applications.
   *
   * If [send] is true, this bridde will send the messages to
   * the given message queue. In other words, this bridge will subscribe a listener
   * to the browser window, and then forward the message received from
   * other windows to the message queue.
   */
  void connect(MessageQueue queue, [bool receive=true, bool send=true]) {
    if (receive) {
      queue.subscribe(_msgListener);
      _receives.add(queue);
    }
    if (send) {
      if (_sends.length == 0) //only the first send
        window.on.message.add(_evtListener);
      _sends.add(queue);
    }
  }
  
  /** Disconnects this bridge from a message queue to remove
   * the connection between the message queue and the browser's messaging system.
   */
  bool disconnect(MessageQueue queue, [bool receive=true, bool send=true]) {
    bool found = false;
    if (receive) {
      for (int j = _receives.length; --j >= 0;) {
        if (_receives[j] == queue) {
          queue.unsubscribe(_msgListener);
          _receives.removeRange(j, 1);
          found = true;
          break;
        }
      }
    }
    if (send) {
      for (int j = _sends.length; --j >= 0;) {
        if (_sends[j] == queue) {
          if (_sends.length == 0)
            window.on.message.remove(_evtListener);
          _sends.removeRange(j, 1);
          found = true;
          break;
        }
      }
    }
    return found;
  }

  String toString() => "InterApplicationBridge($name)";
}
