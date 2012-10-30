//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Mar 13, 2012  2:14:29 PM
// Author: tomyeh

/** Used by View.tag()
 */
class _TagView extends View {
  final bool _vgroup;

  _TagView(String tag, Map<String, dynamic> attrs, String inner, bool this._vgroup) {
    final out = new StringBuffer().add('<').add(tag);
    if (attrs != null)
      attrs.forEach((key, value) {
          out.add(' ').add(key).add('="');
          if (value != null)
            out.add(value);
          out.add('"');
        });
      out.add('>');
      if (inner != null)
        out.add(inner);
      out.add('</').add(tag).add('>');
    node = new Element.html(out.toString());
  }

  bool get isViewGroup => _vgroup;
}

/** Collection of utilities for View's implementation
 */
class _ViewImpl {
  //System Initialization//
  static void init() {
    if (!_inited) {
      _inited = true;
      window.on.resize.add(_onResize);
      (browser.touch ? document.on.touchStart: document.on.mouseDown).add(_onTouchStart);
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
  static EventListener _$onTouchStart;
  static EventListener get _onTouchStart {
    if (_$onTouchStart == null)
      _$onTouchStart = (event) { //DOM event
        broadcaster.sendEvent(new ActivateEvent(event.target));
      };
    return _$onTouchStart;
  }
  //TODO: use const if Dart considers closure as constants (also check Issue 3905)

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

  //Event Handlign//
  //--------------//
  static DOMEventDispatcher getDOMEventDispatcher(String type) {
    if (_domEvtDisps == null) {
      _domEvtDisps = {};
      for (final String nm in
      const ["blur", "click",
      "drag", "dragEnd", "dragEnter", "dragLeave", "dragOver", "dragStart", "drop",
      "focus",
      "mouseDown", "mouseMove", "mouseOut", "mouseOver", "mouseUp", "mouseWheel",
      "scroll"]) {
        _domEvtDisps[nm] = _domEvtDisp(nm);
      }
      _domEvtDisps["change"] = _domChangeEvtDisp();

      //TODO: handle keyDown/keyPress/keyUp with KeyEvent
      //TODO: handle mouseXxx with MouseEvent
    }
    return _domEvtDisps[type];
  }
  static DOMEventDispatcher _domEvtDisp(String type) {
    return (View target) {
      return (Event event) {
        var tv = event.target; //the real target based on the event
        if (tv != null)
          tv = ViewUtil.getView(tv);
        target.sendEvent(
          new ViewEvent.dom(event, type, tv != null ? tv: target));
      };
    };
  }
  static DOMEventDispatcher _domChangeEvtDisp() {
    return (View target) {
      return (Event event) {
        final dt = event.target;
        var tv = dt; //the real target based on the event
        if (tv != null)
          tv = ViewUtil.getView(tv);
        target.sendEvent(
          new ChangeEvent(tv != null ? tv.value:
            dt is InputElement && (dt.type == 'checkbox' || dt.type == 'radio') ?
              dt.checked: dt.value));
            //assumes tv has a property called value (at least, dt has a value)
      };
    };
  }
  static Map<String, DOMEventDispatcher> _domEvtDisps;

  //utilities//
  /** Creates a dialog encloser.
   */
  static DialogInfo createDialog(Element node, View view, [String maskClass="v-mask"]) {
    Size size = node == document.body ?
      browser.innerSize: new DOMAgent(node).innerSize;

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
      new DOMAgent(mask).hide();
    
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
    if (space.getFellow(newId) != null)
      throw new UIException("Not unique in the ID space of $space: $newId");

    //we have to check one level up if view is IdSpace (i.e., unique in two ID spaces)
    View parent;
    if (view is IdSpace && (parent = view.parent) != null) {
      space = parent.spaceOwner;
      if (space.getFellow(newId) != null)
        throw new UIException("Not unique in the ID space of $space: $newId");
    }
  }
  //Add the given view to the ID space
  static void addToIdSpace(View view, [bool skipFirst=false]){
    String id = view.id;
    if (id.length == 0)
      return;

    if (!skipFirst)
      (view.spaceOwner as dynamic).bindFellow_(id, view);

    //we have to put it one level up if view is IdSpace (i.e., unique in two ID spaces)
    View parent;
    if (view is IdSpace && (parent = view.parent) != null)
      (parent.spaceOwner as dynamic).bindFellow_(id, view);
  }
  //Add the given view and all its children to the ID space
  static void addToIdSpaceDown(View view, var space) {
    var id = view.id;
    if (id.length > 0)
      space.bindFellow_(id, view);

    if (view is! IdSpace) {
      final IdSpace vs = view._virtIS;
      if (vs != null) {
        view._virtIS = null;
        for (final View child in vs.fellows)
          space.bindFellow_(child.id, child);
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
      (view.spaceOwner as dynamic).bindFellow_(id, null);

    //we have to put it one level up if view is IdSpace (i.e., unique in two ID spaces)
    View parent;
    if (view is IdSpace && (parent = view.parent) != null)
      (parent.spaceOwner as dynamic).bindFellow_(id, null);
  }
  static void removeFromIdSpaceDown(View view, var space) {
    var id = view.id;
    if (id.length > 0)
      space.bindFellow_(id, null);

    if (view is! IdSpace)
      for (view = view.firstChild; view != null; view = view.nextSibling)
        removeFromIdSpaceDown(view, space);
  }
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
  Map<String, EventListener> domListeners;

  _EventListenerInfo(View this._owner) {
    on = new ViewEvents(this);
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
      throw const UIException("listener required");

    if (_listeners == null)
      _listeners = {};

    bool first = false;
    _listeners.putIfAbsent(type, () {
      first = true;
      return [];
    }).add(listener);

    DOMEventDispatcher disp;
    if (first && _owner.inDocument
    && (disp = _owner.getDOMEventDispatcher_(type)) != null)
      _owner.domListen_(_owner.node, type, disp);
  }
  /** Removes an event listener. (Called by ViewEvents)
   */
  bool remove(String type, ViewEventListener listener) {
    List<ViewEventListener> ls;
    bool found = false;
    if (_listeners != null && (ls = _listeners[type]) != null) {
      int j = ls.indexOf(listener);
      if (j >= 0) {
        found = true;

        ls.removeRange(j, 1);
        if (ls.isEmpty && _owner.inDocument
        && _owner.getDOMEventDispatcher_(type) != null)
          _owner.domUnlisten_(_owner.node, type);
      }
    }
    return found;
  }
  /** Sends an event. (Called by ViewEvents)
   */
  bool send(ViewEvent event, [String type]) {
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
  /** Called when _owner is mounted. */
  void mount() {
    //Listen the DOM element if necessary
    if (_listeners != null) {
      final Element n = _owner.node;
      for (final String type in _listeners.keys) {
        final DOMEventDispatcher disp = _owner.getDOMEventDispatcher_(type);
        if (disp != null && !_listeners[type].isEmpty)
          _owner.domListen_(n, type, disp);
      }
    }
  }
  void unmount() {
    //Unlisten the DOM element if necessary
    if (_listeners != null) {
      final Element n = _owner.node;
      for (final String type in _listeners.keys) {
        if (_owner.getDOMEventDispatcher_(type) != null && !_listeners[type].isEmpty)
          _owner.domUnlisten_(n, type);
      }
    }
  }
}

/** A virtual ID space.
 */
class _VirtualIdSpace implements IdSpace {
  View _owner;
  Map<String, View> _fellows;

  _VirtualIdSpace(this._owner): _fellows = {};
  
  View query(String selector) => _owner.query(selector);
  List<View> queryAll(String selector) => _owner.queryAll(selector);

  View getFellow(String id) => _fellows[id];
  void bindFellow_(String id, View fellow) {
    if (fellow != null) _fellows[id] = fellow;
    else _fellows.remove(id);
  }
  Collection<View> get fellows => _fellows.values;
  String toString() => "_VirtualIdSpace($_owner: $_fellows)";
}

/**
 * A list of child views.
 * Notice that [set length] are not supported
 */
class _SubviewList extends AbstractList<View> {
  final View _owner;

  _SubviewList(this._owner);

  //Iterable//
  Iterator<View> iterator() {
    return new _SVIterator(_owner);
  }

  //Collection//
  int get length => _owner.childCount;

  //List//
  View operator[](int index) {
    ListUtil.rangeCheck(this, index, 1);

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
      throw const IllegalArgumentException("null");

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
  void sort([Comparator<View> compare = Comparable.compare]) {
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
  View get last {
    return _owner.lastChild;
  }
  void setRange(int start, int length, List<View> from, [int startFrom]) {
    if (length <= 0)
      return; //nothing to do
    if (startFrom == null)
      startFrom = 0;

    if (start > this.length) {
      throw new IndexOutOfRangeException(start);
    } else if (start == this.length) { //append
      if (startFrom == 0) { //optimize
        for (Iterator<View> it = from.iterator(); --length >= 0;) {
          add(it.next());
        }
      } else {
        while (--length >= 0)
          add(from[startFrom++]);
      }
    } else if (startFrom == 0) { //optimize
      View w = this[start];
      Iterator<View> it = from.iterator();
      while (--length >= 0) { //replace
        View value = it.next();
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
        add(it.next());
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
      throw const IllegalArgumentException("Allow only one view");
    if (initialValue == null)
      throw const IllegalArgumentException("Require initialValue");
    if (start == this.length) {
      add(initialValue);
    } else {
      View w = this[start];
      _owner.addChild(initialValue, w);
    }
  }
}

/** _SubviewList's iterator.
 */
class _SVIterator implements Iterator<View> {
  View _next;

  _SVIterator(View owner) {
    _next = owner.firstChild;
  }

  bool get hasNext {
    return _next != null;
  }
  View next() {
    if (_next == null)
      throw new StateError("No more elements");
    View nxt = _next;
    _next = _next.nextSibling;
    return nxt;
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

//TODO: use mixin or dyanmic proxy when it is ready
class _CSSStyleImpl implements CSSStyleDeclaration {
  final View _view;
  _CSSStyleImpl(View this._view);

  String getPropertyValue(String propertyName)
  => _view.node.style.getPropertyValue(propertyName);
  String removeProperty(String propertyName)
  => _view.node.style.removeProperty(propertyName);

  void setProperty(String propertyName, String value, [String priority]) {
    if (?priority)
      _view.node.style.setProperty(propertyName, value, priority);
    else
      _view.node.style.setProperty(propertyName, value);
  }

  String get cssText => _view.node.style.cssText;
  void set cssText(String value) {
    final style = _view.node.style;
    style.cssText = value;
    style.left = CSS.px(_view.left);
    style.top = CSS.px(_view.top);
    if (_view.width != null)
      style.width = CSS.px(_view.width);
    if (_view.height != null)
      style.height = CSS.px(_view.height);
  }
  dynamic noSuchMethod(String name, List args) {
    if (name.startsWith("set:"))
      return setProperty(StringUtil.uncamelize(name.substring(4)), args[0], '');
    else if (name.startsWith("get:"))
      return getPropertyValue(StringUtil.uncamelize(name.substring(4)));
    return super.noSuchMethod(name, args);
  }
}

