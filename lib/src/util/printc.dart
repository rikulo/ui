//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 27, 2012  4:20:01 PM
// Author: tomyeh

/** Prints the information to the client's screen rather than console.
 *
 * Since it prints the time between two consecutive messages,
 * you can use it measure the performance of particular functions.
 *
 * Notice that [printc] queues the message and displays it later, so
 * there won't be much performance overhead.
 */
void printc(var msg) {
  if (_printc == null)
    _printc = new _Printc();
  _printc.print(msg);
}
_Printc _printc;

class _Printc {
  final List<_PrintcMsg> _msgs;
  Element _node;
  _PrintcPopup _popup;

  _Printc() : _msgs = new List() {
  }

  void print(var msg) {
    _msgs.add(new _PrintcMsg(msg));
    _defer();
  }
  bool _ready() {
    if (_node == null) {
      final Element db = document.query("#v-dashboard");
      if (db == null) { //not in simulator
        _node = new Element.html(
  '<div class="v-printView-x"></div>');
        document.body.elements.add(_node);
      } else { //running in simulator
        _node = db.query(".v-printView");
        if (_node == null) {
          _defer(); //later
          return false;
        }
      }

      document.body.insertAdjacentHTML("afterBegin", '''
<style>
.v-printView-x {
 ${CSS.name('box-sizing')}: border-box;
 width:40%; height:30%; border:1px solid #332; background-color:#eec;
 overflow:auto; padding:3px; white-space:pre-wrap;
 font-size:11px; position:absolute; right:0; bottom:0;
}
.v-printView-pp {
 position:absolute; border:1px solid #221; padding:1px; background-color:white;
 border-radius: 1px; box-shadow: 0 0 6px rgba(0, 0, 0, 0.6);
}
.v-printView-pp div {
 display: inline-block; border:1px solid #553; border-radius: 3px;
 margin:2px; padding:0 2px; font-size:15px; cursor:pointer;
}
</style>
      ''');
      new HoldGesture(_node, _gestureAction(), _gestureStart());
    }
    return true;
  }
  HoldGestureAction _gestureAction() {
    return (HoldGestureState state) {
      Offset off = state.position - new DOMQuery(state.gesture.owner).pageOffset;
      (_popup = new _PrintcPopup(this)).open(off.x, off.y);
    };
  }
  HoldGestureStart _gestureStart() {
    return (HoldGestureState state)
      => _popup == null
      || !new DOMQuery(state.eventTarget).isDescendantOf(_popup._node);
  }

  void _defer() {
    window.setTimeout(_globalFlush, 100);
  }
  static void _globalFlush() {
    _printc._flush();
  }
  void _flush() {
    if (!_msgs.isEmpty()) {
      if (!_ready()) {
        _defer();
        return;
      }

      final StringBuffer sb = new StringBuffer();
      for (final _PrintcMsg msg in _msgs) {
        final Date time = msg.t;
        sb.add(time.hour).add(':').add(time.minute).add(':').add(time.second);
        if (_lastLogTime != null)
          sb.add('>').add((time.millisecondsSinceEpoch - _lastLogTime)/1000);
        _lastLogTime = time.millisecondsSinceEpoch;
        sb.add(': ').add(msg.m).add('\n');
      }
      _msgs.clear();

      _node.insertAdjacentHTML("beforeEnd", XMLUtil.encode(sb.toString()));;
      _node.$dom_scrollTop = 30000;
    }
  }
  static int _lastLogTime;

  void close() {
    if (_popup != null)
      _popup.close();
    if (_node != null) {
      _node.remove();
      _node = null;
    }
  }
}
class _PrintcMsg {
  final String m;
  final Date t;
  _PrintcMsg(var msg): m = "$msg", t = new Date.now();
    //we have to 'snapshot' the value since it might be changed later
}
class _PrintcPopup {
  final _Printc _owner;
  Element _node;
  ViewEventListener _elPopup;

  _PrintcPopup(_Printc this._owner) {
  }
  void open(int x, int y) {
    _node = new Element.html('<div style="left:${x+2}px;top:${y+2}px" class="v-printView-pp"><div>[]</div><div>+</div><div>-</div><div>x</div></div>');

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
  ViewEventListener _onPopup() {
    if (_elPopup == null)
      _elPopup = (PopupEvent event) {
        if (_node != null && event.shallClose(_node))
          close();
      };
    return _elPopup;
  }
}
