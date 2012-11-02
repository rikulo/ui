//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Mar 13, 2012  2:14:29 PM
// Author: tomyeh
part of rikulo_view;

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
class _HTMLView extends View {
  _HTMLView(String html) {
    node = new Element.html(html);
  }
  bool get isViewGroup => false;
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
  Map<String, EventListener> _domListeners;

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

    if (first)
      _owner.onEventListened_(type);
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
        if (ls.isEmpty)
          _owner.onEventUnlistened_(type);
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

  void onEventListened_(String type, Element target) {
    //proxy known DOM events
    final disp = _domEventDispatcher(type);
    if (disp != null) {
      final ln = disp(_owner); //must be non-null
      if (_domListeners == null)
        _domListeners = {};
      (target != null ? target: _domEvtTarget(type, _owner.node))
        .on[type.toLowerCase()].add(_domListeners[type] = ln);
    }
  }
  void onEventUnlistened_(String type, Element target) {
    EventListener ln;
    if (_domListeners != null
    && (ln = _domListeners.remove(type)) != null)
      (target != null ? target: _domEvtTarget(type, _owner.node))
        .on[type.toLowerCase()].remove(ln);
  }
}

/** DOM-level event listener that proxies a DOM event to a view event
 * ([ViewEvent]) and dispatch to the right target.
 */
typedef EventListener _DOMEventDispatcher(View target);

Element _domEvtTarget(String type, Element node) {
  //focus/blur not bubble up: http://www.quirksmode.org/js/tests/focusbubble.html
  //so we have to register it to the right element
  if (_noBubEvts.contains(type) && !_inpTags.contains(node.tagName.toLowerCase())) {
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
const _noBubEvts = const ["focus", "blur"];
final _inpTags = new Set.from(const ["input", "textarea", "select", "button", "a"]);
_DOMEventDispatcher _domEventDispatcher(String type) {
  if (_domEvtDisps == null) {
    _domEvtDisps = {};
    for (final nm in const ["abort", "click", "dblclick"
    "drag", "dragEnd", "dragEnter", "dragLeave", "dragOver", "dragStart", "drop",
    "error", "keyDown", "keyPress", "keyUp", "load",
    "mouseDown", "mouseMove", "mouseOut", "mouseOver", "mouseUp", "mouseWheel",
    "reset", "scroll", "select", "submit", "unload"])
      _domEvtDisps[nm] = _domEvtDisp(nm);
    for (final nm in _noBubEvts)
      _domEvtDisps[nm] = _domEvtDisp(nm);
    _domEvtDisps["change"] = _domChangeEvtDisp();
  }
  return _domEvtDisps[type];
}
_DOMEventDispatcher _domEvtDisp(String type) {
  return (View target) {
    return (Event event) {
      var tv = event.target; //the real target based on the event
      if (tv != null)
        tv = ViewUtil.getView(tv);
      target.sendEvent(new DOMEvent(event, type, tv != null ? tv: target));
    };
  };
}
_DOMEventDispatcher _domChangeEvtDisp() {
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
Map<String, _DOMEventDispatcher> _domEvtDisps;

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

class _SubviewSeq extends Sequence<View> {
  final View _owner;
  _SubviewSeq(this._owner);

  int get length => _owner.childCount;
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
}
/**
 * A list of child views.
 * Notice that [set length] are not supported
 */
class _SubviewList extends SequenceList<View> {
  final View _owner;
  _SubviewList(View owner): super(new _SubviewSeq(owner)), _owner = owner;

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

  CSSStyleDeclaration get _st => _view.node.style;
  String _g(String n) => getPropertyValue(CSS.name(n));
  void _s(String n, var v) => setProperty(CSS.name(n), v, '');

  String getPropertyValue(String propertyName)
  => _st.getPropertyValue(propertyName);
  String removeProperty(String propertyName)
  => _st.removeProperty(propertyName);
  CSSValue getPropertyCSSValue(String propertyName)
  => _st.getPropertyCSSValue(propertyName);
  String getPropertyPriority(String propertyName)
  => _st.getPropertyPriority(propertyName);
  String getPropertyShorthand(String propertyName)
  => _st.getPropertyShorthand(propertyName); 
  bool isPropertyImplicit(String propertyName)
  => _st.isPropertyImplicit(propertyName);

  void setProperty(String propertyName, String value, [String priority]) {
    if (?priority)
      _st.setProperty(propertyName, value, priority);
    else
      _st.setProperty(propertyName, value);
  }

  String get cssText => _st.cssText;
  void set cssText(String value) {
    final style = _st;
    style.cssText = value;
    style.left = CSS.px(_view.left);
    style.top = CSS.px(_view.top);
    if (_view.width != null)
      style.width = CSS.px(_view.width);
    if (_view.height != null)
      style.height = CSS.px(_view.height);
  }

  //@override
  int get length => _st.length;
  //@override
  String item(int index) => _st.item(index);
  //@override
  CSSRule get parentRule => _st.parentRule;

  //@override
  String get animation => _g('animation');
  void set animation(v) {_s('animation', v);}
  //@override
  String get animationDelay => _g('animation-delay');
  void set animationDelay(v) {_s('animation-delay', v);}
  //@override
  String get animationDirection => _g('animation-direction');
  void set animationDirection(v) {_s('animation-direction', v);}
  //@override
  String get animationDuration => _g('animation-duration');
  void set animationDuration(v) {_s('animation-duration', v);}
  //@override
  String get animationFillMode => _g('animation-fill-mode');
  void set animationFillMode(v) {_s('animation-fill-mode', v);}
  //@override
  String get animationIterationCount => _g('animation-iteration-count');
  void set animationIterationCount(v) {_s('animation-iteration-count', v);}
  //@override
  String get animationName => _g('animation-name');
  void set animationName(v) {_s('animation-name', v);}
  //@override
  String get animationPlayState => _g('animation-play-state');
  void set animationPlayState(v) {_s('animation-play-state', v);}
  //@override
  String get animationTimingFunction => _g('animation-timing-function');
  void set animationTimingFunction(v) {_s('animation-timing-function', v);}
  //@override
  String get appearance => _g('appearance');
  void set appearance(v) {_s('appearance', v);}
  //@override
  String get backfaceVisibility => _g('backface-visibility');
  void set backfaceVisibility(v) {_s('backface-visibility', v);}
  //@override
  String get background => _g('background');
  void set background(v) {_s('background', v);}
  //@override
  String get backgroundAttachment => _g('background-attachment');
  void set backgroundAttachment(v) {_s('background-attachment', v);}
  //@override
  String get backgroundClip => _g('background-clip');
  void set backgroundClip(v) {_s('background-clip', v);}
  //@override
  String get backgroundColor => _g('background-color');
  void set backgroundColor(v) {_s('background-color', v);}
  //@override
  String get backgroundComposite => _g('background-composite');
  void set backgroundComposite(v) {_s('background-composite', v);}
  //@override
  String get backgroundImage => _g('background-image');
  void set backgroundImage(v) {_s('background-image', v);}
  //@override
  String get backgroundOrigin => _g('background-origin');
  void set backgroundOrigin(v) {_s('background-origin', v);}
  //@override
  String get backgroundPosition => _g('background-position');
  void set backgroundPosition(v) {_s('background-position', v);}
  //@override
  String get backgroundPositionX => _g('background-position-x');
  void set backgroundPositionX(v) {_s('background-position-x', v);}
  //@override
  String get backgroundPositionY => _g('background-position-y');
  void set backgroundPositionY(v) {_s('background-position-y', v);}
  //@override
  String get backgroundRepeat => _g('background-repeat');
  void set backgroundRepeat(v) {_s('background-repeat', v);}
  //@override
  String get backgroundRepeatX => _g('background-repeat-x');
  void set backgroundRepeatX(v) {_s('background-repeat-x', v);}
  //@override
  String get backgroundRepeatY => _g('background-repeat-y');
  void set backgroundRepeatY(v) {_s('background-repeat-y', v);}
  //@override
  String get backgroundSize => _g('background-size');
  void set backgroundSize(v) {_s('background-size', v);}
  //@override
  String get border => _g('border');
  void set border(v) {_s('border', v);}
  //@override
  String get borderAfter => _g('border-after');
  void set borderAfter(v) {_s('border-after', v);}
  //@override
  String get borderAfterColor => _g('border-after-color');
  void set borderAfterColor(v) {_s('border-after-color', v);}
  //@override
  String get borderAfterStyle => _g('border-after-style');
  void set borderAfterStyle(v) {_s('border-after-style', v);}
  //@override
  String get borderAfterWidth => _g('border-after-width');
  void set borderAfterWidth(v) {_s('border-after-width', v);}
  //@override
  String get borderBefore => _g('border-before');
  void set borderBefore(v) {_s('border-before', v);}
  //@override
  String get borderBeforeColor => _g('border-before-color');
  void set borderBeforeColor(v) {_s('border-before-color', v);}
  //@override
  String get borderBeforeStyle => _g('border-before-style');
  void set borderBeforeStyle(v) {_s('border-before-style', v);}
  //@override
  String get borderBeforeWidth => _g('border-before-width');
  void set borderBeforeWidth(v) {_s('border-before-width', v);}
  //@override
  String get borderBottom => _g('border-bottom');
  void set borderBottom(v) {_s('border-bottom', v);}
  //@override
  String get borderBottomColor => _g('border-bottom-color');
  void set borderBottomColor(v) {_s('border-bottom-color', v);}
  //@override
  String get borderBottomLeftRadius => _g('border-bottom-left-radius');
  void set borderBottomLeftRadius(v) {_s('border-bottom-left-radius', v);}
  //@override
  String get borderBottomRightRadius => _g('border-bottom-right-radius');
  void set borderBottomRightRadius(v) {_s('border-bottom-right-radius', v);}
  //@override
  String get borderBottomStyle => _g('border-bottom-style');
  void set borderBottomStyle(v) {_s('border-bottom-style', v);}
  //@override
  String get borderBottomWidth => _g('border-bottom-width');
  void set borderBottomWidth(v) {_s('border-bottom-width', v);}
  //@override
  String get borderCollapse => _g('border-collapse');
  void set borderCollapse(v) {_s('border-collapse', v);}
  //@override
  String get borderColor => _g('border-color');
  void set borderColor(v) {_s('border-color', v);}
  //@override
  String get borderEnd => _g('border-end');
  void set borderEnd(v) {_s('border-end', v);}
  //@override
  String get borderEndColor => _g('border-end-color');
  void set borderEndColor(v) {_s('border-end-color', v);}
  //@override
  String get borderEndStyle => _g('border-end-style');
  void set borderEndStyle(v) {_s('border-end-style', v);}
  //@override
  String get borderEndWidth => _g('border-end-width');
  void set borderEndWidth(v) {_s('border-end-width', v);}
  //@override
  String get borderFit => _g('border-fit');
  void set borderFit(v) {_s('border-fit', v);}
  //@override
  String get borderHorizontalSpacing => _g('border-horizontal-spacing');
  void set borderHorizontalSpacing(v) {_s('border-horizontal-spacing', v);}
  //@override
  String get borderImage => _g('border-image');
  void set borderImage(v) {_s('border-image', v);}
  //@override
  String get borderImageOutset => _g('border-image-outset');
  void set borderImageOutset(v) {_s('border-image-outset', v);}
  //@override
  String get borderImageRepeat => _g('border-image-repeat');
  void set borderImageRepeat(v) {_s('border-image-repeat', v);}
  //@override
  String get borderImageSlice => _g('border-image-slice');
  void set borderImageSlice(v) {_s('border-image-slice', v);}
  //@override
  String get borderImageSource => _g('border-image-source');
  void set borderImageSource(v) {_s('border-image-source', v);}
  //@override
  String get borderImageWidth => _g('border-image-width');
  void set borderImageWidth(v) {_s('border-image-width', v);}
  //@override
  String get borderLeft => _g('border-left');
  void set borderLeft(v) {_s('border-left', v);}
  //@override
  String get borderLeftColor => _g('border-left-color');
  void set borderLeftColor(v) {_s('border-left-color', v);}
  //@override
  String get borderLeftStyle => _g('border-left-style');
  void set borderLeftStyle(v) {_s('border-left-style', v);}
  //@override
  String get borderLeftWidth => _g('border-left-width');
  void set borderLeftWidth(v) {_s('border-left-width', v);}
  //@override
  String get borderRadius => _g('border-radius');
  void set borderRadius(v) {_s('border-radius', v);}
  //@override
  String get borderRight => _g('border-right');
  void set borderRight(v) {_s('border-right', v);}
  //@override
  String get borderRightColor => _g('border-right-color');
  void set borderRightColor(v) {_s('border-right-color', v);}
  //@override
  String get borderRightStyle => _g('border-right-style');
  void set borderRightStyle(v) {_s('border-right-style', v);}
  //@override
  String get borderRightWidth => _g('border-right-width');
  void set borderRightWidth(v) {_s('border-right-width', v);}
  //@override
  String get borderSpacing => _g('border-spacing');
  void set borderSpacing(v) {_s('border-spacing', v);}
  //@override
  String get borderStart => _g('border-start');
  void set borderStart(v) {_s('border-start', v);}
  //@override
  String get borderStartColor => _g('border-start-color');
  void set borderStartColor(v) {_s('border-start-color', v);}
  //@override
  String get borderStartStyle => _g('border-start-style');
  void set borderStartStyle(v) {_s('border-start-style', v);}
  //@override
  String get borderStartWidth => _g('border-start-width');
  void set borderStartWidth(v) {_s('border-start-width', v);}
  //@override
  String get borderStyle => _g('border-style');
  void set borderStyle(v) {_s('border-style', v);}
  //@override
  String get borderTop => _g('border-top');
  void set borderTop(v) {_s('border-top', v);}
  //@override
  String get borderTopColor => _g('border-top-color');
  void set borderTopColor(v) {_s('border-top-color', v);}
  //@override
  String get borderTopLeftRadius => _g('border-top-left-radius');
  void set borderTopLeftRadius(v) {_s('border-top-left-radius', v);}
  //@override
  String get borderTopRightRadius => _g('border-top-right-radius');
  void set borderTopRightRadius(v) {_s('border-top-right-radius', v);}
  //@override
  String get borderTopStyle => _g('border-top-style');
  void set borderTopStyle(v) {_s('border-top-style', v);}
  //@override
  String get borderTopWidth => _g('border-top-width');
  void set borderTopWidth(v) {_s('border-top-width', v);}
  //@override
  String get borderVerticalSpacing => _g('border-vertical-spacing');
  void set borderVerticalSpacing(v) {_s('border-vertical-spacing', v);}
  //@override
  String get borderWidth => _g('border-width');
  void set borderWidth(v) {_s('border-width', v);}
  //@override
  String get bottom => _g('bottom');
  void set bottom(v) {_s('bottom', v);}
  //@override
  String get boxAlign => _g('box-align');
  void set boxAlign(v) {_s('box-align', v);}
  //@override
  String get boxDirection => _g('box-direction');
  void set boxDirection(v) {_s('box-direction', v);}
  //@override
  String get boxFlex => _g('box-flex');
  void set boxFlex(v) {_s('box-flex', v);}
  //@override
  String get boxFlexGroup => _g('box-flex-group');
  void set boxFlexGroup(v) {_s('box-flex-group', v);}
  //@override
  String get boxLines => _g('box-lines');
  void set boxLines(v) {_s('box-lines', v);}
  //@override
  String get boxOrdinalGroup => _g('box-ordinal-group');
  void set boxOrdinalGroup(v) {_s('box-ordinal-group', v);}
  //@override
  String get boxOrient => _g('box-orient');
  void set boxOrient(v) {_s('box-orient', v);}
  //@override
  String get boxPack => _g('box-pack');
  void set boxPack(v) {_s('box-pack', v);}
  //@override
  String get boxReflect => _g('box-reflect');
  void set boxReflect(v) {_s('box-reflect', v);}
  //@override
  String get boxShadow => _g('box-shadow');
  void set boxShadow(v) {_s('box-shadow', v);}
  //@override
  String get boxSizing => _g('box-sizing');
  void set boxSizing(v) {_s('box-sizing', v);}
  //@override
  String get captionSide => _g('caption-side');
  void set captionSide(v) {_s('caption-side', v);}
  //@override
  String get clear => _g('clear');
  void set clear(v) {_s('clear', v);}
  //@override
  String get clip => _g('clip');
  void set clip(v) {_s('clip', v);}
  //@override
  String get color => _g('color');
  void set color(v) {_s('color', v);}
  //@override
  String get colorCorrection => _g('color-correction');
  void set colorCorrection(v) {_s('color-correction', v);}
  //@override
  String get columnBreakAfter => _g('column-break-after');
  void set columnBreakAfter(v) {_s('column-break-after', v);}
  //@override
  String get columnBreakBefore => _g('column-break-before');
  void set columnBreakBefore(v) {_s('column-break-before', v);}
  //@override
  String get columnBreakInside => _g('column-break-inside');
  void set columnBreakInside(v) {_s('column-break-inside', v);}
  //@override
  String get columnCount => _g('column-count');
  void set columnCount(v) {_s('column-count', v);}
  //@override
  String get columnGap => _g('column-gap');
  void set columnGap(v) {_s('column-gap', v);}
  //@override
  String get columnRule => _g('column-rule');
  void set columnRule(v) {_s('column-rule', v);}
  //@override
  String get columnRuleColor => _g('column-rule-color');
  void set columnRuleColor(v) {_s('column-rule-color', v);}
  //@override
  String get columnRuleStyle => _g('column-rule-style');
  void set columnRuleStyle(v) {_s('column-rule-style', v);}
  //@override
  String get columnRuleWidth => _g('column-rule-width');
  void set columnRuleWidth(v) {_s('column-rule-width', v);}
  //@override
  String get columnSpan => _g('column-span');
  void set columnSpan(v) {_s('column-span', v);}
  //@override
  String get columnWidth => _g('column-width');
  void set columnWidth(v) {_s('column-width', v);}
  //@override
  String get columns => _g('columns');
  void set columns(v) {_s('columns', v);}
  //@override
  String get content => _g('content');
  void set content(v) {_s('content', v);}
  //@override
  String get counterIncrement => _g('counter-increment');
  void set counterIncrement(v) {_s('counter-increment', v);}
  //@override
  String get counterReset => _g('counter-reset');
  void set counterReset(v) {_s('counter-reset', v);}
  //@override
  String get cursor => _g('cursor');
  void set cursor(v) {_s('cursor', v);}
  //@override
  String get direction => _g('direction');
  void set direction(v) {_s('direction', v);}
  //@override
  String get display => _g('display');
  void set display(v) {_s('display', v);}
  //@override
  String get emptyCells => _g('empty-cells');
  void set emptyCells(v) {_s('empty-cells', v);}
  //@override
  String get filter => _g('filter');
  void set filter(v) {_s('filter', v);}
  //@override
  String get flexAlign => _g('flex-align');
  void set flexAlign(v) {_s('flex-align', v);}
  //@override
  String get flexFlow => _g('flex-flow');
  void set flexFlow(v) {_s('flex-flow', v);}
  //@override
  String get flexOrder => _g('flex-order');
  void set flexOrder(v) {_s('flex-order', v);}
  //@override
  String get flexPack => _g('flex-pack');
  void set flexPack(v) {_s('flex-pack', v);}
  //@override
  String get float => _g('float');
  void set float(v) {_s('float', v);}
  //@override
  String get flowFrom => _g('flow-from');
  void set flowFrom(v) {_s('flow-from', v);}
  //@override
  String get flowInto => _g('flow-into');
  void set flowInto(v) {_s('flow-into', v);}
  //@override
  String get font => _g('font');
  void set font(v) {_s('font', v);}
  //@override
  String get fontFamily => _g('font-family');
  void set fontFamily(v) {_s('font-family', v);}
  //@override
  String get fontFeatureSettings => _g('font-feature-settings');
  void set fontFeatureSettings(v) {_s('font-feature-settings', v);}
  //@override
  String get fontSize => _g('font-size');
  void set fontSize(v) {_s('font-size', v);}
  //@override
  String get fontSizeDelta => _g('font-size-delta');
  void set fontSizeDelta(v) {_s('font-size-delta', v);}
  //@override
  String get fontSmoothing => _g('font-smoothing');
  void set fontSmoothing(v) {_s('font-smoothing', v);}
  //@override
  String get fontStretch => _g('font-stretch');
  void set fontStretch(v) {_s('font-stretch', v);}
  //@override
  String get fontStyle => _g('font-style');
  void set fontStyle(v) {_s('font-style', v);}
  //@override
  String get fontVariant => _g('font-variant');
  void set fontVariant(v) {_s('font-variant', v);}
  //@override
  String get fontWeight => _g('font-weight');
  void set fontWeight(v) {_s('font-weight', v);}
  //@override
  String get height => _g('height');
  void set height(v) {_s('height', v);}
  //@override
  String get highlight => _g('highlight');
  void set highlight(v) {_s('highlight', v);}
  //@override
  String get hyphenateCharacter => _g('hyphenate-character');
  void set hyphenateCharacter(v) {_s('hyphenate-character', v);}
  //@override
  String get hyphenateLimitAfter => _g('hyphenate-limit-after');
  void set hyphenateLimitAfter(v) {_s('hyphenate-limit-after', v);}
  //@override
  String get hyphenateLimitBefore => _g('hyphenate-limit-before');
  void set hyphenateLimitBefore(v) {_s('hyphenate-limit-before', v);}
  //@override
  String get hyphenateLimitLines => _g('hyphenate-limit-lines');
  void set hyphenateLimitLines(v) {_s('hyphenate-limit-lines', v);}
  //@override
  String get hyphens => _g('hyphens');
  void set hyphens(v) {_s('hyphens', v);}
  //@override
  String get imageRendering => _g('image-rendering');
  void set imageRendering(v) {_s('image-rendering', v);}
  //@override
  String get left => _g('left');
  void set left(v) {_s('left', v);}
  //@override
  String get letterSpacing => _g('letter-spacing');
  void set letterSpacing(v) {_s('letter-spacing', v);}
  //@override
  String get lineBoxContain => _g('line-box-contain');
  void set lineBoxContain(v) {_s('line-box-contain', v);}
  //@override
  String get lineBreak => _g('line-break');
  void set lineBreak(v) {_s('line-break', v);}
  //@override
  String get lineClamp => _g('line-clamp');
  void set lineClamp(v) {_s('line-clamp', v);}
  //@override
  String get lineHeight => _g('line-height');
  void set lineHeight(v) {_s('line-height', v);}
  //@override
  String get listStyle => _g('list-style');
  void set listStyle(v) {_s('list-style', v);}
  //@override
  String get listStyleImage => _g('list-style-image');
  void set listStyleImage(v) {_s('list-style-image', v);}
  //@override
  String get listStylePosition => _g('list-style-position');
  void set listStylePosition(v) {_s('list-style-position', v);}
  //@override
  String get listStyleType => _g('list-style-type');
  void set listStyleType(v) {_s('list-style-type', v);}
  //@override
  String get locale => _g('locale');
  void set locale(v) {_s('locale', v);}
  //@override
  String get logicalHeight => _g('logical-height');
  void set logicalHeight(v) {_s('logical-height', v);}
  //@override
  String get logicalWidth => _g('logical-width');
  void set logicalWidth(v) {_s('logical-width', v);}
  //@override
  String get margin => _g('margin');
  void set margin(v) {_s('margin', v);}
  //@override
  String get marginAfter => _g('margin-after');
  void set marginAfter(v) {_s('margin-after', v);}
  //@override
  String get marginAfterCollapse => _g('margin-after-collapse');
  void set marginAfterCollapse(v) {_s('margin-after-collapse', v);}
  //@override
  String get marginBefore => _g('margin-before');
  void set marginBefore(v) {_s('margin-before', v);}
  //@override
  String get marginBeforeCollapse => _g('margin-before-collapse');
  void set marginBeforeCollapse(v) {_s('margin-before-collapse', v);}
  //@override
  String get marginBottom => _g('margin-bottom');
  void set marginBottom(v) {_s('margin-bottom', v);}
  //@override
  String get marginBottomCollapse => _g('margin-bottom-collapse');
  void set marginBottomCollapse(v) {_s('margin-bottom-collapse', v);}
  //@override
  String get marginCollapse => _g('margin-collapse');
  void set marginCollapse(v) {_s('margin-collapse', v);}
  //@override
  String get marginEnd => _g('margin-end');
  void set marginEnd(v) {_s('margin-end', v);}
  //@override
  String get marginLeft => _g('margin-left');
  void set marginLeft(v) {_s('margin-left', v);}
  //@override
  String get marginRight => _g('margin-right');
  void set marginRight(v) {_s('margin-right', v);}
  //@override
  String get marginStart => _g('margin-start');
  void set marginStart(v) {_s('margin-start', v);}
  //@override
  String get marginTop => _g('margin-top');
  void set marginTop(v) {_s('margin-top', v);}
  //@override
  String get marginTopCollapse => _g('margin-top-collapse');
  void set marginTopCollapse(v) {_s('margin-top-collapse', v);}
  //@override
  String get marquee => _g('marquee');
  void set marquee(v) {_s('marquee', v);}
  //@override
  String get marqueeDirection => _g('marquee-direction');
  void set marqueeDirection(v) {_s('marquee-direction', v);}
  //@override
  String get marqueeIncrement => _g('marquee-increment');
  void set marqueeIncrement(v) {_s('marquee-increment', v);}
  //@override
  String get marqueeRepetition => _g('marquee-repetition');
  void set marqueeRepetition(v) {_s('marquee-repetition', v);}
  //@override
  String get marqueeSpeed => _g('marquee-speed');
  void set marqueeSpeed(v) {_s('marquee-speed', v);}
  //@override
  String get marqueeStyle => _g('marquee-style');
  void set marqueeStyle(v) {_s('marquee-style', v);}
  //@override
  String get mask => _g('mask');
  void set mask(v) {_s('mask', v);}
  //@override
  String get maskAttachment => _g('mask-attachment');
  void set maskAttachment(v) {_s('mask-attachment', v);}
  //@override
  String get maskBoxImage => _g('mask-box-image');
  void set maskBoxImage(v) {_s('mask-box-image', v);}
  //@override
  String get maskBoxImageOutset => _g('mask-box-image-outset');
  void set maskBoxImageOutset(v) {_s('mask-box-image-outset', v);}
  //@override
  String get maskBoxImageRepeat => _g('mask-box-image-repeat');
  void set maskBoxImageRepeat(v) {_s('mask-box-image-repeat', v);}
  //@override
  String get maskBoxImageSlice => _g('mask-box-image-slice');
  void set maskBoxImageSlice(v) {_s('mask-box-image-slice', v);}
  //@override
  String get maskBoxImageSource => _g('mask-box-image-source');
  void set maskBoxImageSource(v) {_s('mask-box-image-source', v);}
  //@override
  String get maskBoxImageWidth => _g('mask-box-image-width');
  void set maskBoxImageWidth(v) {_s('mask-box-image-width', v);}
  //@override
  String get maskClip => _g('mask-clip');
  void set maskClip(v) {_s('mask-clip', v);}
  //@override
  String get maskComposite => _g('mask-composite');
  void set maskComposite(v) {_s('mask-composite', v);}
  //@override
  String get maskImage => _g('mask-image');
  void set maskImage(v) {_s('mask-image', v);}
  //@override
  String get maskOrigin => _g('mask-origin');
  void set maskOrigin(v) {_s('mask-origin', v);}
  //@override
  String get maskPosition => _g('mask-position');
  void set maskPosition(v) {_s('mask-position', v);}
  //@override
  String get maskPositionX => _g('mask-position-x');
  void set maskPositionX(v) {_s('mask-position-x', v);}
  //@override
  String get maskPositionY => _g('mask-position-y');
  void set maskPositionY(v) {_s('mask-position-y', v);}
  //@override
  String get maskRepeat => _g('mask-repeat');
  void set maskRepeat(v) {_s('mask-repeat', v);}
  //@override
  String get maskRepeatX => _g('mask-repeat-x');
  void set maskRepeatX(v) {_s('mask-repeat-x', v);}
  //@override
  String get maskRepeatY => _g('mask-repeat-y');
  void set maskRepeatY(v) {_s('mask-repeat-y', v);}
  //@override
  String get maskSize => _g('mask-size');
  void set maskSize(v) {_s('mask-size', v);}
  //@override
  String get matchNearestMailBlockquoteColor => _g('match-nearest-mail-blockquote-color');
  void set matchNearestMailBlockquoteColor(v) {_s('match-nearest-mail-blockquote-color', v);}
  //@override
  String get maxHeight => _g('max-height');
  void set maxHeight(v) {_s('max-height', v);}
  //@override
  String get maxLogicalHeight => _g('max-logical-height');
  void set maxLogicalHeight(v) {_s('max-logical-height', v);}
  //@override
  String get maxLogicalWidth => _g('max-logical-width');
  void set maxLogicalWidth(v) {_s('max-logical-width', v);}
  //@override
  String get maxWidth => _g('max-width');
  void set maxWidth(v) {_s('max-width', v);}
  //@override
  String get minHeight => _g('min-height');
  void set minHeight(v) {_s('min-height', v);}
  //@override
  String get minLogicalHeight => _g('min-logical-height');
  void set minLogicalHeight(v) {_s('min-logical-height', v);}
  //@override
  String get minLogicalWidth => _g('min-logical-width');
  void set minLogicalWidth(v) {_s('min-logical-width', v);}
  //@override
  String get minWidth => _g('min-width');
  void set minWidth(v) {_s('min-width', v);}
  //@override
  String get nbspMode => _g('nbsp-mode');
  void set nbspMode(v) {_s('nbsp-mode', v);}
  //@override
  String get opacity => _g('opacity');
  void set opacity(v) {_s('opacity', v);}
  //@override
  String get orphans => _g('orphans');
  void set orphans(v) {_s('orphans', v);}
  //@override
  String get outline => _g('outline');
  void set outline(v) {_s('outline', v);}
  //@override
  String get outlineColor => _g('outline-color');
  void set outlineColor(v) {_s('outline-color', v);}
  //@override
  String get outlineOffset => _g('outline-offset');
  void set outlineOffset(v) {_s('outline-offset', v);}
  //@override
  String get outlineStyle => _g('outline-style');
  void set outlineStyle(v) {_s('outline-style', v);}
  //@override
  String get outlineWidth => _g('outline-width');
  void set outlineWidth(v) {_s('outline-width', v);}
  //@override
  String get overflow => _g('overflow');
  void set overflow(v) {_s('overflow', v);}
  //@override
  String get overflowX => _g('overflow-x');
  void set overflowX(v) {_s('overflow-x', v);}
  //@override
  String get overflowY => _g('overflow-y');
  void set overflowY(v) {_s('overflow-y', v);}
  //@override
  String get padding => _g('padding');
  void set padding(v) {_s('padding', v);}
  //@override
  String get paddingAfter => _g('padding-after');
  void set paddingAfter(v) {_s('padding-after', v);}
  //@override
  String get paddingBefore => _g('padding-before');
  void set paddingBefore(v) {_s('padding-before', v);}
  //@override
  String get paddingBottom => _g('padding-bottom');
  void set paddingBottom(v) {_s('padding-bottom', v);}
  //@override
  String get paddingEnd => _g('padding-end');
  void set paddingEnd(v) {_s('padding-end', v);}
  //@override
  String get paddingLeft => _g('padding-left');
  void set paddingLeft(v) {_s('padding-left', v);}
  //@override
  String get paddingRight => _g('padding-right');
  void set paddingRight(v) {_s('padding-right', v);}
  //@override
  String get paddingStart => _g('padding-start');
  void set paddingStart(v) {_s('padding-start', v);}
  //@override
  String get paddingTop => _g('padding-top');
  void set paddingTop(v) {_s('padding-top', v);}
  //@override
  String get page => _g('page');
  void set page(v) {_s('page', v);}
  //@override
  String get pageBreakAfter => _g('page-break-after');
  void set pageBreakAfter(v) {_s('page-break-after', v);}
  //@override
  String get pageBreakBefore => _g('page-break-before');
  void set pageBreakBefore(v) {_s('page-break-before', v);}
  //@override
  String get pageBreakInside => _g('page-break-inside');
  void set pageBreakInside(v) {_s('page-break-inside', v);}
  //@override
  String get perspective => _g('perspective');
  void set perspective(v) {_s('perspective', v);}
  //@override
  String get perspectiveOrigin => _g('perspective-origin');
  void set perspectiveOrigin(v) {_s('perspective-origin', v);}
  //@override
  String get perspectiveOriginX => _g('perspective-origin-x');
  void set perspectiveOriginX(v) {_s('perspective-origin-x', v);}
  //@override
  String get perspectiveOriginY => _g('perspective-origin-y');
  void set perspectiveOriginY(v) {_s('perspective-origin-y', v);}
  //@override
  String get pointerEvents => _g('pointer-events');
  void set pointerEvents(v) {_s('pointer-events', v);}
  //@override
  String get position => _g('position');
  void set position(v) {_s('position', v);}
  //@override
  String get quotes => _g('quotes');
  void set quotes(v) {_s('quotes', v);}
  //@override
  String get regionBreakAfter => _g('region-break-after');
  void set regionBreakAfter(v) {_s('region-break-after', v);}
  //@override
  String get regionBreakBefore => _g('region-break-before');
  void set regionBreakBefore(v) {_s('region-break-before', v);}
  //@override
  String get regionBreakInside => _g('region-break-inside');
  void set regionBreakInside(v) {_s('region-break-inside', v);}
  //@override
  String get regionOverflow => _g('region-overflow');
  void set regionOverflow(v) {_s('region-overflow', v);}
  //@override
  String get resize => _g('resize');
  void set resize(v) {_s('resize', v);}
  //@override
  String get right => _g('right');
  void set right(v) {_s('right', v);}
  //@override
  String get rtlOrdering => _g('rtl-ordering');
  void set rtlOrdering(v) {_s('rtl-ordering', v);}
  //@override
  String get size => _g('size');
  void set size(v) {_s('size', v);}
  //@override
  String get speak => _g('speak');
  void set speak(v) {_s('speak', v);}
  //@override
  String get src => _g('src');
  void set src(v) {_s('src', v);}
  //@override
  String get tableLayout => _g('table-layout');
  void set tableLayout(v) {_s('table-layout', v);}
  //@override
  String get tapHighlightColor => _g('tap-highlight-color');
  void set tapHighlightColor(v) {_s('tap-highlight-color', v);}
  //@override
  String get textAlign => _g('text-align');
  void set textAlign(v) {_s('text-align', v);}
  //@override
  String get textCombine => _g('text-combine');
  void set textCombine(v) {_s('text-combine', v);}
  //@override
  String get textDecoration => _g('text-decoration');
  void set textDecoration(v) {_s('text-decoration', v);}
  //@override
  String get textDecorationsInEffect => _g('text-decorations-in-effect');
  void set textDecorationsInEffect(v) {_s('text-decorations-in-effect', v);}
  //@override
  String get textEmphasis => _g('text-emphasis');
  void set textEmphasis(v) {_s('text-emphasis', v);}
  //@override
  String get textEmphasisColor => _g('text-emphasis-color');
  void set textEmphasisColor(v) {_s('text-emphasis-color', v);}
  //@override
  String get textEmphasisPosition => _g('text-emphasis-position');
  void set textEmphasisPosition(v) {_s('text-emphasis-position', v);}
  //@override
  String get textEmphasisStyle => _g('text-emphasis-style');
  void set textEmphasisStyle(v) {_s('text-emphasis-style', v);}
  //@override
  String get textFillColor => _g('text-fill-color');
  void set textFillColor(v) {_s('text-fill-color', v);}
  //@override
  String get textIndent => _g('text-indent');
  void set textIndent(v) {_s('text-indent', v);}
  //@override
  String get textLineThrough => _g('text-line-through');
  void set textLineThrough(v) {_s('text-line-through', v);}
  //@override
  String get textLineThroughColor => _g('text-line-through-color');
  void set textLineThroughColor(v) {_s('text-line-through-color', v);}
  //@override
  String get textLineThroughMode => _g('text-line-through-mode');
  void set textLineThroughMode(v) {_s('text-line-through-mode', v);}
  //@override
  String get textLineThroughStyle => _g('text-line-through-style');
  void set textLineThroughStyle(v) {_s('text-line-through-style', v);}
  //@override
  String get textLineThroughWidth => _g('text-line-through-width');
  void set textLineThroughWidth(v) {_s('text-line-through-width', v);}
  //@override
  String get textOrientation => _g('text-orientation');
  void set textOrientation(v) {_s('text-orientation', v);}
  //@override
  String get textOverflow => _g('text-overflow');
  void set textOverflow(v) {_s('text-overflow', v);}
  //@override
  String get textOverline => _g('text-overline');
  void set textOverline(v) {_s('text-overline', v);}
  //@override
  String get textOverlineColor => _g('text-overline-color');
  void set textOverlineColor(v) {_s('text-overline-color', v);}
  //@override
  String get textOverlineMode => _g('text-overline-mode');
  void set textOverlineMode(v) {_s('text-overline-mode', v);}
  //@override
  String get textOverlineStyle => _g('text-overline-style');
  void set textOverlineStyle(v) {_s('text-overline-style', v);}
  //@override
  String get textOverlineWidth => _g('text-overline-width');
  void set textOverlineWidth(v) {_s('text-overline-width', v);}
  //@override
  String get textRendering => _g('text-rendering');
  void set textRendering(v) {_s('text-rendering', v);}
  //@override
  String get textSecurity => _g('text-security');
  void set textSecurity(v) {_s('text-security', v);}
  //@override
  String get textShadow => _g('text-shadow');
  void set textShadow(v) {_s('text-shadow', v);}
  //@override
  String get textSizeAdjust => _g('text-size-adjust');
  void set textSizeAdjust(v) {_s('text-size-adjust', v);}
  //@override
  String get textStroke => _g('text-stroke');
  void set textStroke(v) {_s('text-stroke', v);}
  //@override
  String get textStrokeColor => _g('text-stroke-color');
  void set textStrokeColor(v) {_s('text-stroke-color', v);}
  //@override
  String get textStrokeWidth => _g('text-stroke-width');
  void set textStrokeWidth(v) {_s('text-stroke-width', v);}
  //@override
  String get textTransform => _g('text-transform');
  void set textTransform(v) {_s('text-transform', v);}
  //@override
  String get textUnderline => _g('text-underline');
  void set textUnderline(v) {_s('text-underline', v);}
  //@override
  String get textUnderlineColor => _g('text-underline-color');
  void set textUnderlineColor(v) {_s('text-underline-color', v);}
  //@override
  String get textUnderlineMode => _g('text-underline-mode');
  void set textUnderlineMode(v) {_s('text-underline-mode', v);}
  //@override
  String get textUnderlineStyle => _g('text-underline-style');
  void set textUnderlineStyle(v) {_s('text-underline-style', v);}
  //@override
  String get textUnderlineWidth => _g('text-underline-width');
  void set textUnderlineWidth(v) {_s('text-underline-width', v);}
  //@override
  String get top => _g('top');
  void set top(v) {_s('top', v);}
  //@override
  String get transform => _g('transform');
  void set transform(v) {_s('transform', v);}
  //@override
  String get transformOrigin => _g('transform-origin');
  void set transformOrigin(v) {_s('transform-origin', v);}
  //@override
  String get transformOriginX => _g('transform-origin-x');
  void set transformOriginX(v) {_s('transform-origin-x', v);}
  //@override
  String get transformOriginY => _g('transform-origin-y');
  void set transformOriginY(v) {_s('transform-origin-y', v);}
  //@override
  String get transformOriginZ => _g('transform-origin-z');
  void set transformOriginZ(v) {_s('transform-origin-z', v);}
  //@override
  String get transformStyle => _g('transform-style');
  void set transformStyle(v) {_s('transform-style', v);}
  //@override
  String get transition => _g('transition');
  void set transition(v) {_s('transition', v);}
  //@override
  String get transitionDelay => _g('transition-delay');
  void set transitionDelay(v) {_s('transition-delay', v);}
  //@override
  String get transitionDuration => _g('transition-duration');
  void set transitionDuration(v) {_s('transition-duration', v);}
  //@override
  String get transitionProperty => _g('transition-property');
  void set transitionProperty(v) {_s('transition-property', v);}
  //@override
  String get transitionTimingFunction => _g('transition-timing-function');
  void set transitionTimingFunction(v) {_s('transition-timing-function', v);}
  //@override
  String get unicodeBidi => _g('unicode-bidi');
  void set unicodeBidi(v) {_s('unicode-bidi', v);}
  //@override
  String get unicodeRange => _g('unicode-range');
  void set unicodeRange(v) {_s('unicode-range', v);}
  //@override
  String get userDrag => _g('user-drag');
  void set userDrag(v) {_s('user-drag', v);}
  //@override
  String get userModify => _g('user-modify');
  void set userModify(v) {_s('user-modify', v);}
  //@override
  String get userSelect => _g('user-select');
  void set userSelect(v) {_s('user-select', v);}
  //@override
  String get verticalAlign => _g('vertical-align');
  void set verticalAlign(v) {_s('vertical-align', v);}
  //@override
  String get visibility => _g('visibility');
  void set visibility(v) {_s('visibility', v);}
  //@override
  String get whiteSpace => _g('white-space');
  void set whiteSpace(v) {_s('white-space', v);}
  //@override
  String get widows => _g('widows');
  void set widows(v) {_s('widows', v);}
  //@override
  String get width => _g('width');
  void set width(v) {_s('width', v);}
  //@override
  String get wordBreak => _g('word-break');
  void set wordBreak(v) {_s('word-break', v);}
  //@override
  String get wordSpacing => _g('word-spacing');
  void set wordSpacing(v) {_s('word-spacing', v);}
  //@override
  String get wordWrap => _g('word-wrap');
  void set wordWrap(v) {_s('word-wrap', v);}
  //@override
  String get wrapShape => _g('wrap-shape');
  void set wrapShape(v) {_s('wrap-shape', v);}
  //@override
  String get writingMode => _g('writing-mode');
  void set writingMode(v) {_s('writing-mode', v);}
  //@override
  String get zIndex => _g('z-index');
  void set zIndex(v) {_s('z-index', v);}
  //@override
  String get zoom => _g('zoom');
  void set zoom(v) {_s('zoom', v);}
}
