//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Sat, Apr 28, 2012  1:05:10 AM
// Author: tomyeh

/** A message listener.
 */
typedef void MessageListener(var message);

/** A message filter. It filters the given message, and returns the message
 * that shall be processed.
 * If it returns null, the message will be ignored.
 * Unless you'd like to convert the given message to another,
 * you can simply return the given message if it shall not be ignored.
 */
typedef MessageFilter(var message);

/**
 * A message queue.
 */
interface MessageQueue<Message> default _MessageQueueImpl<Message> {
  MessageQueue();

  /** The UUID of this message queue.
   */
  String get uuid;

  /** Subscribes a message listener to this message queue with an optional filter.
   */
  void subscribe(MessageListener listener, [MessageFilter filter]);
  /** Unsubscribes a message listener from this message queue.
   * This method returns true if the listener was added.
   */
  bool unsubscribe(MessageListener listener, [MessageFilter filter]);
  /** Sends a message to this queue, such that
   * all subscribers in this message queue will be notified.
   */
  void send(Message message);
  /** Posts a message to this queue.
   * Unlike [send], the subscribers will be invoked later.
   * In other words, this method returned immediately without waiting
   * any subscriber to be invoked.
   */
  void post(Message message);
}

class _MessageQueueImpl<Message> implements MessageQueue<Message> {
  final List<_ListenerInfo> _listenerInfos;
  String _uuid;

  _MessageQueueImpl(): _listenerInfos = new List() {
  }

  //@Override
  String get uuid {
    if (_uuid == null) {
      final int appid = application.uuid;
      _uuid = StringUtil.encodeId(_uuidNext++,
        appid > 0 ? "q${StringUtil.encodeId(appid)}_": "q_");
    }
    return _uuid;
  }
  static int _uuidNext = 0;

  //@Override
  void subscribe(MessageListener listener, [MessageFilter filter]) {
    _listenerInfos.add(new _ListenerInfo(listener, filter));
  }
  //@Override
  bool unsubscribe(MessageListener listener, [MessageFilter filter]) {
    for (int j = _listenerInfos.length; --j >= 0;) {
      final _ListenerInfo info = _listenerInfos[j];
      if (listener == info.listener && filter == info.filter) {
        _listenerInfos.removeRange(j, 1);
        return true;
      }
    }
    return false;
  }
  //@Override
  void send(Message message) {
    for (final _ListenerInfo info in _listenerInfos) {
      if (info.filter == null || (message = info.filter(message)) != null) {
        info.listener(message);
      }
    }
  }
  //@Override
  void post(Message message) {
    window.setTimeout(() {send(message);}, 0);
      //note: the order of messages is preserved across all message queues
  }

  String toString() => "MessageQueue($uuid)";
}
class _ListenerInfo {
  final MessageListener listener;
  final MessageFilter filter;

  _ListenerInfo(this.listener, this.filter);
}
