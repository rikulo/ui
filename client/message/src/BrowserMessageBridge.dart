//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Sat, Apr 28, 2012  3:09:21 PM
// Author: tomyeh

/**
 * A bridge between the browser's cross-window messaging
 * and the message queues ([MessageQueue]).
 * It is used to allow a message queue to communicate with
 * another browser window, or another Dart application.
 *
 * <p>Notice: the message will be converted to a JSON string, so
 * the message must be null, double, String, bool, list (recursively)
 * and map (recursively). Also notice that num will be converted to
 * double.
 */
class BrowserMessageBridge<Message> {
	final List<_MQueueInfo<Message>> _receives;
	final List<_MQueueInfo<Message>> _sends;
	EventListener _evtListener;
	MessageListener _msgListener;
	bool _ignoreMessage = false;

	/** To avoid conflicts with other cross-window messages. */
	static final String _BMB_ID = "rikulo.BMB";

	BrowserMessageBridge(): _receives = [], _sends = [] {
		_evtListener = (event) {
			final data = JSON.parse(event.data);
			if (data["bqid"] == _BMB_ID) {
				final String origin = event.origin;
				final String uuid = data["uuid"];
				final message = data["message"];
				for (final _MQueueInfo<Message> info in _sends) {
					if (info.queue.uuid != uuid //skip the sending queue to avoid dead loop
					&& (info.origin == "*" || info.origin == origin)) {
							_ignoreMessage = true; //avoid dead loop
							try {
								info.queue.send(message);
							} finally {
								_ignoreMessage = false;
							}
					}
				}
			}
		};
		_msgListener = (message) {
			if (!_ignoreMessage) {
				for (final _MQueueInfo<Message> info in _receives) {
					window.postMessage(JSON.stringify({
						"uuid": info.queue.uuid,
						"bqid": _BMB_ID,
						"message": message}), info.origin);
				}
			}
		};
	}

	/** Subscribes this bridge to a message queue to estiblish
	 * the connection between the message queue and the browser's messaging system.
	 * <p>If [receive] is true, this bridge will receive the messages from
	 * the given message queue. In other words, the message will be forwarded
	 * to other browser windows and/or other Dart applications.
	 * <p>If [send] is true, this bridde will send the messages to
	 * the given message queue. In other words, this bridge will add a listener
	 * to the browser window, and then forward the message received from
	 * other windows to the message queue.
	 * <p>[origin] specifies the origin of the other window to communicate with.
	 * It is either as the literal string "*" (indicating no preference), as "self"
	 * (indicating the same window) or as a URI.
	 * Please refer to <a href="https://developer.mozilla.org/en/DOM/window.postMessage">DOM API</a>
	 * for detailed description (so called <code>targetOrigin</code>).
	 * For better security, "*" is not suggested.
	 */
	void subscribe(MessageQueue queue, [
	bool receive=true, bool send=true, String origin="self"]) {
		final String rawOrigin = origin;
		if (origin == "self" || origin == null) {
			origin = browser.url;
			if (origin.startsWith("file:"))
				origin = "*";
		}
		final _MQueueInfo info = new _MQueueInfo(queue, origin, rawOrigin);

		if (receive) {
			_receives.add(info);
			queue.add(_msgListener);
		}
		if (send) {
			_sends.add(info);
			if (_sends.length == 1) //only the first send
				window.on.message.add(_evtListener);
		}
	}
	
	/** Unsubscribes this bridge from a message queue to remove
	 * the connection between the message queue and the browser's messaging system.
	 */
	bool unsubscribe(MessageQueue queue,
	[bool receive=true, bool send=true, String origin="self"]) {
		bool found = false;
		if (receive) {
			for (int j = _receives.length; --j >= 0;) {
				final _MQueueInfo<Message> info = _receives[j];
				if (info.queue == queue && info.rawOrigin == origin) {
					_receives.removeRange(j, 1);
					queue.remove(_msgListener);
					found = true;
					break;
				}
			}
		}
		if (send) {
			for (int j = _sends.length; --j >= 0;) {
				final _MQueueInfo<Message> info = _sends[j];
				if (info.queue == queue && info.rawOrigin == origin) {
					_sends.removeRange(j, 1);
					if (_sends.length == 0)
						window.on.message.remove(_evtListener);
					found = true;
					break;
				}
			}
		}
		return found;
	}
}
class _MQueueInfo<Message> {
	final MessageQueue<Message> queue;
	final String origin;
	final String rawOrigin;

	_MQueueInfo(this.queue, this.origin, this.rawOrigin);
	String toString() => "_MQueueInfo($queue, $origin)";
}
