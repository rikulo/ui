//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Mar 13, 2012  2:14:29 PM
// Author: tomyeh
part of rikulo_view;

///Converts null to an empty string
String _s(String s) => s != null ? s: "";
///Converts null to false
bool _b(bool b) => b != null && b;
///Converts null to 0
num _n(num n) => n != null ? n: 0;

/** Collection of utilities for View's implementation
 */
class _ViewImpl {
  //System Initialization//
  static void init() {
    if (!_inited) {
      _inited = true;
      window.onResize.listen(_onResize);
      (browser.touch ? document.onTouchStart: document.onMouseDown).listen(_onTouchStart);
    }
  }
  static bool _inited = false;
  static EventListener get _onResize {
    if (browser.android) {
    //Android: resize will be fired when virtual keyboard showed up
    //so we have to ignore this case: width must be changed, or height is larger
    //(since user might bring up kbd, rotate, and close kbd)
      Size old = new WindowAgent(window).innerSize;
      return (event) { //DOM event
          final cur = new WindowAgent(window).innerSize;
          if (old.width != cur.width || old.height < cur.height) {
            old = cur;
            browser.updateSize();
            _updRootSize();
          }
        };
    } else {
      return (event) { //DOM event
          browser.updateSize();
          _updRootSize();
        };
    }
  }
  static void _updRootSize() {
    for (View v in rootViews) {
      final dlgInfo = dialogInfos[v];
      if (dlgInfo != null)
        dlgInfo.updateSize();
      v.requestLayout();
    }
  }
  static final EventListener _onTouchStart = (event) { //DOM event
      broadcaster.sendEvent(new ActivateEvent(event.target));
    };

  //Link//
  //----//
  static void link(View view, View child, View beforeChild) {
    final _ChildInfo ci = view._initChildInfo();
    if (beforeChild == null) {
      View p = ci.lastChild;
      if (p != null) {
        p._nextSibling = child;
        child._prevSibling = p;
        ci.lastChild = child;
      } else {
        ci.firstChild = ci.lastChild = child;
      }
    } else {
      View p = beforeChild._prevSibling;
      if (p != null) {
        child._prevSibling = p;
        p._nextSibling = child;
      } else {
        ci.firstChild = child;
      }

      beforeChild._prevSibling = child;
      child._nextSibling = beforeChild;
    }
    child._parent = view;

    ++view._childInfo.nChild;
    if (child is IdSpace)
      addToIdSpace(child, true); //skip the first owner (i.e., child)
    else
      addToIdSpaceDown(child, child.spaceOwner);
  }
  static void unlink(View view, View child) {
    if (child is IdSpace)
      removeFromIdSpace(child, true); //skip the first owner (i.e., child)
    else
      removeFromIdSpaceDown(child, child.spaceOwner);

    var p = child._prevSibling, n = child._nextSibling;
    if (p != null) p._nextSibling = n;
    else view._childInfo.firstChild = n;
    if (n != null) n._prevSibling = p;
    else view._childInfo.lastChild = p;
    child._nextSibling = child._prevSibling = child._parent = null;

    --view._childInfo.nChild;
  }

  //utilities//
  /** Creates a dialog encloser.
   */
  static DialogInfo createDialog(Element node, View view, [String maskClass="v-mask"]) {
    Size size = node == document.body ?
      browser.size: new DomAgent(node).innerSize;

    final parent = new DivElement();
    parent.style.position = "relative";
      //we have to create a relative element to enclose dialog
      //since layout assumes it (test case: TestPartial.html)
    node.nodes.add(parent);

    //create mask
    final mask = new Element.html(
      '<div class="v- ${maskClass}" style="width:${size.width}px;height:${size.height}px"></div>');
    
    if (node != document.body)
      mask.style.position = "absolute";
    // mask inherits visibility of dialog view
    mask.style.visibility = view.style.visibility;
    if (!view.visible)
      new DomAgent(mask).hide();
    
    parent.nodes.add(mask);
    return new DialogInfo(parent, mask);
  }

  //IdSpace//
  //-------//
  static IdSpace spaceOwner(View view) {
    View top, p = view;
    do {
      if (p is IdSpace)
        return p;
      top = p;
    } while ((p = p.parent) != null);

    if (top._virtIS == null)
      top._virtIS = new _VirtualIdSpace(top);
    return top._virtIS;
  }

  /** Checks the uniqueness in ID space when changing ID. */
  static void checkIdSpaces(View view, String newId) {
    IdSpace space = view.spaceOwner;
    if (space.fellows[newId] != null)
      throw new UiError("Not unique in the ID space of $space: $newId");

    //we have to check one level up if view is IdSpace (i.e., unique in two ID spaces)
    View parent;
    if (view is IdSpace && (parent = view.parent) != null) {
      space = parent.spaceOwner;
      if (space.fellows[newId] != null)
        throw new UiError("Not unique in the ID space of $space: $newId");
    }
  }
  //Add the given view to the ID space
  static void addToIdSpace(View view, [bool skipFirst=false]){
    String id = view.id;
    if (id.length == 0)
      return;

    if (!skipFirst)
      _addFellow(view.spaceOwner, id, view);

    //we have to put it one level up if view is IdSpace (i.e., unique in two ID spaces)
    View parent;
    if (view is IdSpace && (parent = view.parent) != null)
      _addFellow(parent.spaceOwner, id, view);
  }
  //Add the given view and all its children to the ID space
  static void addToIdSpaceDown(View view, var space) {
    var id = view.id;
    if (id.length > 0)
      _addFellow(space, id, view);

    if (view is! IdSpace) {
      final IdSpace vs = view._virtIS;
      if (vs != null) {
        view._virtIS = null;
        for (final child in vs.fellows.values)
          _addFellow(space, child.id, child);
      } else {
        for (view = view.firstChild; view != null; view = view.nextSibling)
          addToIdSpaceDown(view, space);
      }
    }
  }
  static void removeFromIdSpace(View view, [bool skipFirst=false]) {
    String id = view.id;
    if (id.length == 0)
      return;

    if (!skipFirst)
      _rmFellow(view.spaceOwner, id);

    //we have to put it one level up if view is IdSpace (i.e., unique in two ID spaces)
    View parent;
    if (view is IdSpace && (parent = view.parent) != null)
      _rmFellow(parent.spaceOwner, id);
  }
  static void removeFromIdSpaceDown(View view, var space) {
    var id = view.id;
    if (id.length > 0)
      _rmFellow(space, id);

    if (view is! IdSpace)
      for (view = view.firstChild; view != null; view = view.nextSibling)
        removeFromIdSpaceDown(view, space);
  }
}

void _addFellow(IdSpace space, String id, View fellow) {
  space.fellows[id] = fellow;
}
void _rmFellow(IdSpace space, String id) {
  space.fellows.remove(id);
}

/** The children information used in [View].
 */
class _ChildInfo {
  View firstChild, lastChild;
  int nChild = 0;
  List children;
}

/** The information of an event listener used in [View].
 */
class _EventListenerInfo {
  final View _owner;
  ViewEvents on;
  //the registered event listeners; created on demand
  Map<String, List<ViewEventListener>> _listeners;
  //generic DOM event listener
  Map<String, EventListener> _domListeners;

  _EventListenerInfo(View this._owner) {
    on = new ViewEvents(_owner);
  }

  /** Returns if no event listener registered to the given type. (Called by ViewEvents)
   */
  bool isEmpty(String type) {
    List<ViewEventListener> ls;
    return _listeners == null || (ls = _listeners[type]) == null || ls.isEmpty;
  }
  /** Adds an event listener. (Called by ViewEvents)
   */
  void add(String type, ViewEventListener listener, bool useCapture) {
    if (listener == null)
      throw new ArgumentError("listener");

    if (_listeners == null)
      _listeners = new Map();

    bool first = false;
    _listeners.putIfAbsent(type, () {
      first = true;
      return [];
    }).add(listener);

    if (first)
      _owner.onEventListened_(type, useCapture: useCapture);
  }
  /** Removes an event listener. (Called by ViewEvents)
   */
  void remove(String type, ViewEventListener listener, bool useCapture) {
    List<ViewEventListener> ls;
    if (_listeners != null && (ls = _listeners[type]) != null) {
      int j = ls.indexOf(listener);
      if (j >= 0) {
        ls.removeRange(j, 1);
        if (ls.isEmpty)
          _owner.onEventUnlistened_(type, useCapture: useCapture);
      }
    }
  }
  /** Sends an event. (Called by ViewEvents)
   */
  bool send(ViewEvent event, String type) {
    if (type == null)
      type = event.type;

    List<ViewEventListener> ls;
    bool dispatched = false;
    if (_listeners != null && (ls = _listeners[type]) != null) {
      event.currentTarget = _owner;
      //Note: we make a copy of ls since listener might remove other listeners
      //It means the removing and adding of listeners won't take effect until next event
      for (final ViewEventListener listener in new List.from(ls)) {
        dispatched = true;
        listener(event);
        if (event.isPropagationStopped)
          return true; //done
      }
    }
    return dispatched;
  }

  void onEventListened_(String type, Element target, bool useCapture) {
    //proxy known DOM events
    final disp = _domEventDispatcher(type);
    if (disp != null) {
      final ln = disp(_owner); //must be non-null
      if (_domListeners == null)
        _domListeners = new Map();
      (target != null ? target: _domEvtTarget(type, _owner.node))
        .$dom_addEventListener(type.toLowerCase(), _domListeners[type] = ln, useCapture);
    }
  }
  void onEventUnlistened_(String type, Element target, bool useCapture) {
    EventListener ln;
    if (_domListeners != null
    && (ln = _domListeners.remove(type)) != null)
      (target != null ? target: _domEvtTarget(type, _owner.node))
        .$dom_removeEventListener(type.toLowerCase(), ln, useCapture);
  }
}

/** DOM-level event listener that proxies a DOM event to a view event
 * ([ViewEvent]) and dispatch to the right target.
 */
typedef EventListener _DomEventDispatcher(View target);

Element _domEvtTarget(String type, Element node) {
  //focus/blur not bubble up: http://www.quirksmode.org/js/tests/focusbubble.html
  //so we have to register it to the right element
  if ((type == "focus" || type == "blur") && !_inpTags.contains(node.tagName.toLowerCase())) {
    for (final tag in _inpTags) {
      final inp = node.query(tag);
      if (inp != null) {
        node = inp;
        break;
      }
    }
  }
  return node;
}

final _inpTags = new Set.from(const ["input", "textarea", "select", "button", "a"]);
_DomEventDispatcher _domEventDispatcher(String type) {
  if (_domEvtDisps == null) {
    _domEvtDisps = new Map();
    for (final nm in domEvents)
      _domEvtDisps[nm] = nm == "change" ? _domChangeEvtDisp(): _domEvtDisp(nm);
  }
  return _domEvtDisps[type];
}
_DomEventDispatcher _domEvtDisp(String type) {
  return (View target) {
    return (Event event) {
      var tv = event.target; //the real target based on the event
      tv = tv is Node ? ViewUtil.getView(tv): null;
      target.sendEvent(new DomEvent(event, type, tv != null ? tv: target));
    };
  };
}
_DomEventDispatcher _domChangeEvtDisp() {
  return (View target) {
    return (Event event) {
      final dt = event.target;
      var tv = dt; //the real target based on the event
      if (tv != null)
        tv = ViewUtil.getView(tv);
      target.sendEvent(
        new ChangeEvent(tv != null ? tv.value:
          dt is InputElement && (dt.type == 'checkbox' || dt.type == 'radio') ?
            (dt as InputElement).checked: (dt as dynamic).value));
          //assumes tv has a property called value (at least, dt has a value)
    };
  };
}
Map<String, _DomEventDispatcher> _domEvtDisps;

/** A virtual ID space.
 */
class _VirtualIdSpace implements IdSpace {
  View _owner;

  _VirtualIdSpace(this._owner) {
  }
  
  View query(String selector) => _owner.query(selector);
  List<View> queryAll(String selector) => _owner.queryAll(selector);
  final Map<String, View> fellows = new Map();

  String toString() => "_VirtualIdSpace($_owner)";
}

class _SubviewIter implements Iterator<View> {
  final View _owner;
  View _curr;
  bool _moved = false;

  _SubviewIter(this._owner);

  View get current => _curr;
  bool moveNext() {
    if (!_moved) {
      _moved = true;
      _curr = _owner.firstChild;
    } else if (_curr != null) {
      _curr = _curr.nextSibling;
    }
    return _curr != null;
  }
}
/**
 * A list of child views.
 * Notice that [set length] are not supported
 */
class _SubviewList extends Collection<View> implements List<View> {
  final View _owner;
  _SubviewList(View owner): _owner = owner;

  int get length => _owner.childCount;
  Iterator<View> get iterator => new _SubviewIter(_owner);
  View get last {
    if (isEmpty)
      throw new StateError("No elements");
    return _owner.lastChild;
  }
  
  View operator[](int index) {
    Arrays.rangeCheck(this, index, 1);

    int index2 = length - index - 1;
    if (index <= index2) {
      View child = _owner.firstChild;
      while (--index >= 0)
        child = child.nextSibling;
      return child;
    } else {
      View child = _owner.lastChild;
      while (--index2 >= 0)
        child = child.previousSibling;
      return child;
    }
  }
  void operator[]=(int index, View value) {
    if (value == null)
      throw new ArgumentError();

    final View w = this[index];
    if (!identical(w, value)) {
      final View next = w.nextSibling;
      w.remove();
      _owner.addChild(value, next);
    }
  }
  void add(View view) {
    _owner.addChild(view);
  }
  void addLast(View view) => add(view);
  void sort([Comparator<View> compare]) {
    List<View> copy = new List.from(this);
    copy.sort(compare);
    setRange(0, length, copy);
  }
  View removeLast() {
    final View w = last;
    if (w != null)
      w.remove();
    return w;
  }
  void setRange(int start, int length, List<View> from, [int startFrom]) {
    if (length <= 0)
      return; //nothing to do
    if (startFrom == null)
      startFrom = 0;

    if (start > this.length) {
      throw new RangeError(start);
    } else if (start == this.length) { //append
      if (startFrom == 0) { //optimize
        for (Iterator<View> it = from.iterator; --length >= 0;) {
          add((it..moveNext()).current);
        }
      } else {
        while (--length >= 0)
          add(from[startFrom++]);
      }
    } else if (startFrom == 0) { //optimize
      View w = this[start];
      Iterator<View> it = from.iterator;
      while (--length >= 0) { //replace
        View value = (it..moveNext()).current;
        final View next = w.nextSibling;
        if (!identical(w, value)) {
          w.remove();
          _owner.addChild(value, next);
        }
        if (next == null)
          break;
        w = next;
      }
      while (--length >= 0) //append
        add((it..moveNext()).current);
    } else {
      View w = this[start];
      while (--length >= 0) { //replace
        View value = from[startFrom++];
        final View next = w.nextSibling;
        if (!identical(w, value)) {
          w.remove();
          _owner.addChild(value, next);
        }
        if (next == null)
          break;
        w = next;
      }
      while (--length >= 0) //append
        add(from[startFrom++]);
    }
  }
  void removeRange(int start, int length) {
    if (length <= 0)
      return; //nothing to do

    View child = this[start];
    while (--length >= 0 && child != null) {
      final View next = child.nextSibling;
      child.remove();
      child = next;
    }
  }
  void insertRange(int start, int length, [View initialValue]) {
    if (length != 1)
      throw new ArgumentError("Allow only one view");
    if (initialValue == null)
      throw new ArgumentError("Require initialValue");
    if (start == this.length) {
      add(initialValue);
    } else {
      View w = this[start];
      _owner.addChild(initialValue, w);
    }
  }
  
  void set length(int newLength) {
    throw new UnsupportedError("Cannot set the length of view children list.");
  }
  
  int indexOf(View view, [int start = 0]) {
    if (start >= length)
      return -1;
    int i = start;
    for (View v = elementAt(max(start, 0)); v != null; v = v.nextSibling) {
      if (v == view)
        return i;
      i++;
    }
    return -1;
  }
  
  int lastIndexOf(View view, [int start]) {
    if (start < 0)
      return -1;
    bool fromLast = start == null || start >= length - 1;
    int i = fromLast ? length - 1 : start;
    for (View v = fromLast ? last : this[start]; v != null; v = v.previousSibling) {
      if (v == view)
        return i;
      i--;
    }
    return -1;
  }
  
  void remove(Object element) {
    if (element is View) {
      View v = element as View;
      if (v.parent == _owner)
        v.remove();
    }
  }
  
  View removeAt(int index) => this[index]..remove();

  void clear() {
    View child = _owner.firstChild;
    while (child != null) {
      final View next = child.nextSibling;
      child.remove();
      child = next;
    }
  }

  List<View> getRange(int start, int length) {
    final result = <View>[];
    for (int i = 0; i < length; i++)
      result.add(this[start + i]);
    return result;
  }

  List<View> get reversed {
    throw new UnsupportedError("TODO");
  }
}

/** The classes to add to the root node
 */
List<String> get _rootClasses {
  if (_$rootClasses == null) {
    _$rootClasses = ["rikulo", "v-${browser.name}"];
    if (browser.touch)
      _$rootClasses.add("v-touch");
    if (browser.ios)
      _$rootClasses.add("v-ios");
    else if (browser.android)
      _$rootClasses.add("v-android");
  }
  return _$rootClasses;
}
List<String> _$rootClasses;
