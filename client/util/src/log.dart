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
	_LogPopup _popup;

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
	'<div class="v-logView-x"></div>');
				document.body.elements.add(_node);
			} else { //running in simulator
				_node = db.query(".v-logView");
				if (_node === null) {
					_defer(); //later
					return false;
				}
			}

			document.body.insertAdjacentHTML("afterBegin", '''
<style>
.v-logView-x {
 ${CSS.name('box-sizing')}: border-box;
 width:40%; height:30%; border:1px solid #332; background-color:#eec;
 overflow:auto; padding:3px; white-space:pre-wrap;
 font-size:11px; position:absolute; right:0; bottom:0;
}
.v-logView-pp {
 position:absolute; border:1px solid #221; padding:1px; background-color:white;
 border-radius: 1px; box-shadow: 0 0 6px rgba(0, 0, 0, 0.6);
}
.v-logView-pp div {
 display: inline-block; border:1px solid #553; border-radius: 3px;
 margin:2px; padding:0 2px; font-size:15px; cursor:pointer;
}
</style>
			''');
			new HoldGesture(_node, _gestureAction(), _gestureStart());
		}
		return true;
	}
	HoldGestureCallback _gestureAction() {
		return (Element touched, int pageX, int pageY) {
			final Offset ofs = new DomQuery(_node).documentOffset;
			(_popup = new _LogPopup(this)).open(pageX - ofs.left, pageY - ofs.top);
		};
	}
	HoldGestureCallback _gestureStart() {
		return (Element touched, int pageX, int pageY)
			=> _popup === null || !new DomQuery(touched).isDescendantOf(_popup._node);
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
	void close() {
		if (_popup !== null)
			_popup.close();
		if (_node !== null) {
			_node.remove();
			_node = null;
		}
	}
}
class _LogPopup {
	final _Log _owner;
	Element _node;
	EventListener _elPopup;

	_LogPopup(_Log this._owner) {
	}
	void open(int x, int y) {
		_node = new Element.html('<div style="left:${x+2}px;top:${y+2}px" class="v-logView-pp"><div>[]</div><div>+</div><div>-</div><div>x</div></div>');

		_node.elements[0].on.click.add((e) {_size("100%", "100%");});
		_node.elements[1].on.click.add((e) {_size("100%", "30%");});
		_node.elements[2].on.click.add((e) {_size("40%", "30%");});
		_node.elements[3].on.click.add((e) {_owner.close();});

		_owner._node.elements.add(_node);
		broadcaster.on.popup.add(_onPopup());
	}
	void _size(String width, String height) {
		final CSSStyleDeclaration style = _owner._node.style;
		style.width = width;
		style.height = height;
		close();
	}
	void close() {
		broadcaster.on.popup.remove(_onPopup());
		_node.remove();
		_node = null;
		_owner._popup = null;
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
