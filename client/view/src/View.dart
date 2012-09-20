//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jan 9, 2012 13:01:36
// Author: tomyeh

/** An effect for the given view, such as fade-in and slide-out.
 */
typedef void ViewEffect(View view);

/** Called after views are added to the document, and
 * all [View.mount_] methods are called.
 */ 
typedef void AfterMount(View view);

/**
 * A view represents the basic building block for user interface.
 * A view occupies a rectangular area on the screen and the
 * interfaces for managing the content and event handling in the area.
 *
 * ##ID Space
 *
 * If a view implements [IdSpace], it and its descendants are considered
 * as a ID space. And, the topmost view is the owner.
 * The ID ([id]) of a view in the given ID space must be unique.
 * On the other hand, views in different ID spaces can have the same ID.
 *
 * Notice that if a view implements [IdSpace], it has to override
 * [getFellow] and [bindFellow_]. Please refer to [Section] for sample code.
 *
 * ##Events
 *
 * + `layout`: an instance of [LayoutEvent] indicates the layout of this view
 * has been handled.
 * + `prelayout`: an instance of [LayoutEvent] indicates the layout of this view
 * will be handled.
 * + `mount`: an instance of [ViewEvent] indicates this view has been
 * added to the document.
 * + `unmount`: an instance of [ViewEvent] indicates this view will be
 * removed from the document.
 *
 * ##Default CSS classes
 *
 * Default [classes]: "v-$className"
 * (note: "v-" is actually [viewConfig.classPrefix])
 *
 * ##See Also
 *
 * + [ViewUtil]
 */
class View implements Hashable {
  String _id = "";
  String _uuid;

  View _parent;
  View _nextSibling, _prevSibling;
  //Virtual ID space. Used only if this is root but not IdSpace
  IdSpace _virtIS;

  _ChildInfo _childInfo;
  _EventListenerInfo _evlInfo;
  Map<String, Dynamic> _dataAttrs, _mntAttrs;
  Map<String, Template> _templs;
  Map<String, Annotation> _annos;

  //the classes; created on demand
  Set<String> _classes;
  //the CSS style; created on demand
  CSSStyleDeclaration _style;
  Element _node;

  int _left = 0, _top = 0, _width, _height;
  ProfileDeclaration _profile;
  LayoutDeclaration _layout;

  bool _visible = true, _draggable = false, _inDoc = false;

  /** Constructor.
   */
  View() {
    _classes = new _ClassSet(this);
    _classes.add("${viewConfig.classPrefix}$className");
  }
  /** Instantiates a view by using the given HTML tag.
   * For example,
   *
   *     new View.tag("section");
   *     new View.tag("header", {"conteneditable": true, "draggable": true});
   *
   * It is useful if you'd like to encapsulate an element that is made of
   * [Shadow DOM](http://dvcs.w3.org/hg/webcomponents/raw-file/tip/explainer/index.html#shadow-dom-section).
   *
   * Notice that the view is positioned absolutely. It is different from
   * the default behavior the most HTML elements. If you want to create a HTML fragment,
   * you can use [TextView.fromHTML] instead, since it is much simpler.
   *
   *     new TextView.fromHTML('''
   *       <table cellapding="10" border="1"><tr><td>Cell 1.1</td></tr></table>
   *       ''');
   *
   * + [tag] specifies the HTML tag name, such as `section` and `article`.
   * + [attributes] specifies a map of attributes to be assigned.
   * The value will be converted to a string. If null, an empty string is assumed.  
   * Notice that the key can't be `id`, `style` and `class`.
   * Also notice that the value won't be encoded, so it is caller's job to avoid
   * so-called *HTML injection*.
   * + [innerHTML] specified the inner HTML fragment, such as "Drame come <i>true<i>".
   * It won't be encoded, so it is caller's job to avoid so-called *HTML injection*.
   * It will be generated before any child view's content.
   * + [isViewGroup] specifies whether it is a view group ([isViewGroup]).
   * Default: true. Notice that it affects how the width and height are measured.
   * Basically if it doesn't allow any child view, it is better to specify false here.
   * Please refer to [isViewGroup] for more information.
   */
  factory View.tag(String tag, [Map<String,Dynamic> attributes,
    String innerHTML, bool isViewGroup=true])
  => new _TagView(tag, attributes, innerHTML, isViewGroup);

  /** Returns the Dart class name.
   * The subclass shall override it.
   * However, it will be removed if Dart supports reflection.
   */
  String get className => "View"; //TODO: replace with reflection if Dart supports it

  _ChildInfo _initChildInfo() {
    if (_childInfo == null)
      _childInfo = new _ChildInfo();
    return _childInfo;
  }
  _EventListenerInfo _initEventListenerInfo() {
    if (_evlInfo == null)
      _evlInfo = new _EventListenerInfo(this);
    return _evlInfo;
  }

  /** Returns the UUID of this component, never null.
   */
  String get uuid {
    if (_uuid == null)
      _uuid = StringUtil.encodeId(_uuidNext++, viewConfig.uuidPrefix);
    return _uuid;
  }
  static int _uuidNext = 0;

  /** Returns the ID of this view, or an empty string if not assigned.
   */
  String get id {
    return _id;
  }
  /** Sets the ID of this view.
   */
  void set id(String id) {
    if (id == null) id = "";
    if (_id != id) {
      if (id.length > 0)
        _ViewImpl.checkIdSpaces(this, id);
      _ViewImpl.removeFromIdSpace(this);
      _id = id;
      _ViewImpl.addToIdSpace(this);
    }
  }
  /** Searches and returns the first view that matches the given selector.
   *
   * Notice that, in additions to CSS selector, it also supports
   * "parent" for identifying the parent, "spaceOwner" for the space owner.
   *
   * It returns null if selector is null or empty.
   */
  View query(String selector) {
    if (selector == null)
      return null;
    switch (selector) {
      case "": return null;
      case "parent": return parent;
      case "spaceOwner":
        var so = spaceOwner;
        return so is View ? so as View : null;
    }

    final Iterator<View> iter = queryAll(selector).iterator();
    return iter.hasNext() ? iter.next() : null;
  }
  /** Searches and returns all views that matches the selector.
   */
  Iterable<View> queryAll(String selector) {
    return new ViewIterable(this, selector);
  }
  /** Returns the view of the given ID in the ID space this view belongs to,
   * or null if not found.
   *
   * If a view implements [IdSpace] must override [getFellow] and
   * [bindFellow_].
   */
  View getFellow(String id) => spaceOwner.getFellow(id);
  /** Returns a read-only collection of all fellows in the ID space
   * that this view belongs to.
   *
   * Note: don't modify the returned list. Otherwise, the result is
   * unpredictable.
   */
  Collection<View> get fellows => spaceOwner.fellows;
  /** Updates the fellow information.
   *
   * Default: throw [UnsupportedOperationException].
   *
   * If a view implements [IdSpace] must override [getFellow] and
   * [bindFellow_].
   *
   * If fellow is null, it means to remove the binding.
   */
  void bindFellow_(String id, View fellow) {
    throw const UnsupportedOperationException ("Not IdSpace");
  }
  /** Returns the owner of the ID space that this view belongs to.
   *
   * A virtual [IdSpace] is used if this view is a root but is not IdSpace.
   */
  IdSpace get spaceOwner => _ViewImpl.spaceOwner(this);

  /** Returns if a view is a descendant of this view or
   * it is identical to this view.
   */
  bool isDescendantOf(View parent) {
    for (View w = this; w != null; w = w.parent) {
      if (w === parent)
        return true;
    }
    return false;
  }
  /** Returns the nearest ancestor who is an instance of the given class,
   * or null if not found.
   */
/* TODO: wait until Dart supports reflection
  View getAncestorWith(Class type) {
    for (View p = this; (p = p.parent) != null;) {
      if (p is type)
        return p;
    }
    return null;
  }
*/
  /** Returns the parent, or null if this view does not have any parent.
   */
  View get parent => _parent;
  /** Returns the first child, or null if this view has no child at all.
   */
  View get firstChild => _childInfo != null ? _childInfo.firstChild: null;
  /** Returns the last child, or null if this view has no child at all.
   */
  View get lastChild => _childInfo != null ? _childInfo.lastChild: null;
  /** Returns the next sibling, or null if this view is the last sibling.
   */
  View get nextSibling => _nextSibling;
  /** Returns the previous sibling, or null if this view is the first sibling.
   */
  View get previousSibling => _prevSibling;
  /** Returns a list of child views.
   */
  List<View> get children {
    final _ChildInfo ci = _initChildInfo();
    if (ci.children == null)
      ci.children = new _SubviewList(this);
    return ci.children;
  }
  /** Returns the number of child views.
   */
  int get childCount => _childInfo != null ? _childInfo.nChild: 0;

  /** Callback AFTER a child has been added.
   *
   * Default: does nothing.
   */
  void onChildAdded_(View child) {}
  /** Callback when a child is going to be removed.
   *
   * Default: does nothing.
   */
  void beforeChildRemoved_(View child) {}
  /** Callback after a child has been removed.
   *
   * Default: does nothing.
   */
  void onChildRemoved_(View child) {}
  /** Callback after this view's parent has been changed.
   */
  void onParentChanged_(View oldParent) {}
  /** Callback before this view's parent is going to change.
   */
  void beforeParentChanged_(View newParent) {}
  /** Called after the layout of this view and all its descendant views
   * have been handled.
   *
   * Default: does nothing but fire a [LayoutEvent] to itself.
   * The application can listen `layout` for this event.
   */
  void onLayout_(MeasureContext mctx) {
    sendEvent(new LayoutEvent(mctx));
  }
  /** Called before handling this view and any of its descendant views.
   *
   * Default: does nothing but fire a [LayoutEvent] to itself.
   * The application can listen `preLayout` for this event.
   */
  void onPreLayout_(MeasureContext mctx) {
    sendEvent(new LayoutEvent(mctx, "preLayout"));
  }

  /** Returns whether this view is a view group.
   * By view group we mean a view that a user can add child views
   * to it (by use of [addChild]).
   *
   * Default: true.
   *
   * The deriving class shall override this method
   * to return false if it doesn't allow any child views.
   *
   * Notice if it also affects how [measureWidth_] and [measureHeight_] measures.
   * If it returns false, the width and height are measured by on its content
   * (i.e., it is decided by the browser). If it returns true, they are measured
   * by the child views (i.e., decided by the layout and other factors).
   */
  bool isViewGroup() => true;

  /** Adds a child.
   * If [beforeChild] is specified, the child will be inserted before it.
   * Otherwise, it will be added to the end.
   *
   * If this view is attached to the document, this method will attach the child
   * to the document.
   */
  void addChild(View child, [View beforeChild]) {
    _addChild(child, beforeChild);
  }
  void _addChild(View child, View beforeChild, [Element childNode]) {
    if (isDescendantOf(child))
      throw new UIException("$child is an ancestor of $this");
    if (!isViewGroup())
      throw new UIException("No child allowed for $this");

    if (beforeChild != null) {
      if (beforeChild.parent !== this)
        beforeChild = null;
      else if (child === beforeChild)
        return; //nothing to change
    }

    final View oldParent = child.parent;
    final bool parentChanged = oldParent !== this;
    if (!parentChanged && beforeChild === child.nextSibling)
      return; //nothing to change

    if (parentChanged)
      child.beforeParentChanged_(this);
    if (oldParent != null)
      oldParent._removeChild(child, notifyChild:false);

    _ViewImpl.link(this, child, beforeChild);

    if (inDocument) {
      if (childNode != null) {
        insertChildToDocument_(child, childNode, beforeChild);
      } else {
        insertChildToDocument_(child, child._asHTML(), beforeChild);
        child._mount();
        //note: child.requestLayout won't be called (for sake of performance)
      }
    }

    onChildAdded_(child);
    if (parentChanged)
      child.onParentChanged_(oldParent);
  }

  /** Removes this view from its parent.
   *
   * If this view has no parent, [UIException] will be thrown.
   * Rather, if you'd like to remove [Activity.mainView], assign another view
   * to [Activity.mainView]. If you'd like to remove a dialog, use [Activity.removeDialog]
   * instead.
   *
   * If the view is in the document ([inDocument] is true), the DOM
   * element will be removed too. Furthermore, if the view is added back
   * to the document, a new DOM element will be created to represent the child.
   *
   * If you just want to move the child, you can use the so-called
   * cut-and-paste. It won't re-create the DOM element, so the performance
   * is better. Please refer to [cut] for more information.
   * If it is a root view, it will be detached from the document.
   */
  void removeFromParent() {
    if (parent == null)
      throw new UIException("Unable to remove a root view, $this");
    parent._removeChild(this);
  }
  void _removeChild(View child, [bool notifyChild=true, bool exit=true]) {
    if (child.parent !== this)
      return;

    beforeChildRemoved_(child);
    if (notifyChild)
      child.beforeParentChanged_(null);

    if (inDocument) {
      final Element childNode = child.node; //cache first since not callable after _unmount 
      if (exit)
        child._unmount();
      removeChildFromDocument_(child, childNode);
    }
    _ViewImpl.unlink(this, child);

    if (notifyChild)
      child.onParentChanged_(this);
    onChildRemoved_(child);
  }

  /** Cuts this view and the DOM elements from its parent.
   * It is the first step of the so-called cut-and-paste.
   * Unlike [removeFromParent], the DOM element will be kept intact (though it is
   * removed from the document). Then, you can attach both the view and DOM
   * element back by use of [ViewCut.pasteTo]. For example,
   *
   *     view.cut().pasteTo(newParent);
   *
   * Since the DOM element is kept intact, the performance is better
   * then remove-and-add (with [removeFromParent] and [addChild]).
   * However, unlike remove-and-add, you cannot modify the view after it
   * is cut (until it is pasted back). Otherwise, the result is unpredictable.
   *
   * Notice that, like [removeFromParent], it can't be called if this view
   * is a root view (i.e., it has no parent).
   */
  ViewCut cut() => new _ViewCut(this);

  /** Inserts the DOM element of the given [child] view before
   * the reference view ([beforeChild]).
   * It is called by [addChild] to attach the DOM elements to the document.
   *
   * Deriving classes might override this method to modify the HTML content,
   * such as enclosing with TD, or to insert the HTML content to a different
   * position.
   *
   * Notice: if [childInfo] is either a HTML fragment (String) or
   * a DOM element.
   */
  void insertChildToDocument_(View child, var childInfo, View beforeChild) {
    if (beforeChild != null) {
      final beforeNode =
        beforeChild is PopupView ? (beforeChild as PopupView).refNode: beforeChild.node;
      if (childInfo is Element)
        beforeNode.parent.insertBefore(childInfo, beforeNode);
      else
        beforeNode.insertAdjacentHTML("beforeBegin", childInfo);
    } else {
      if (childInfo is Element)
        node.$dom_appendChild(childInfo); //note: Firefox not support insertAdjacentElement
      else
        node.insertAdjacentHTML("beforeEnd", childInfo);
    }
  }
  /** Removes the corresponding DOM elements of the give child from the document.
   * It is called by [removeFromParent] to remove the DOM elements.
   */
  void removeChildFromDocument_(View child, Element childNode) {
    childNode.remove();
  }

  /** Returns the DOM element associated with this view (never null).
   *
   * This method throws an exception if this view is attached to the document yet
   * (i.e., [inDocument] is false).
   *
   * To retrieve a child element, use the [getNode] method instead.
   *
   * Depending on your implementation,
   * you might have to override [insertChildToDocument_] and/or
   * [removeChildFromDocument_] if they share the same DOM element.
   */
  Element get node => _node != null ? _node: getNode(null);
  /** Returns the child element of the given sub-ID, or null if not found.
   * This method assumes the ID of the child element the concatenation of
   * uuid, dash ('-'), and subId.
   *
   * This method throws an exception if this view is attached to the document yet
   * (i.e., [inDocument] is false).
   */
  Element getNode(String subId) {
    if (!_inDoc)
      throw new UIException("Not in document, $this. Don't access node in Activity.onCreate_().");
    return document.query(subId != null && subId.length > 0 ? "#$uuid-$subId": "#$uuid");
  }
  /** Returns if this view has been attached to the document.
   */
  bool get inDocument => _inDoc;

  /** Adds this view to the document (i.e., the screen that the user interacts with).
   * All of its descendant views are added too.
   *
   * You rarely need to invoke this method directly. In most cases,
   * you shall invoke [addChild] instead. If you'd like to add a dialog, you shall
   * use [Activity.addDialog] instead. To make a view as the main view, you shall
   * set it to [Activity.mainView] instead.
   *
   * This method is designed used to mix the use of HTML
   * elements and views. For example, you can use it if you'd like to add
   * a view to the content of [TextView] and its derives. For example, you want
   * replace a portion of [TextView] with a view (, say, to provide some behavior).
   *
   * Notice that this method can be called only if this view has no parent.
   * If a view has a parent, whether it is attached to the document
   * shall be controlled by its parent.
   *
   * + If [outer] is true, [node] will be replaced. Furthermore, you can specify
   * [keepId] to whether to use node's ID as view's UUID. By default, UUID won't be
   * changed. If you specify [keepId] to true, you have to make sure [node]'s ID
   * is unique in the whole browser window.
   * + If [inner] is true, the view will be added as the last child element of [node].
   * + If neither [outer] nor [inner] is true, you can specify [before] to
   * a DOM element that the view will be inserted before.
   *
   * Notice: if you specify [before], you don't have to specify [node].
   * On the other hand, [node] is required if you don't specify [before].
   * It also means you have to specify either [node] or [before].
   *
   * Unlike most of API, [requestLayout] will be called automatically after mounted.
   * If you prefer not to call it, you can specify [shallLayout] to false.
   */
  void addToDocument([Element node, bool outer=false, bool inner=false,
  Element before, bool keepId=false, String location, bool shallLayout=true]) {
    if (parent != null || inDocument)
      throw new UIException("No parent allowed, nor attached twice: $this");

    _addToDoc(node, outer, inner, before, keepId, location, shallLayout);
  }
  void _addToDoc(Element node, [bool outer=false, bool inner=false,
  Element before, bool keepId=false, String location, bool shallLayout=true]) {
    if (outer && keepId && !node.id.isEmpty())
      _uuid = node.id;

    String html = _asHTML();
    Element p, nxt;
    if (inner) {
      node.innerHTML = html;
      //done (and no need to assign p and nxt)
    } else if (outer) {
      p = node.parent;
      nxt = node.nextElementSibling;
      node.remove();
    } else {
      p = node;
      nxt = before;
    }

    if (nxt != null)
      nxt.insertAdjacentHTML("beforeBegin", html);
    else if (p != null)
      p.insertAdjacentHTML("beforeEnd", html);

    _mount();

    if (location != null)
      layoutManager.afterLayout(() {
        final Element n = this.node;
        final Element pn = n.parent;
        if (pn != null) {
          int x = 0, y = 0;
          if (pn.offsetParent == n.offsetParent) {
            x = pn.$dom_offsetLeft;
            y = pn.$dom_offsetTop;
          }
          locateTo(location, x: x, y: y);
        }
      });

    if (shallLayout)
      requestLayout(immediate: true);
      //immediate: better feedback (and avoid ghost, i.e., showed at original place)
  }
  /** Removes this view from the document.
   * All of its descendant views are removed too.
   *
   * You rarely need to invoke this method directly. This method is used to undo
   * the attachment made by [addToDocument].
   * Like [addToDocument], this method can be called only if this view has no parent.
   *
   * If you add a child by [addChild] or [Activity.addDialog], you shall
   * invoke [removeFromParent] or [Activity.removeDialog] instead.
   */
  void removeFromDocument() {
    if (parent != null || !inDocument)
      throw new UIException("No parent allowed, nor detached twice: $this");

    final Element n = node; //store first since _node will be cleared up later
    _unmount();
    n.remove();
  }
  /** Binds the view.
   */
  void _mount() {
    ++_mntCnt;
    try {
      _mntInit();
      mount_();
    } finally {
      --_mntCnt;
    }

    if (_mntCnt == 0) {
      if (_afters != null && !_afters.isEmpty()) {
        final List<List> afters = new List.from(_afters); //to avoid one of callbacks mounts again
        _afters.clear();
        for (final List after in afters) {
          View view = after[0];
          if (view.inDocument) {
            AfterMount call = after[1];
            call(view);
          }
        }
      }
    }
  }
  /** Adds a task to be executed after all [mount_] are called.
   *
   * Notice that all tasks scheduled with this method will be queued
   * and executed righter [mount_] of all views are called.
   *
   * It is OK to invoke this method even if [inDocument] is false.
   * However, when it is time to invoke the queued [after], it will check if
   * this view is attached to the document. If not, [after] won't be called.
   */
  void afterMount_(AfterMount after) {
    if (after == null)
      throw const UIException("after required");
    if (_afters == null)
      _afters = new List();
    _afters.add([this, after]);
  }
  static List<List> _afters;
  static int _mntCnt = 0;
  
  /** Unbinds the view.
   */
  void _unmount() {
    if (_inDoc) {
      unmount_();
      _mntClean();
    }
  }
  /** Callback when this view is attached to the document.
   * Never invoke this method directly.
   *
   * Default: invoke [mount_] for each child.
   *
   * Subclass shall call back this method if it overrides this method.
   * When this method is called, [inDocument] is true, so it is safe to
   * access [node] and other element related method.
   *
   * If the deriving class would like some tasks to be executed
   * after [mount_] of all new-attached views are called, it can
   * invoke [afterMount_] to queue the task.
   *
   * See also [inDocument] and [invalidate].
   */
  void mount_() {
    for (View child = firstChild; child != null; child = child.nextSibling) {
      child._mntInit();
      child.mount_();
    }

    if (_evlInfo != null)
      _evlInfo.mount();

    sendEvent(new ViewEvent("mount"));
  }
  /** Callback when this view is detached from the document.
   * Never invoke this method directly.
   *
   * Default: invoke [unmount_] for each child.
   *
   * Subclass shall call back this method if it overrides this method. 
   */
  void unmount_() {
    sendEvent(new ViewEvent("unmount"));

    if (_evlInfo != null)
      _evlInfo.unmount();

    for (View child = firstChild; child != null; child = child.nextSibling) {
      child.unmount_();
      child._mntClean();
    }
  }
  void _mntInit() {
    _inDoc = true;
    ViewUtil._views[uuid] = this;
  }
  void _mntClean() {
    ViewUtil._views.remove(uuid);
    _mntAttrs = null; //clean up
    _inDoc = false;
    _node = null; //as the last step since node might be called in unmount_
  }

  /** Called when something has changed and caused that the display of this
   * view has to draw.
   * It has no effect if it is not attached (i.e., [inDocument] is true).
   *
   * Notice that, for better performance, the view won't be redrawn immediately.
   * Rather, it is queued and all queued invalidation will be drawn together later.
   * If you'd like to re-render it immediately, you can specify [immediate] to true.
   *
   * See also [ViewUtil.flushInvalidated], which forces all queued invalidation
   * to be handle immediately (but you rarely need to call it).
   */
  void invalidate([bool immediate=false]) {
    if (!immediate) {
      _invalidator.queue(this);
    } else if (inDocument) {
      final Element n = node; //cache it since _unmount will clean _node
      _unmount();
      _addToDoc(n, outer: true);
    }
  }

  /** Places this view at the given location.
   *
   * + [location] - one of the following. If not specified, "left top" is assumed.   
   * "north start", "north center", "north end",
   * "south start", "south center", "south end",
   * "west start", "west center", "west end",
   * "east start", "east center", "east end",
   * "top left", "top center", "top right",
   * "center left", "center center", "center right",
   * "bottom left", "bottom center", and "bottom right"
   * + [reference] - the reference view.
   * + [x] - the reference point's X coordinate if [reference] is not specified.
   * If [reference] is specified, [x] and [y] are ignored.
   * + [y] - the reference point's Y coordinate if [reference] is not specified.
   * If [reference] is specified, [x] and [y] are ignored.
   */
  void locateTo(String location, [View reference, int x=0, int y=0]) {
    AnchorRelation.locate(this, location, reference, x, y);
  }

  /** Requests the layout manager to re-position the layout of this view.
   * If a view's layout was handled by the layout manager (such as inside a linear layout)
   * and you change its dimension, you usually want its layout to be handled again.
   * It can be done by invoking [requestLayout].
   * For example, if you change the content of [TextView], you can
   * can invoke [requestLayout] and then the layout manager will re-position it later.
   *
   * Notice that the layout manager will adjust the layout of sibling views and all of
   * the descendant views, if necessary. For example, if a view is in a horizontal
   * linear layout and width has been changed, then its sibling views at the right
   * will be re-positioned too.
   *
   * If you positioned the view manually (by setting [left], [top], [width]
   * and [height] explicitly), you don't need to invoke this method. Rather, you
   * have to handle it yourself, if necessary. Otherwise, nothing will be changed.
   *
   * If you want to layout only the child views and their descendants, you can specify
   * [descendantOnly] to true.
   * The performance is better if this view is part of a sophisticated layout structure,
   * since the layout manager won't need to adjust the layout of this view and its siblings.
   *
   * If you want everything to be re-positioned, you can invoke `mainView.requestLayout()`.
   *
   * Notice that, for better performance, the layout won't be taken place
   *immediately. Rather, it is queued and all queued views are handled
   * together later.
   *
   * If you'd like to handle all queued layouts, you can invoke
   * [ViewUtil.flushRequestedLayouts].
   */
  void requestLayout([bool immediate=false, bool descendantOnly=false]) {
    layoutManager.requestLayout(this, immediate, descendantOnly);
  }
  /** Hanldes the layout of the child views of this view.
   * It is called by [LayoutManager].
   *
   * Notice that, when this method is called, you can assume the layout of this view
   * has been handled. Of course, you can adjust it if you'd like.
   *
   * Default: forward to [layoutManager] to handle it.
   * [onLayout_] will be called after the layout of the view has been handled.
   */
  void doLayout_(MeasureContext mctx) {
    layoutManager.doLayout(mctx, this);
  }
  /** Measures the width of this view.
   * It is called by [LayoutManager].
   *
   * Default: forward to [layoutManager] to handle it.
   * If [isViewGroup] is true, `measureWidth(mctx, this)` is called.
   * If false, `measureWidthByContent(mctx, this, true) is called.
   */
  int measureWidth_(MeasureContext mctx)
  => isViewGroup() ? mctx.measureWidth(this): mctx.measureWidthByContent(this, true);
  /** Measures the height of this view.
   * It is called by [LayoutManager].
   *
   * Default: forward to [layoutManager] to handle it.
   * If [isViewGroup] is true, `measureHeight(mctx, this)` is called.
   * If false, `measureHeightByContent(mctx, this, true) is called.
   */
  int measureHeight_(MeasureContext mctx)
  => isViewGroup() ? mctx.measureHeight(this): mctx.measureHeightByContent(this, true);
  /** Returns whether the given child shall be handled by the layout manager.
   *
   * Default: return true if the child is visble, its position
   * is absolute, and not an instance of [PopupView].
   * Notice that, for better performance, it checks only [View.style], and
   * assumes the position defined in
   * CSS rules (aka., classes) is `absolute`.
   *
   * The deriving class shall override this method if
   * the deriving class supports an inner element and not all child
   * elements in the inner element, it shall override this method to skip
   * the child views *not* in the inner element.
   * Please refer to the viewport example for a sample implementation.
   *
   * Note that, if this method returns false for a child, the layout
   * manager won't adjust its position and dimension. However, the child's [doLayout_]
   * will be still called to arrange the layout of the child's child views.
   */
  bool shallLayout_(View child) {
    if (!child.visible || child is PopupView)
      return false;
    final String v = child.style.position;
    return v.isEmpty() || v == "absolute";
  }

  /** Generates the HTML fragment for this view and its descendants
   * to the given string buffer.
   *
   * + See also [invalidate].
   */
  void draw(StringBuffer out) {
    final String tag = domTag_;
    out.add('<').add(tag);
    domAttrs_(out);
    out.add('>');
    domInner_(out);
    out.add('</').add(tag).add('>');
  }
  /** Returns the HTML tag's name representing this widget.
   * It is called by [draw]. If you override draw and don't call
   * back super.draw, this method has no effect.
   *
   * Default: `div`.
   */
  String get domTag_ => "div";

  /**Shortcut of [draw].*/
  String _asHTML() {
    final out = new StringBuffer();
    draw(out);
    return out.toString();
  }

  /** Returns if this view is visible.
   */
  bool get visible => _visible;
  /** Sets if this view is visible.
   *
   * Default: true.
   *
   * Unlike most API, [requestLayout] will be called automatically if it is becoming visible.
   */
  void set visible(bool visible) {
    final bool changed = visible != _visible;
    _visible = visible;

    if (_inDoc) {
      new DOMQuery(node).visible = visible;
      if (changed && visible)
        requestLayout(immediate: true);
    }
  }

  /** Returns whether the view is draggable.
   */
  bool get draggable => _draggable;
  /** Sets whether the view is draggable.
   *
   * Default: false.
   */
  void set draggable(bool draggable) {
    _draggable = draggable;
    if (_inDoc)
      node.draggable = draggable;
  }

  /** Returns the left position of this view relative to its parent.
   *
   * Default: 0
   */
  int get left => _left;
  /** Sets the left position of this view relative to its parent.
   */
  void set left(int left) {
    _left = left;

    if (_inDoc)
      node.style.left = CSS.px(left);
  }
  /** Returns the top position of this view relative to its parent.
   *
   * Default: 0
   */
  int get top => _top;
  /** Sets the top position of this view relative to its parent.
   */
  void set top(int top) {
    _top = top;

    if (_inDoc)
      node.style.top = CSS.px(top);
  }

  /** Returns the width of this view.
   *
   * Default: null (means the width shall be calculated based on its content).
   *
   * + To get the real width on the document, use [outerWidth].
   */
  int get width => _width;
  /** Sets the width of this view.
   *
   * Notice that, like most of APIs, if the change will affect the layout,
   * you have to invoke [requestLayout] by yourself.
   */
  void set width(int width) {
    _width = width;

    if (_inDoc) {
      node.style.width = CSS.px(width);
      layoutManager.sizeUpdated(this, Dir.HORIZONTAL);
    }
  }
  /** Returns the height of this view.
   *
   * Default: null (means the height shall be calculated based on its content).
   *
   * + To get the real height on the document, use [outerHeight].
   */
  int get height => _height;
  /** Sets the height of this view.
   *
   * Notice that, like most of APIs, if the change will affect the layout,
   * you have to invoke [requestLayout] by yourself.
   */
  void set height(int height) {
    _height = height;

    if (_inDoc) {
      node.style.height = CSS.px(height);
      layoutManager.sizeUpdated(this, Dir.VERTICAL);
    }
  }

  /** Returns the real width of this view shown on the document (never null).
   * Notice that the performance of this method is not good, if
   * [width] is null.
   */
  int get outerWidth
  => _width != null ? _width: inDocument ? new DOMQuery(node).outerWidth: 0;
    //for better performance, we don't need to get the outer width if _width is
    //assigned (because we use box-sizing: border-box)
  /** Returns the real height of this view shown on the document (never null).
   * Notice that the performance of this method is not good, if
   * [height] is null.
   */
  int get outerHeight
  => _height != null ? _height: inDocument ? new DOMQuery(node).outerHeight: 0;
    //for better performance, we don't need to get the outer height if _height is
    //assigned (because we use box-sizing: border-box)
  /** Returns the viewable width of this view, excluding the borders, margins
   * and scrollbars.
   *
   * Note: this method returns [width] if [inDocument] is false and [width] is not null.
   * In other words, it doesn't exclude the border's width if not attached to the document
   * (for performance reason). However, we might change it in the future, so it is better
   * not to call this method if the view is not attached.
   */
  int get innerWidth {
    final int v = inDocument ? new DOMQuery(node).innerWidth:
      (_width != null ? _width: 0);
    return v > 0 ? v: 0;
  }
  /** Returns the viewable height of this view, excluding the borders, margins
   * and scrollbars.
   *
   * Note: this method returns [height] if [inDocument] is false and [height] is not null.
   * In other words, it doesn't exclude the border's height if not attached to the document
   * (for performance reason). However, we might change it in the future, so it is better
   * not to call this method if the view is not attached.
   */
  int get innerHeight {
    final int v = inDocument ? new DOMQuery(node).innerHeight:
      (_height != null ? _height: 0);
    return v > 0 ? v: 0;
  }

  /** Returns the offset of this view relative to the left-top corner
   * of the document.
   * It takes into account any horizontal scrolling of the page.
   */
  Offset get pageOffset {
    if (_inDoc)
      return new DOMQuery(node).pageOffset;
    
    int left = 0, top = 0;
    for (View view = this;;) {
      left += view.left;
      top += view.top;
      if (view.style.position == "fixed" || (view = view.parent) == null)
        return new Offset(left, top);
    }
  }
  /** Returns the layout instruction of this view.
   *
   * [layout] intructs how a view shall layout the child views.
   * In additions, you can specify addition information in individual child
   * view's [profile].
   */
  LayoutDeclaration get layout {
    if (_layout == null)
      _layout = new LayoutDeclarationImpl(this);
    return _layout;
  }
  /** Returns the profile, i.e., the layouot requirement, of this view.
   * It provides additional information for the parent view to
   * layout this view.
   *
   * + See also [layout].
   */
  ProfileDeclaration get profile {
    if (_profile == null)
      _profile = new ProfileDeclarationImpl(this);
    return _profile;
  }

  /** Retuns the CSS style.
   *
   * Notice that `getPropertyValue()` returns an empty string if the given style
   * is not set (in the returned instance of CSSStyleDeclaration). On the other
   * hand, the returned instance of DOM Element depends on the browser (unless Dart
   * changed it). For example,
   *
   *     view.style.getProperty("width"); //return an empty string if not set
   *     view.node.style.getProperty("width"); //return null in Webkit (while empty in others)
   */
  CSSStyleDeclaration get style {
    if (_style == null)
      _style =  new CSSStyleDeclarationImpl(this);
    return _style;
  }

  /** Returns the style classes.
   */
  Set<String> get classes => _classes;

  /** Outputs all HTML attributes used for the DOM element of this view
   * to the given output.
   * It is called by [draw], and the deriving class can override it
   * to provide more attributes. Of course, if you override [draw]
   * directly, you can decide whether to call this method.
   */
  void domAttrs_(StringBuffer out, [DOMAttrsCtrl ctrl]) {
    final noCtrl = ctrl == null;
    String s;
    if ((noCtrl || !ctrl.noId) && !(s = uuid).isEmpty())
      out.add(' id="').add(s).add('"');
    if ((noCtrl || !ctrl.noStyle)) {
      final StringBuffer stylesb = new StringBuffer();
      domStyle_(stylesb,
        new DOMStyleCtrl(noVisible: (noCtrl ||  ctrl.noVisible)));
      if (!stylesb.isEmpty())
          out.add(' style="').add(stylesb).add('"');
    }
    if ((noCtrl || !ctrl.noDraggable))
      out.add(' draggable="').add(draggable).add('"');
    if ((noCtrl || !ctrl.noVisible) && !visible)
      _visiCtrl.addHiddenAttr(out);
    if ((noCtrl || !ctrl.noClass)) {
      final StringBuffer classsb = new StringBuffer();
      domClass_(classsb);
      if (!classsb.isEmpty())
        out.add(' class="').add(classsb).add('"');
    }
  }
  /** Outputs the inner content of this widget. It is everything
   * other than the enclosing tag.
   * It is called by [draw], and the deriving class can override it to
   * provide the content it wants. Of course, if you override [draw]
   * directly, you can decide whether to call this method.
   *
   * Default: invoke each child view's [draw] sequentially.
   */
  void domInner_(StringBuffer out) {
    for (View child = firstChild; child != null; child = child.nextSibling) {
      child.draw(out);
    }
  }
  /** Outputs a list of the CSS classes for the DOM element of this view
   * to the given output. If there are multiple CSS classes, they will
   * be separated with white spaces.
   */
  void domClass_(StringBuffer out) {
    out.add(viewConfig.classPrefix);

    for (final String cls in classes) {
      out.add(' ').add(cls);
    }
  }
  /** Output the CSS style for the DOM element of this view to the given outout.
   */
  void domStyle_(StringBuffer out, [DOMStyleCtrl ctrl]) {
    final noCtrl = ctrl == null;
    if ((noCtrl || !ctrl.noLeft) && left != 0)
      out.add("left:").add(left).add("px;");
    if ((noCtrl || !ctrl.noTop) && top != 0)
      out.add("top:").add(top).add("px;");
    if ((noCtrl || !ctrl.noWidth) && _width != null) //don't use width since it has special handling
      out.add("width:").add(_width).add("px;");
    if ((noCtrl || !ctrl.noHeight) && _height != null) //don't use height since it has special handling
      out.add("height:").add(_height).add("px;");
    if ((noCtrl || !ctrl.noVisible) && !visible)
      _visiCtrl.addHiddenStyle(out);
    String s;
    if ((noCtrl || !ctrl.noStyle) && _style != null && !(s = _style.cssText).isEmpty())
      out.add(XMLUtil.encode(s));
  }

  /** Returns [ViewEvents] for adding or removing event listeners.
   */
  ViewEvents get on => _initEventListenerInfo().on;

  /** Sends an event to this view.
   *
   * Example: `view.sendEvent(new ViewEvent("click"))</code>.
   * If the type parameter is not specified, it is assumed to be [ViewEvent.type].
   *
   * To broadcast an event, please use [broadcaster] instead.
   */
  bool sendEvent(ViewEvent event, [String type]) {
    if (event.target == null)
      event.target = this;
    return _evlInfo != null && _evlInfo.send(event, type);
  }
  /** Posts an event to this view.
   * Unlike [sendEvent], [postEvent] puts the event in a queue and returns
   * immediately. The event will be handled later.
   */
  void postEvent(ViewEvent event, [String type]) {
    window.setTimeout(() {sendEvent(event, type);}, 0);
      //note: the order of messages is preserved across all views (and message queues)
      //CONSIDER if it is better to have a queue shared by views/message queues/broadcaster
  }

  /** Returns if the given event type is a DOM event.
   * If true, [domListen_] will be invoked to register the DOM event.
   */
  DOMEventDispatcher getDOMEventDispatcher_(String type)
  => _ViewImpl.getDOMEventDispatcher(type);

  /** Listen the given event type.
   */
  void domListen_(Element n, String type, DOMEventDispatcher disp) {
    final EventListener ln = disp(this); //must be non-null
    final _EventListenerInfo ei = _initEventListenerInfo();
    if (ei.domListeners == null)
      ei.domListeners = {};
    ei.domListeners[type] = ln;
    n.on[type.toLowerCase()].add(ln);
  }
  /** Unlisten the given event type.
   */
  void domUnlisten_(Element n, String  type) {
    if (_evlInfo != null) {
      final EventListener ln = _evlInfo.domListeners.remove(type);
      if (ln != null)
        n.on[type.toLowerCase()].remove(ln);
    }
  }

  /**
   * A map of application-specific data.
   *
   * Note: the name of the attribute can't start with "rk.", which is reserved
   * for internal use.
   *
   * See also [mountAttributes].
   */
  Map<String, Dynamic> get dataAttributes
  => _dataAttrs != null ? _dataAttrs: MapUtil.onDemand(() => _dataAttrs = new Map());
  /**
   * A map of application-specific data that exist only
   * if the view is attached to the document. It is useful if you'd like to
   * store something that will be cleaned up automatically when
   * the view is detached from the document.
   *
   * Note: the name of the attribute can't start with "rk.", which is reserved
   * for internal use.
   *
   * See also [dataAttributes].
   */
  Map<String, Dynamic> get mountAttributes
  => _mntAttrs != null ? _mntAttrs: MapUtil.onDemand(() => _mntAttrs = new Map());

  /** A map of templates.
   * A template ([Template]) is a definition of UI that you can use to instantiate
   * views.
   */
  Map<String, Template> get templates
  => _templs != null ? _templs: MapUtil.onDemand(() => _templs = new Map());
  /** A map of annotations.
   * Annotations ([Annotation]) are the meta information providing
   * additional information about how to handle a view.
   * The meaning depends on the tool or utility that handles a view.
   */
  Map<String, Annotation> get annotations
  => _annos != null ? _annos: MapUtil.onDemand(() => _annos = new Map());

  int hashCode() => uuid.hashCode(); //uuid is immutable once assigned
  String toString() => "$className(${id.isEmpty() ? uuid: id})";
}
