//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 27, 2012  4:20:01 PM
// Author: tomyeh

/** Logs the information to the screen.
 * It does nothing if the application is not connected to a simulator.
 */
void log(var msg) {
	if (_log === null) {
		_log = document.query("#v-simulator") !== null ? new _SimuLog(): new _ConsoleLog();
			//don't use application.inSimulator since it might be ready yet
	}

	_log.log(msg);
}

//Log to console
class _ConsoleLog {
	final StringBuffer _msg;

	_ConsoleLog() : _msg = new StringBuffer() {
	}

	void log(var msg) {
		_msg.add(new Date.now()).add(": ").add(msg).add('\n');
		window.setTimeout(_globalFlush, 100);
	}
	static void _globalFlush() {
		_log._flush();
	}
	void _flush() {
		if (!_msg.isEmpty()) {
			final String msg = _msg.toString();
			_msg.clear();
			if (msg !== null)
				_print(msg);
		}
	}
	void _print(String msg) {
		print(msg.substring(0, msg.length - 1));
	}
}
//Log to simulator
class _SimuLog extends _ConsoleLog {
	Element _node;

	void _print(String msg) {
		simulatorQueue.send(new SimulatorMessage("log", msg));
	}
}
_ConsoleLog _log;
