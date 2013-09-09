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
      Size old = new Size(window.innerWidth, window.innerHeight);
      return (event) { //DOM event
          final cur = new Size(window.innerWidth, window.innerHeight);
          if (old.width != cur.width || old.height < cur.height) {
            old = cur;
            _updRootSize();
          }
        };
    } else {
      return (event) { //DOM event
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
    _ChildInfo ci = view._childInfo;
    if (ci == null)
      ci = view._childInfo = new _ChildInfo();

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

    ++ci.nChild;
    if (child is IDSpace)
      addToIDSpace(child, true); //skip the first owner (i.e., child)
    else
      addToIDSpaceDown(child, child.spaceOwner);
  }
  static void unlink(View view, View child) {
    if (child is IDSpace)
      removeFromIDSpace(child, true); //skip the first owner (i.e., child)
    else
      removeFromIDSpaceDown(child, child.spaceOwner);

    final ci = view._childInfo;
    var p = child._prevSibling, n = child._nextSibling;
    if (p != null) p._nextSibling = n;
    else ci.firstChild = n;
    if (n != null) n._prevSibling = p;
    else ci.lastChild = p;
    child._nextSibling = child._prevSibling = child._parent = null;

    if (--ci.nChild == 0)
      view._childInfo = null; //save memory
  }

  //utilities//
  /** Creates a dialog encloser.
   */
  static DialogInfo createDialog(Element node, View view, [String maskClass="v-mask"]) {
    Size size = node == document.body ? DomUtil.windowSize: DomUtil.clientSize(node);

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
      DomUtil.hide(mask);
    
    parent.nodes.add(mask);
    return new DialogInfo(parent, mask);
  }

  //IDSpace//
  //-------//
  static IDSpace spaceOwner(View view) {
    View top, p = view;
    do {
      if (p is IDSpace)
        return p as IDSpace;
      top = p;
    } while ((p = p.parent) != null);

    if (top._virtIS == null)
      top._virtIS = new _VirtualIDSpace(top);
    return top._virtIS;
  }

  /** Checks the uniqueness in ID space when changing ID. */
  static void checkIDSpaces(View view, String newId) {
    IDSpace space = view.spaceOwner;
    if (space.fellows[newId] != null)
      throw new UIError("Not unique in the ID space of $space: $newId");

    //we have to check one level up if view is IDSpace (i.e., unique in two ID spaces)
    View parent;
    if (view is IDSpace && (parent = view.parent) != null) {
      space = parent.spaceOwner;
      if (space.fellows[newId] != null)
        throw new UIError("Not unique in the ID space of $space: $newId");
    }
  }
  //Add the given view to the ID space
  static void addToIDSpace(View view, [bool skipFirst=false]){
    String id = view.id;
    if (id.length == 0)
      return;

    if (!skipFirst)
      _addFellow(view.spaceOwner, id, view);

    //we have to put it one level up if view is IDSpace (i.e., unique in two ID spaces)
    View parent;
    if (view is IDSpace && (parent = view.parent) != null)
      _addFellow(parent.spaceOwner, id, view);
  }
  //Add the given view and all its children to the ID space
  static void addToIDSpaceDown(View view, var space) {
    var id = view.id;
    if (id.length > 0)
      _addFellow(space, id, view);

    if (view is! IDSpace) {
      final IDSpace vs = view._virtIS;
      if (vs != null) {
        view._virtIS = null;
        for (final child in vs.fellows.values)
          _addFellow(space, child.id, child);
      } else {
        for (view = view.firstChild; view != null; view = view.nextSibling)
          addToIDSpaceDown(view, space);
      }
    }
  }
  static void removeFromIDSpace(View view, [bool skipFirst=false]) {
    String id = view.id;
    if (id.length == 0)
      return;

    if (!skipFirst)
      _rmFellow(view.spaceOwner, id);

    //we have to put it one level up if view is IDSpace (i.e., unique in two ID spaces)
    View parent;
    if (view is IDSpace && (parent = view.parent) != null)
      _rmFellow(parent.spaceOwner, id);
  }
  static void removeFromIDSpaceDown(View view, var space) {
    var id = view.id;
    if (id.length > 0)
      _rmFellow(space, id);

    if (view is! IDSpace)
      for (view = view.firstChild; view != null; view = view.nextSibling)
        removeFromIDSpaceDown(view, space);
  }
}

void _addFellow(IDSpace space, String id, View fellow) {
  space.fellows[id] = fellow;
}
void _rmFellow(IDSpace space, String id) {
  space.fellows.remove(id);
}

/** The children information used in [View].
 * It is designed to save the memory use (since most of them has no child).
 */
class _ChildInfo {
  View firstChild, lastChild;
  int nChild = 0;
}

/** The information of an event listener used in [View].
 */
class _EventListenerInfo {
  final View _owner;
  ViewEvents on;
  //the registered event listeners; created on demand
  Map<String, List<ViewEventListener>> _listeners;
  //generic DOM subscriptions
  Map<String, StreamSubscription> _domSubscriptions;

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
  void add(String type, ViewEventListener listener) {
    if (listener == null)
      throw new ArgumentError("listener");

    if (_listeners == null)
      _listeners = new HashMap();

    bool first = false;
    _listeners.putIfAbsent(type, () {
      first = true;
      return [];
    }).add(listener);

    if (first)
      _owner.onDomEventListened_(type);
  }
  /** Removes an event listener. (Called by ViewEvents)
   */
  void remove(String type, ViewEventListener listener) {
    List<ViewEventListener> ls;
    if (_listeners != null && (ls = _listeners[type]) != null) {
      int j = ls.indexOf(listener);
      if (j >= 0) {
        ls.removeAt(j);
        if (ls.isEmpty)
          _owner.onDomEventUnlistened_(type);
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

  void onDomEventListened_(String type, Element target) {
    //proxy known DOM events
    final disp = _domEventDispatcher(type);
    if (disp != null) {
      final ln = disp(_owner); //must be non-null
      if (_domSubscriptions == null)
        _domSubscriptions = new HashMap();
      _domSubscriptions[type] =
        (target != null ? target: _domEvtTarget(type, _owner.node))
          .on[type.toLowerCase()].listen(ln);
    }
  }
  void onDomEventUnlistened_(String type) {
    if (_domSubscriptions != null) {
      final subscription = _domSubscriptions.remove(type);
      if (subscription != null)
        subscription.cancel();
    }
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
    _domEvtDisps = new HashMap();
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
        new ChangeEvent(tv != null ? (tv as dynamic).value:
          dt is InputElement && ((dt as InputElement).type == 'checkbox'
          || (dt as InputElement).type == 'radio') ?
            (dt as InputElement).checked: (dt as dynamic).value));
          //assumes tv has a property called value (at least, dt has a value)
    };
  };
}
Map<String, _DomEventDispatcher> _domEvtDisps;

/** A virtual ID space.
 */
class _VirtualIDSpace implements IDSpace {
  View _owner;

  _VirtualIDSpace(this._owner) {
  }
  
  View query(String selector) => _owner.query(selector);
  List<View> queryAll(String selector) => _owner.queryAll(selector);
  final Map<String, View> fellows = new HashMap();

  String toString() => "_VirtualIDSpace($_owner)";
}

class _SubviewIter implements Iterator<View> {
  final View _owner;
  View _curr;
  bool _moved = false;

  _SubviewIter(this._owner);

  @override
  View get current => _curr;
  @override
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
class _SubviewList extends IterableBase<View> with ListMixin<View>
    implements List<View> {
  final View _owner;
  _SubviewList(View owner): _owner = owner;

  @override
  int get length => _owner.childCount;
  @override
  Iterator<View> get iterator => new _SubviewIter(_owner);
  @override
  View get last {
    if (isEmpty)
      throw new StateError("No elements");
    return _owner.lastChild;
  }
  
  @override
  View operator[](int index) {
    if (index < 0 || index > length)
      throw new RangeError.value(index);

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
  @override
  View elementAt(int index) => this[index];
  @override
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
  @override
  void add(View view) {
    _owner.addChild(view);
  }
  @override
  void sort([Comparator<View> compare]) {
    List<View> copy = new List.from(this);
    copy.sort(compare);
    setRange(0, length, copy);
  }
  @override
  View removeLast() {
    final View w = _owner.lastChild;
    if (w != null)
      w.remove();
    return w;
  }
  void _rangeCheck(int start, int end) {
    if (start < 0 || start > this.length)
      throw new RangeError.range(start, 0, this.length);
    if (end < start || end > this.length)
      throw new RangeError.range(end, start, this.length);
  }
  @override
  void setRange(int start, int end, Iterable<View> iterable, [int skipCount = 0]) {
    _rangeCheck(start, end);
    int length = end - start;
    if (length == 0) return;
    if (skipCount < 0) throw new ArgumentError(skipCount);
    if (skipCount + length > iterable.length)
      throw new StateError("Not enough elements");

    final iter = iterable.skip(skipCount).iterator;
    if (start < this.length) {
      View dst = this[start];
      while (--length >= 0) { //replace
        View value = (iter..moveNext()).current;
        final next = dst.nextSibling;
        if (!identical(dst, value)) {
          dst.remove();
          _owner.addChild(value, next);
        }
        if ((dst = next) == null)
          break;
      }
    }
    while (--length >= 0) //append
      add((iter..moveNext()).current);
  }
  @override
  void removeRange(int start, int end) {
    _rangeCheck(start, end);
    int length = end - start;
    if (length == 0) return;

    View child = this[start];
    while (--length >= 0) {
      final View next = child.nextSibling;
      child.remove();
      child = next;
    }
  }
  @override
  void fillRange(int start, int end, [View fill]) {
    _rangeCheck(start, end);
    int length = end - start;
    if (length == 0) return;
    if (length != 1)
      throw new UnsupportedError("Only one view can be filled");
    this[start] = fill;
  }
  @override
  void insert(int index, View view) {
    _rangeCheck(index, this.length);
    if (index == this.length) {
      add(view);
    } else {
      _owner.addChild(view, this[index]);
    }
  }
  
  @override
  void set length(int newLength) {
    throw new UnsupportedError("Cannot set the length of view children list.");
  }
  @override
  int indexOf(View view, [int start = 0]) {
    if (start >= length || view.parent != _owner)
      return -1;
    int i = start;
    for (View v = this[max(start, 0)]; v != null; v = v.nextSibling) {
      if (v == view)
        return i;
      i++;
    }
    return -1;
  }
  @override
  int lastIndexOf(View view, [int start]) {
    if (start < 0 || view.parent != _owner)
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
  @override
  bool remove(Object element) {
    if (element is View) {
      View v = element as View;
      if (v.parent == _owner) {
        v.remove();
        return true;
      }
    }
    return false;
  }
  @override
  View removeAt(int index) => this[index]..remove();
  @override
  void clear() {
    removeRange(0, length);
  }
  @override
  List<View> sublist(int start, [int end]) {
    if (end == null) end = length;
    _rangeCheck(start, end);

    final result = <View>[];
    View view = this[start];
    for (int i = end - start; --i >= 0; view = view.nextSibling)
      result.add(view);
    return result;
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
