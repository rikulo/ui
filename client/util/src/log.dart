//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 27, 2012  4:20:01 PM
// Author: tomyeh

/** Logs the information to the screen.
 * It does nothing if the application is not connected to a simulator.
 */
void log(var msg) {
	if (_log === null)
		_log = new _Log();
	_log.log(msg);
}
_Log _log;

//Log to console
class _Log {
	final StringBuffer _msg;
	Element _node;

	_Log() : _msg = new StringBuffer() {
	}

	void log(var msg) {
		_msg.add(new Date.now()).add(": ").add(msg).add('\n');
		_defer();
	}
	bool _ready() {
		if (_node === null) {
			final Element db = document.query("#v-dashboard");
			if (db === null) { //not in simulator
				_node = new Element.html('''
	<div style="border:1px solid #332;background-color:#eec;overflow:auto;padding:3px;white-space:pre-wrap;font-size:11px;position:absolute;right:0px;bottom:0px;width:40%;height:30%"><div style="border:1px solid #553;padding:1px;position:absolute;right:0;cursor:pointer">X</div></div>
		''');
				document.body.nodes.add(_node);
				_node.query("div").on.click.add((e) {_node.remove();});
			} else { //running in simulator
				_node = db.query(".v-logView");
				if (_node === null) {
					_defer(); //later
					return false;
				}
			}
		}
		return true;
	}
	void _defer() {
		window.setTimeout(_globalFlush, 100);
	}
	static void _globalFlush() {
		_log._flush();
	}
	void _flush() {
		if (!_msg.isEmpty()) {
			if (!_ready()) {
				_defer();
				return;
			}

			final String msg = _msg.toString();
			_msg.clear();
			_node.insertAdjacentHTML("beforeEnd", StringUtil.encodeXML(msg));;
			_node.$dom_scrollTop = 30000;
		}
	}
}
