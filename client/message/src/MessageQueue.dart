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
	String get uuid();

	/** Adds a message listener to this message queue with an optional filter.
	 */
	void add(MessageListener listener, [MessageFilter filter]);
	/** Removes a message listener from this message queue.
	 * This method returns true if the listener was added.
	 */
	bool remove(MessageListener listener, [MessageFilter filter]);
	/** Sends a message to all listeners in this message queue.
	 */
	void send(Message message);
}

class _MessageQueueImpl<Message> implements MessageQueue<Message> {
	final List<_ListenerInfo> _listenerInfos;
	String _uuid;

	_MessageQueueImpl(): _listenerInfos = new List() {
	}

	//@Override
	String get uuid() {
		if (_uuid === null) {
			final int appid = application.uuid;
			_uuid = StringUtil.encodeId(_uuidNext++,
				appid > 0 ? "q${StringUtil.encodeId(appid)}_": "q_");
		}
		return _uuid;
	}
	static int _uuidNext = 0;

	//@Override
	void add(MessageListener listener, [MessageFilter filter]) {
		_listenerInfos.add(new _ListenerInfo(listener, filter));
	}
	//@Override
	bool remove(MessageListener listener, [MessageFilter filter]) {
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
			if (info.filter === null || (message = info.filter(message)) !== null) {
				info.listener(message);
			}
		}
	}
	String toString() => "MessageQueue($uuid)";
}
class _ListenerInfo {
	final MessageListener listener;
	final MessageFilter filter;

	_ListenerInfo(this.listener, this.filter);
}
