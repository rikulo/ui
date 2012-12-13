//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jan 9, 2012 13:01:36
// Author: tomyeh
part of rikulo_view;

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
 * ##ID Space
 *
 * If a view implements [IdSpace], it and its descendants are considered
 * as a ID space. And, the topmost view is the owner.
 * All IDs in the given ID space must be unique.
 * On the other hand, views in different ID spaces can have the same ID.
 *
 * Implementing [IdSpace] is straightforward:
 *
 *     class MyIdSpace extends View implements IdSpace {
 *       final Map<String, View> fellows = new Map();
 *     }
 *
 * ##See Also
 *
 * + [ViewUtil]
 */
class View {
  String _uuid;

  View _parent;
  View _nextSibling, _prevSibling;
  //Virtual ID space. Used only if this is root but not IdSpace
  IdSpace _virtIS;

  _ChildInfo _childInfo;
  _EventListenerInfo _evlInfo;
  Map<String, dynamic> _dataAttrs, _mntAttrs;
  Map<String, Annotation> _annos;

  CssStyleDeclaration _style;
  Element _node;

  int _left = 0, _top = 0, _width, _height;
  ProfileDeclaration _profile;
  LayoutDeclaration _layout;

  bool _inDoc = false;

  /** Constructor.
   */
  View() {
  }
  /** Instantiates a view by using the given HTML tag.
   * For example,
   *
   *     new View.tag("section");
   *
   * + [tag] specifies the HTML tag name, such as `section` and `article`.
   */
  View.tag(String tag) {
    node = new Element.tag(tag);
  }
  /** Instantiates a view to representing a hierarchy of elements specified
   * in the given HTML fragment. For example,
   *
   *     new View.html(
   *      '<table cellapding="10" border="1"><tr><td>Cell 1.1</td></tr></table>');
   *
   * In the above example, [node] will be the TABLE element.
   *
   * Notice that it is different from [TextView.fromHtml]. [TextView.fromHtml]
   * creates an instance of [TextView] and the given HTML fragment
   * will become child elements of [node].
   * For example, the UL element in the following example
   * will be a child of [node] (and [node] is always DIV):
   *
   *     new TextView.fromHtml(
   *      "<ul><li>First item</li><li>Second item</li></ul>");
   */
  View.html(String html) {
    node = new Element.html(html);
  }

  /** Returns the Dart class name.
   *
   * Default: the class's name
   *
   * A CSS class named `v-$className` will be added to [classes]. In additions, [query]
   * and [queryAll] uses it as the *tag* name for matching the given selector.
   */
  String get className => "$runtimeType";
    //TODO: check if dart changes its implement and replace with mirrors if necessary

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
   *
   * It is used mostly by [render_] to identify the child elements, if any.
   */
  String get uuid {
    if (_uuid == null)
      _uuid = StringUtil.encodeId(_uuidNext++, viewConfig.uuidPrefix);
    return _uuid;
  }
  static int _uuidNext = 0;

  /** Returns the ID of this view, or an empty string if not assigned.
   */
  String get id => node.id;
  /** Sets the ID of this view.
   */
  void set id(String id) {
    if (id == null) id = "";
    if (node.id != id) {
      if (id.length > 0)
        _ViewImpl.checkIdSpaces(this, id);
      _ViewImpl.removeFromIdSpace(this);
      node.id = id;
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
    return iter.hasNext ? iter.next() : null;
  }
  /** Searches and returns all views that matches the selector.
   */
  Iterable<View> queryAll(String selector) {
    return new ViewIterable(this, selector);
  }
  /** Returns a map of all fellows in this ID space.
   * The key is ID, while the value is the view with the given ID.
   *
   *     view.fellows['foo'].width = 100;
   *       //equivalent to view.query('#foo').width = 100
   *
   * Notice that the application shall consider the map as read-only.
   * Otherwise, the result is unpredictable.
   */
  Map<String, View> get fellows => spaceOwner.fellows;
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
      if (identical(w, parent))
        return true;
    }
    return false;
  }

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
  bool get isViewGroup => true;

  /** Adds a child.
   * If [beforeChild] is specified, the child will be inserted before it.
   * Otherwise, it will be added to the end.
   *
   * If this view is attached to the document, this method will attach the child
   * to the document.
   *
   * To remove a child from its parent, you can invoke [remove], such as `child.remove()`.
   */
  void addChild(View child, [View beforeChild]) {
    if (isDescendantOf(child))
      throw new UiError("$child is an ancestor of $this");
    if (!isViewGroup)
      throw new UiError("No child allowed for $this");

    if (beforeChild != null) {
      if (!identical(beforeChild.parent, this))
        beforeChild = null;
      else if (identical(child, beforeChild))
        return; //nothing to change
    }

    final View oldParent = child.parent;
    final bool parentChanged = !identical(oldParent, this);
    if (!parentChanged && identical(beforeChild, child.nextSibling))
      return; //nothing to change

    if (oldParent == null && child.inDocument) //child.addToDocument was called
      child._removeFromDocument();

    if (parentChanged)
      child.beforeParentChanged_(this);
    if (oldParent != null)
      oldParent._removeChild(child, false);

    _ViewImpl.link(this, child, beforeChild);
    addChildNode_(child, beforeChild);

    if (inDocument)
      child._mount();
      //note: child.requestLayout won't be called (for sake of performance)

    onChildAdded_(child);
    if (parentChanged)
      child.onParentChanged_(oldParent);
  }

  /** Removes this view from its parent and, if attached, from the document.
   *
   * If it has a parent, it will be detached from the parent.
   * If it is attached (i.e., `inDocument`), it will be removed from document.
   * If neither, nothing happens.
   */
  void remove() {
    if (parent != null)
      parent._removeChild(this);
    else if (inDocument)
      _removeFromDocument();
  }
  void _removeChild(View child, [bool notifyChild=true]) {
    if (!identical(child.parent, this))
      return;

    beforeChildRemoved_(child);
    if (notifyChild)
      child.beforeParentChanged_(null);

    if (inDocument)
      child._unmount();

    removeChildNode_(child);
    _ViewImpl.unlink(this, child);

    if (notifyChild)
      child.onParentChanged_(this);
    onChildRemoved_(child);
  }

  /** Inserts the DOM element of the given [child] view before
   * the reference view ([beforeChild]).
   * It is called by [addChild] to attach the DOM elements to [node].
   *
   * Deriving classes might override this method if it has to, say,
   * enclose with TD, or to add the child node to a different
   * position.
   */
  void addChildNode_(View child, View beforeChild) {
    if (beforeChild != null) {
      final beforeNode = beforeChild.node;
      beforeNode.parent.insertBefore(child.node, beforeNode);
    } else {
      node.nodes.add(child.node);
    }
  }
  /** Removes the corresponding DOM elements of the give child.
   * It is a callback of [remove]: if `child.remove()` is called, then
   * `child.parent.removeChildNode_(child)` will be called implicitly
   * to remove the DOM elements from its parent's hierarchy of elements.
   *
   * Deriving classes might override this method if it encloses some special
   * element around the child.node (in [addChildNode_]) (such that the special
   * element will be also deleted in this method).
   */
  void removeChildNode_(View child) {
    child.node.remove();
  }

  /** Returns the DOM element associated with this view (never null).
   *
   * When the first time this method is called, [render_] will be called to render
   * the DOM elements (unless you assign it explicity with the setter before calling
   * the getter).
   *
   * To retrieve a child element (of this view), use the [getNode] method instead.
   */
  Element get node {
    if (_node == null) {
      _node = render_();
      _initNode();
    }
    return _node;
  }
  /** Sets the DOM element associated with this view.
   * You rarely need to invoke this method. Rather, you shall override [render_]
   * instead.
   *
   * In general, it is suggested to use this method only if you'd like to 
   * create the element in the constructor and don't want to save the arguments
   * until [render_] is called. Furthermore, it must be called before calling
   * the getter, `node`.
   *
   * It throws [UiError] if it was assigned (such as either the setter or the
   * getter has been called before).
   */
  void set node(Element node) {
    if (node.parent != null)
      throw new UiError("Root element required, $node");
    if (_node != null)
      throw new UiError("Already assigned with $_node");
    _node = node;
    _initNode();
  }
  void _initNode() {
    node.classes
      ..add(viewConfig.classPrefix)
      ..add("${viewConfig.classPrefix}$className");
  }
  /** Creates and returns the DOM elements of this view.
   *
   * Default: it creates a DIV element.
   *
   * Note: this method doesn't need to handle child views. The DOM elements
   * of the child views will be added to the hierarchy of elements later
   * automatically (by [addChildNode_]).
   *
   * Note: instead of overriding this, you can create the DOM element directly
   * and then assign it with [node]. However, [node] shall be assigned (setter)
   * before [node] has been retrieved (getter). It usually means you have to
   * do it in the constructor.
   */
  Element render_() => new Element.tag("div");

  /** Returns the child element of the given sub-ID, or null if not found.
   * This method assumes the ID of the child element the concatenation of
   * [uuid], dash ('-'), and subId.
   */
  Element getNode(String subId) {
    if (subId == null || subId.isEmpty)
      return node;
    subId = "#$uuid-$subId";
    return inDocument ? document.query(subId): node.query(subId);
      //For better performance, we use document.query if possible
  }
  /** Retrieve the mask node if the view is added to the document as a dialog, 
   * or null otherwise.
   *
   * The mask node is generated when a view was invoked with [addToDocument]
   * with `mode: dialog`. It is placed below [node] and occupies the whole space to
   * prevent the user from accessing any UI other than this view.
   */
  Element get maskNode {
    final di = dialogInfos[this];
    return di != null ? di.mask: null;
  }
  /** Returns if this view has been attached to the document.
   */
  bool get inDocument => _inDoc;

  /** Adds this view to the document (i.e., the screen that the user interacts with).
   * All of its descendant views are added too.
   *
   * You need to invoke this method to add a root view to the document
   * (so called attach).
   * On the other hand, the child views are added to the document automatically
   * once the root has been attached.
   *
   * If this view is a child of another view, [remove] will be called implicitly
   * to detach it first.
   *
   * To notify the views, [mount_] will be called against this view and all
   * of its descendants.
   *
   * To remove it from document, you can invoke [remove].
   *
   * + [ref] specifies the DOM node to add this view. If not specified,
   * it will look for an element whose id is "v-main". If not found,
   * `document.body` is assumed.
   * Notice: it can be a Text node if [mode] is `before` or 'replace'.
   * Otherwise, it has to be an element.
   * + [mode] specifies how to add this view. The allowed values include:
   *    + `child` (default): add as a child of the given reference node.
   *    + `dialog`: add as a child and makes it looks like a dialog (a mask
   * is inserted to keep user from accessing other views).
   * In additions, if its `profile.location` is not specified, `"center center"`
   * will be assigned (i.e., it will be placed at the center).
   *    + `before`: insert before the given reference node
   *    + `replace`: replace the given reference node. Notice if the give reference node has an ID,
   * it will be assigned to this view's [id] (if it was not assigned).
   *    + `inner`: replace the inner content. In other words, all children
   * are removed and this view will become its only child.
   * + [layout] specifies whether to invoke [requestLayout].
   * If true, `requestLayout(true)` will be called.
   * If omitted (i.e., null), `requestLayout()` will be called.
   * If false, [requestLayout] won't be called at all.
   */
  void addToDocument({Node ref, String mode, bool layout}) {
    remove();

    _ViewImpl.init();

    if (ref == null && (ref = document.query("#v-main")) == null)
      ref = document.body;

    Node p, nxt;
    switch (mode) {
      case "before":
        p = ref.parent;
        nxt = ref;
        break;
      case "replace":
        final refid = ref is Element ? (ref as Element).id: "";
        if (!refid.isEmpty && id.isEmpty)
          id = refid;

        p = ref.parent;
        nxt = ref.nextNode;
        ref.remove();
        break;
      case "inner":
        ref.nodes.clear();
        p = ref;
        break;
      case "dialog":
        final dlgInfo = dialogInfos[this] = _ViewImpl.createDialog(ref, this);
        ViewUtil._views[p = dlgInfo.cave] = this; //yes, cave belongs to this view
        if (profile.location.isEmpty)
          profile.location = "center center";
        break;
      default:
        p = ref;
        break;
    }

    if (nxt != null)
      nxt.parent.insertBefore(node, nxt);
    else if (p != null)
      p.nodes.add(node);
    
    _mount();
    classes.addAll(_rootClasses);
    rootViews.add(this);

    if (layout != false)
      requestLayout(layout == true);
      //immediate: better feedback (and avoid ghost, i.e., showed at original place)
  }
  /** Removes this view from the document.
   * Notice: this method can be called only if parent is null and inDocument
   */
  void _removeFromDocument() {
    _unmount();
    classes.removeAll(_rootClasses);
    ListUtil.remove(rootViews, this);

    final dlgInfo = dialogInfos.remove(this);
    if (dlgInfo != null)
      ViewUtil._views.remove(dlgInfo.cave..remove());
    else
      node.remove();
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
      if (!_afters.isEmpty) {
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
      throw new ArgumentError("after");
    _afters.add([this, after]);
  }
  static final List<List> _afters = [];
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
   * See also [inDocument].
   */
  void mount_() {
    for (View child = firstChild; child != null; child = child.nextSibling) {
      child._mntInit();
      child.mount_();
    }

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

    for (View child = firstChild; child != null; child = child.nextSibling) {
      child.unmount_();
      child._mntClean();
    }
  }
  void _mntInit() {
    _inDoc = true;
    ViewUtil._views[node] = this;
  }
  void _mntClean() {
    ViewUtil._views.remove(node);
    _mntAttrs = null; //clean up
    _inDoc = false;
  }

  /** Places this view at the given location.
   *
   * + [ref] - the reference view.
   * + [location] - one of the following. If null, "left top" is assumed.   
   * "north start", "north center", "north end",
   * "south start", "south center", "south end",
   * "west start", "west center", "west end",
   * "east start", "east center", "east end",
   * "top left", "top center", "top right",
   * "center left", "center center", "center right",
   * "bottom left", "bottom center", and "bottom right"
   * + [x] - the reference point's X coordinate if [ref] is not specified.
   * If [reference] is specified, [x] and [y] are ignored.
   * + [y] - the reference point's Y coordinate if [ref] is not specified.
   * If [reference] is specified, [x] and [y] are ignored.
   */
  void locateTo(String location, [View ref, int x=0, int y=0]) {
      locateToView(null, this, location, ref, x, y);
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
   * If you want everything to be re-positioned, you can invoke
   * [requestLayout] against your root view.
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
  /** Handles the layout of the child views of this view.
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
   * If [shallMeasureContent] is false, `measureWidth(mctx, this)` is called.
   * If true, `measureContentWidth(mctx, this, true) is called.
   */
  int measureWidth_(MeasureContext mctx)
  => shallMeasureContent ? mctx.measureContentWidth(this, true):
    mctx.measureWidth(this);
  /** Measures the height of this view.
   * It is called by [LayoutManager].
   *
   * Default: forward to [layoutManager] to handle it.
   * If [shallMeasureContent] is false, `measureHeight(mctx, this)` is called.
   * If true, `measureContentHeight(mctx, this, true) is called.
   */
  int measureHeight_(MeasureContext mctx)
  => shallMeasureContent ? mctx.measureContentHeight(this, true):
    mctx.measureHeight(this);
  /** Returns whether the dimension of this view shall be measured
   * based on the content shown on the document.
   *
   * Default: `!isViewGroup() || (no child but has some content)`
   *
   * If false, it means the dimension is based on the layout of child views.
   * More precisely, [MeasureContext.measureWidth] is used instead of
   * [MeasureContext.measureContentWidth]. Furthermore, if the view
   * is a root, `profile.width` and `profile.height` are assumed to be `flex`
   * if it is not specified.
   */
  bool get shallMeasureContent
  => !isViewGroup || (firstChild == null && new _DomAgentX(node).hasContent);

  /** Returns whether the given child shall be handled by the layout manager.
   *
   * Default: return true if the child is visible, its position
   * is absolute.
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
    if (!child.visible)
      return false;
    final String v = child.style.position;
    return v.isEmpty || v == "absolute";
  }

  /** Returns if this view is visible.
   * It assumes a view is visible if the `display` property (of [style]) is
   * not `none`.
   *
   * Notice, for better performance, this method checks only [style].
   * If you control the `display` property in CSS rules (e.g.,
   * `display:none` is in a CSS class that is assigned to this view),
   * [visible] won't be correct. To resolve the limitation, you can do one of
   * the following:
   *
   * 1. Specify `ignore` to [profile]'s `width` and `height` properties, such
   * that the layout handlers won't manipulate its dimension.
   *
   * 2. Use the `visibility` property instead of `display` in your CSS rules.
   * Both layout handlers and the browser will handle it as if visible.
   *
   * 3. Override this method to check CSS rules:  
   * `new DomAgent(node).style.display != "none"`
   */
  bool get visible => node.style.display != "none";
  /** Sets if this view is visible.
   * It assumes a view is visible if the `display` property (of [style]) is
   * not `none`.
   *
   * Unlike most API, [requestLayout] will be called automatically if
   * it is becoming visible (and [inDocument] is true).
   */
  void set visible(bool visible) {
    final changed = visible != this.visible;
    node.style.display = visible ? "": "none";

    if (_inDoc && changed && visible)
        requestLayout(true);
  }

  /** Returns whether the view is draggable.
   */
  bool get draggable => node.draggable;
  /** Sets whether the view is draggable.
   *
   * Default: false.
   */
  void set draggable(bool draggable) {
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
    node.style.left = Css.px(left);
    ViewImpl.leftUpdated(this);
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
    node.style.top = Css.px(top);
    ViewImpl.topUpdated(this);
  }

  /** Returns the width of this view.
   *
   * Default: null (means the width shall be calculated based on its content).
   *
   * + To get the real width on the document, use [realWidth].
   */
  int get width => _width;
  /** Sets the width of this view.
   *
   * Notice that, like most of APIs, if the change will affect the layout,
   * you have to invoke [requestLayout] by yourself.
   */
  void set width(int width) {
    _width = width;

    node.style.width = Css.px(width);
    ViewImpl.widthUpdated(this);
  }
  /** Returns the height of this view.
   *
   * Default: null (means the height shall be calculated based on its content).
   *
   * + To get the real height on the document, use [realHeight].
   */
  int get height => _height;
  /** Sets the height of this view.
   *
   * Notice that, like most of APIs, if the change will affect the layout,
   * you have to invoke [requestLayout] by yourself.
   */
  void set height(int height) {
    _height = height;

    node.style.height = Css.px(height);
    ViewImpl.heightUpdated(this);
  }

  /** Returns the real width of this view (never null).
   * If [width] is assigned, this method is the same as [width].
   * However, if not assigned (i.e., null), this method calculates it from [node]'s width.
   */
  int get realWidth
  => _width != null ? _width: new DomAgent(node).width;
    //for better performance, we don't need to get the outer width if _width is
    //assigned (because we use box-sizing: border-box)
  /** Returns the real height of this view (never null).
   * If [height] is assigned, this method is the same as [height].
   * However, if not assigned (i.e., null), this method calculates it from [node]'s height.
   */
  int get realHeight
  => _height != null ? _height: new DomAgent(node).height;
    //for better performance, we don't need to get the outer height if _height is
    //assigned (because we use box-sizing: border-box)
  /** Returns the viewable width of this view, excluding the borders, margins
   * and scrollbars.
   *
   * Derives can override this method if the child views occupies only a portion.
   */
  int get innerWidth => new DomAgent(node).innerWidth;
  /** Returns the viewable height of this view, excluding the borders, margins
   * and scrollbars.
   *
   * Derives can override this method if the child views occupies only a portion.
   */
  int get innerHeight => new DomAgent(node).innerHeight;

  /** Returns the offset of this view relative to the left-top corner
   * of the document.
   * It takes into account any horizontal scrolling of the page.
   */
  Offset get pageOffset {
    if (_inDoc)
      return new DomAgent(node).pageOffset;
    
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
   * [layout] instructs how a view shall layout the child views.
   * In additions, you can specify addition information in individual child
   * view's [profile].
   */
  LayoutDeclaration get layout {
    if (_layout == null)
      _layout = new LayoutDeclaration(this);
    return _layout;
  }
  /** Returns the profile, i.e., the layout requirement, of this view.
   * It provides additional information for the parent view to
   * layout this view.
   *
   * + See also [layout].
   */
  ProfileDeclaration get profile {
    if (_profile == null)
      _profile = new ProfileDeclaration(this);
    return _profile;
  }

  /** Retuns the CSS style.
   */
  CssStyleDeclaration get style {
    if (_style == null)
      _style = new _StyleImpl(this);
    return _style;
  }
  /** Returns the style classes.
   */
  CssClassSet get classes => node.classes;

  /** Returns [ViewEvents] for adding or removing event listeners.
   */
  ViewEvents get on => _initEventListenerInfo().on;

  /** Sends an event to this view.
   *
   * Example: `view.sendEvent(new ViewEvent("click"))</code>.
   * If the type parameter is not specified, it is assumed to be [ViewEvent.type].
   *
   * To broadcast an event, please use [broadcaster] instead.
   * Also notice that the broadcasted event will be sent to every root view
   * if it is `inDocument`.
   *
   * + returns true if it has been dispatched to one of the registered listeners.
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

  /** Called when the first event listener is registered for the given type.
   *
   * By default, it checks if the given type is a DOM event. If so, it will
   * register a DOM event listener to [node] for proxying the DOM event to
   * this view's event listeners.
   *
   * Override if you'd like to handle DOM events differently, or to initialize
   * something for particular type.
   *
   * Notice that this method is called with [target] as null. It means the element
   * to register DOM listener will be [node].
   * If it is not what you expected, you can override this method and
   * pass the right element to superclass. For example,
   *
   *     void onEventListened_(String type, [Element target]) {
   *       super.onEventListened_(type, type == "change" ? getNode("inp"): target);
   *     }
   */
  void onEventListened_(String type, [Element target])
  => _evlInfo.onEventListened_(type, target);
  /** Called when the last event listener has been unregistered for the given
   * type. It undoes whatever is done in [onEventListened_].
   */
  void onEventUnlistened_(String type, [Element target])
  => _evlInfo.onEventUnlistened_(type, target);

  /**
   * A map of application-specific data.
   *
   * Note: the name of the attribute can't start with "rk.", which is reserved
   * for internal use.
   *
   * Unlike `Element.dataAttributes', you can store any kind of objects here.
   *
   * See also [mountAttributes].
   */
  Map<String, dynamic> get dataAttributes
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
  Map<String, dynamic> get mountAttributes
  => _mntAttrs != null ? _mntAttrs: MapUtil.onDemand(() => _mntAttrs = new Map());

  /** A map of annotations.
   * Annotations ([Annotation]) are the meta information providing
   * additional information about how to handle a view.
   * The meaning depends on the tool or utility that handles a view.
   */
  Map<String, Annotation> get annotations
  => _annos != null ? _annos: MapUtil.onDemand(() => _annos = new Map());

  String toString() => "$className(${id.isEmpty ? _uuid != null ? _uuid: '': id})";
}
