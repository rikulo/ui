//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 27, 2012  4:20:01 PM
// Author: tomyeh
part of rikulo_view;

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
  '<div class="v-printc-x"></div>');
        document.body.children.add(_node);
      } else { //running in simulator
        _node = db.query(".v-printc");
        if (_node == null) {
          _defer(); //later
          return false;
        }
      }

      document.body.insertAdjacentHtml("afterBegin", '''
<div><style>
.v-printc-x {
 box-sizing: border-box;
 width:40%; height:30%; border:1px solid #332; background-color:#eec;
 overflow:auto; padding:3px; white-space:pre-wrap;
 font-size:11px; font-family:monospace; position:absolute; right:0; bottom:0;
}
.v-printc-pp {
 position:absolute; border:1px solid #221; padding:1px; background-color:white;
 border-radius: 1px; box-shadow: 0 0 6px rgba(0, 0, 0, 0.6);
}
.v-printc-pp div {
 display: inline-block; border:1px solid #553; border-radius: 3px;
 margin:2px; padding:0 2px; font-size:15px; cursor:pointer;
}
</style></div>
      '''); //IE9: enclose with div is required
      new HoldGesture(_node, _gestureAction(), start: _gestureStart());
    }
    return true;
  }
  HoldGestureAction _gestureAction() {
    return (HoldGestureState state) {
      Point off = state.position - DomUtil.page(state.gesture.owner);
      (_popup = new _PrintcPopup(this)).open(off.x, off.y);
    };
  }
  HoldGestureStart _gestureStart() {
    return (HoldGestureState state)
      => _popup == null || !DomUtil.isDescendant(state.eventTarget, _popup._node);
  }

  void _defer() {
    new Timer(const Duration(milliseconds: 100), _globalFlush);
  }
  static void _globalFlush() {
    _printc._flush();
  }
  void _flush() {
    if (!_msgs.isEmpty) {
      if (!_ready()) {
        _defer();
        return;
      }

      final StringBuffer sb = new StringBuffer();
      for (final _PrintcMsg msg in _msgs) {
        final DateTime time = msg.t;
        sb..write(time.hour)..write(':')..write(time.minute)..write(':')..write(time.second);
        if (_lastLogTime != null)
          sb..write('>')..write((time.millisecondsSinceEpoch - _lastLogTime)/1000);
        _lastLogTime = time.millisecondsSinceEpoch;
        sb..write(': ')..write(msg.m)..write('\n');
      }
      _msgs.clear();

      _node.insertAdjacentHtml("beforeEnd", XmlUtil.encode(sb.toString()));;
      _node.scrollTop = 30000;
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
  final DateTime t;
  _PrintcMsg(var msg): m = "$msg", t = new DateTime.now();
    //we have to 'snapshot' the value since it might be changed later
}
class _PrintcPopup {
  final _Printc _owner;
  Element _node;
  ViewEventListener _elPopup;
  StreamSubscription<ActivateEvent> _subActivate;

  _PrintcPopup(_Printc this._owner) {
    _elPopup = (event) {
      if (_node != null && event.shallClose(_node))
        close();
    };
  }
  void open(int x, int y) {
    _node = new Element.html('<div style="left:${x+2}px;top:${y+2}px" class="v-printc-pp"><div>[]</div><div>+</div><div>-</div><div>x</div></div>');

    final elems = _node.children;
    elems[0].onClick.listen((e) {_size("100%", "100%");});
    elems[1].onClick.listen((e) {_size("100%", "30%");});
    elems[2].onClick.listen((e) {_size("40%", "30%");});
    elems[3].onClick.listen((e) {_owner.close();});

    _owner._node.children.add(_node);
    _subActivate = broadcaster.on.activate.listen(_elPopup);
  }
  void _size(String width, String height) {
    final style = _owner._node.style;
    style.width = width;
    style.height = height;
    close();
  }
  void close() {
    if (_subActivate != null) {
      _subActivate.cancel();
      _subActivate = null;
    }
    if (_node != null) {
      _node.remove();
      _node = null;
    }
    _owner._popup = null;
  }
}
