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
				_node = new Element.html(
	'<div style="width:40%;height:30%;border:1px solid #332;background-color:#eed;overflow:auto;padding:3px;white-space:pre-wrap;font-size:11px;position:absolute;right:0px;bottom:0px"></div>');
				document.body.nodes.add(_node);
			} else { //running in simulator
				_node = db.query(".v-logView");
				if (_node === null) {
					_defer(); //later
					return false;
				}
			}
			new HoldGesture(_node, _gestureAction());
		}
		return true;
	}
	HoldGestureCallback _gestureAction() {
		return (int pageX, int pageY) {
			final Offset ofs = new DomQuery(_node).documentOffset;
			new _LogPopup(_node).open(pageX - ofs.left, pageY - ofs.top);
		};
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
class _LogPopup {
	final Element _owner;
	Element _node;
	EventListener _elPopup;

	_LogPopup(Element this._owner) {
	}
	void open(int x, int y) {
		_node = new Element.html('''
<div style="left:${x+2}px;top:${y+2}px;position:absolute;border:1px solid #221;padding:2px;background:white"><style>
.v-log-button{border:1px solid #553;margin:2px;cursor:pointer;padding:0 2px;font-size:15px;
}</style><span class="v-log-button">*</span><span class="v-log-button">+</span><span class="v-log-button">-</span><span class="v-log-button">X</span></div>
		''');
		_owner.nodes.add(_node);
		broadcaster.on.popup.add(_onPopup());
	}
	void close() {
		broadcaster.on.popup.remove(_onPopup());
		_node.remove();
		_node = null;
	}
	EventListener _onPopup() {
		if (_elPopup === null)
			_elPopup = (event) {
				if (_node !== null && event.shallClose(_node))
					close();
			};
		return _elPopup;
	}
}
