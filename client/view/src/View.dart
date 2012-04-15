/* View.dart

	History:
		Mon Jan	9 13:01:36 TST 2012, Created by tomyeh

Copyright (C) 2012 Potix Corporation. All Rights Reserved.
*/

/** Called after all [View.enterDocument_] methods are called, where
 * [topView] is the topmost view that the binding starts with.
 */ 
typedef void AfterEnterDocument(View topView);
/** Returns a DOM-level event listener that converts a DOM event to a view event
 * ([ViewEvent]) and dispatch to the right target.
 */
typedef EventListener DomEventDispatcher(View target);

/**
 * A view.
 * <p>Notice that if a view implements [IdSpace], it has to override
 * [getFellow] and [bindFellow_]. Please refer to [Section] for sample code.
 */
class View implements EventTarget {
	String _id = "";
	String _uuid;

	View _parent;
	View _nextSibling, _prevSibling;
	//Virtual ID space. Used only if this is root but not IdSpace
	IdSpace _virtIS;

	_ChildInfo _childInfo;
	_EventListenerInfo _evlInfo;
	Map<String, Object> _attrs;

	//the classes; created on demand
	Set<String> _classes;
	//the CSS style; created on demand
	CSSStyleDeclaration _style;
	String _vclass;
	Element _node;

	int _left = 0, _top = 0, _width, _height;
	Offset _scrlofs, _innerofs; //rarely used (so saving memory)
	ProfileDeclaration _profile;
	LayoutDeclaration _layout;

	bool _hidden, _inDoc;

	View() {
		_vclass = "v-View";
	}

	_ChildInfo _initChildInfo() {
		if (_childInfo === null)
			_childInfo = new _ChildInfo();
		return _childInfo;
	}
	_EventListenerInfo _initEventListenerInfo() {
		if (_evlInfo === null)
			_evlInfo = new _EventListenerInfo();
		return _evlInfo;
	}

	/** Returns the UUID of this component, never null.
	 */
	String get uuid() {
		if (_uuid === null)
			_uuid = _nextUuid();
		return _uuid;
	}
	static String _nextUuid() {
		int v = _uuidNext++;
		final StringBuffer sb = new StringBuffer("w_");
		do {
			int v2 = v % 37;
			if (v2 <= 9) sb.add(addCharCodes('0', v2));
			else sb.add(v2 == 36 ? '_': addCharCodes('a', v2 - 10));
		} while ((v ~/= 37) >= 1);
		return sb.toString();
	}
	static int _uuidNext = 0;

	/** Returns the ID of this view, or an empty string if not assigned.
	 */
	String get id() {
		return _id;
	}
	/** Sets the ID of this view.
	 */
	void set id(String id) {
		if (id === null) id = "";
		if (_id != id) {
			if (id.length > 0)
				_checkIdSpaces(this, id);
			_removeFromIdSpaces(this);
			_id = id;
			_addToIdSpace(this);
		}
	}
	/** Searches and returns the first view that matches the given selector.
	 */
	View query(String selector) {
		//TODO
	}
	/** Searches and returns all views that matches the selector.
	 */
	Iterable<View> queryAll(String selector) {
		//TODO
	}

	/** Returns the view of the given ID, or null if not found.
	 * <p>If a view implements [IdSpace] must override [getFellow] and
	 * [bindFellow_].
	 */
	View getFellow(String id) => spaceOwner.getFellow(id);
	/** Updates the fellow information.
	 * <p>Default: throw [UnsupportedOperationException].
	 * <p>If a view implements [IdSpace] must override [getFellow] and
	 * [bindFellow_].
	 * <p>If fellow is null, it means to remove the binding.
	 */
	void bindFellow_(String id, View fellow) {
		throw const UnsupportedOperationException ("Not IdSpace");
	}
	/** Returns the owner of the ID space that this view belongs to.
	 * <p>A virtual [IdSpace] is used if this view is a root but is not IdSpace.
	 */
	IdSpace get spaceOwner() => _spaceOwner(this, false); //not to ignore virtual

	static IdSpace _spaceOwner(View view, bool ignoreVirtualIS) {
		View top;
		var p = view;
		do {
			if (p is IdSpace)
				return p;
			top = p;
		} while ((p = p.parent) != null);

		if (!ignoreVirtualIS) {
			if (top._virtIS === null)
				top._virtIS = new _VirtualIdSpace(top);
			return top._virtIS;
		}
	}
	/** Checks the uniqueness in ID space when changing ID. */
	static void _checkIdSpaces(View view, String newId) {
		var space = view.spaceOwner;
		if (space.getFellow(newId) !== null)
			throw new UiException("Not unique in the ID space of $space: $newId");

		//we have to check one level up if view is IdSpace (i.e., unique in two ID spaces)
		View parent;
		if (view is IdSpace && (parent = view.parent) != null) {
			space = parent.spaceOwner;
			if (space.getFellows(newId) !== null)
				throw new UiException("Not unique in the ID space of $space: $newId");
		}
	}
	//Add the given view to the ID space
	static void _addToIdSpace(View view){
		String id = view.id;
		if (id.length == 0)
			return;

		var space = view.spaceOwner;
		space.bindFellow_(id, view);

		//we have to put it one level up if view is IdSpace (i.e., unique in two ID spaces)
		View parent;
		if (view is IdSpace && (parent = view.parent) != null) {
			space = parent.spaceOwner;
			space.bindFellow_(id, view);
		}
	}
	//Add the given view and all its children to the ID space
	static void _addToIdSpaceDown(View view, var space) {
		if (view is IdSpace) {
			if (space === null) //the top invocation made by insertBefore called
				_addToIdSpace(view);
			return; //done
		}

		if (space === null)
			space = view.spaceOwner;

		var id = view.id;
		if (id.length > 0)
			space.bindFellow_(id, view);

		for	(view = view.firstChild; view != null; view = view.nextSibling)
			_addToIdSpaceDown(view, space);
	}
	static void _removeFromIdSpaces(View view) {
		String id = view.id;
		if (id.length == 0)
			return;

		var space = view.spaceOwner;
		space.bindFellow_(id, null);

		//we have to put it one level up if view is IdSpace (i.e., unique in two ID spaces)
		View parent;
		if (view is IdSpace && (parent = view.parent) != null) {
			space = parent.spaceOwner;
			space.bindFellow_(id, null);
		}
	}

	/** Returns if a view is a descendant of this view or
	 * it is identical to this view.
	 */
	bool isDescendantOf(View parent) {
		for (View w = this; w !== null; w = w.parent)
			if (w === parent)
				return true;
		return false;
	}
	/** Returns the nearest ancestor who is an instance of the given class,
	 * or null if not found.
	 */
/* TODO: wait until Dart supports reflection
	View getAncestorWith(Class type) {
		for (View p = this; (p = p.parent) !== null;)
			if (p is type)
				return p;
		return null;
	}
*/
	/** Returns the parent, or null if this view does not have any parent.
	 */
	View get parent() => _parent;
	/** Returns the first child, or null if this view has no child at all.
	 */
	View get firstChild() => _childInfo !== null ? _childInfo.firstChild: null;
	/** Returns the last child, or null if this view has no child at all.
	 */
	View get lastChild() => _childInfo !== null ? _childInfo.lastChild: null;
	/** Returns the next sibling, or null if this view is the last sibling.
	 */
	View get nextSibling() => _nextSibling;
	/** Returns the previous sibling, or null if this view is the previous sibling.
	 */
	View get previousSibling() => _prevSibling;
	/** Returns a list of child views.
	 */
	List<View> get children() {
		final _ChildInfo ci = _initChildInfo();
		if (ci.children === null)
			ci.children = new _SubviewList(this);
		return ci.children;
	}
	/** Returns the number of child views.
	 */
	int get childCount() => _childInfo != null ? _childInfo.nChild: 0;

	/** Callback when a child has been added.
	 * <p>Default: does nothing.
	 */
	void onChildAdded_(View child) {}
	/** Callback when a child is going to be removed.
	 * <p>Default: does nothing.
	 */
	void beforeChildRemoved_(View child) {}
	/** Callback when a child has been removed.
	 * <p>Default: does nothing.
	 */
	void onChildRemoved_(View child) {}
	/** Callback when this view's parent has been changed.
	 */
	void onParentChanged_(View oldParent) {}
	/** Callback before this view's parent is going to change.
	 */
	void beforeParentChanged_(View newParent) {}

	/** Returns whether this view allows any child views.
	 * <p>Default: true.
	 * <p>The deriving class shall override this method
	 * to return false if it doesn't allow any child views.
	 */
	bool isChildable_() => true;

	/** Appends a child to the end of all children.
	 * It calls [insertBefore] with beforeChild to be null, so the 
	 * subclass needs to override [insertBefore] if necessary.
	 */
	void appendChild(View child) {
		insertBefore(child, null);
	}
	/** Inserts a child before the reference child.
	 * If the given view is always a child, its position among children
	 * will be changed depending on [beforeChild].
	 * <p>Notice that [appendChild] will call back this methid, so the subclass
	 * need only to override this method, if necessary.
	 */
	void insertBefore(View child, View beforeChild) {
		if (isDescendantOf(child))
			throw new UiException("$child is an ancestor of $this");
		if (!isChildable_())
			throw const UiException("No child allowed in Button");

		if (beforeChild !== null) {
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
		if (oldParent !== null)
			oldParent._removeChild(child, false); //not to notify child

		_link(this, child, beforeChild);
		child._parent = this;
		++_childInfo.nChild;

		_addToIdSpaceDown(child, null);
		if (inDocument) {
			insertChildToDocument_(child, child._asHTML(), beforeChild);
			child._enterDocument();
		}

		onChildAdded_(child);
		if (parentChanged)
			child.onParentChanged_(oldParent);
	}
	/** Removes a child.
	 * It returns true if the child is removed succefully, or false if it is
	 * a child.
	 */
	bool removeChild(View child) {
		_removeChild(child, true);
	}
	bool _removeChild(View child, bool notifyChild) {
		if (child.parent !== this)
			return false;

		beforeChildRemoved_(child);
		if (notifyChild)
			child.beforeParentChanged_(null);

		child._exitDocument();
		removeChildFromDocument_(child);

		_unlink(this, child);
		child._parent = null;
		--_childInfo.nChild;
		if (notifyChild)
			child.onParentChanged_(this);
		onChildRemoved_(child);
		return true;
	}

	/** Inserts the HTML content generated by the given child view before
	 * the reference view (beforeChild).
	 * It is called by {@link #insertBefore} and {@link #appendChild} to attach
	 * the DOM elements to the document.
	 * <p>Deriving classes might override this method to modify the HTML content,
	 * such as enclosing with TD, or to insert the HTML content to a different
	 * position.
	 */
	void insertChildToDocument_(View child, String html, View beforeChild) {
		if (beforeChild !== null) {
			beforeChild.node.insertAdjacentHTML("beforeBegin", html);
		} else {
			innerNode.insertAdjacentHTML("beforeEnd", html);
		}
	}
	/** Removes the corresponding DOM elements of the give child from the document.
	 * It is called by [removeChild] to remove the DOM elements.
	 */
	void removeChildFromDocument_(View child) {
		child.node.remove();
	}

	static void _link(View view, View child, View beforeChild) {
		final _ChildInfo ci = view._initChildInfo();
		if (beforeChild === null) {
			View p = ci.lastChild;
			if (p !== null) {
				p._nextSibling = child;
				child._prevSibling = p;
				ci.lastChild = child;
			} else {
				ci.firstChild = ci.lastChild = child;
			}
		} else {
			View p = beforeChild._prevSibling;
			if (p !== null) {
				child._prevSibling = p;
				p._nextSibling = child;
			} else {
				ci.firstChild = child;
			}

			beforeChild._prevSibling = child;
			child._nextSibling = beforeChild;
		}
	}
	static void _unlink(View view, View child) {
		var p = child._prevSibling, n = child._nextSibling;
		if (p !== null) p._nextSibling = n;
		else view._childInfo.firstChild = n;
		if (n !== null) n._prevSibling = p;
		else view._childInfo.lastChild = p;
		child._nextSibling = child._prevSibling = child._parent = null;
	}

	/** Returns the DOM element associated with this view.
	 * This method returns null if this view is not bound the DOM, i.e.,
	 * [inDocument] is false.
	 * <p>To retrieve a child element, use the [getNode] method instead.
	 * <p>Notice that the parent view can have the same DOM element as
	 * its child. In other words, you might consider one of them is
	 * <i>virtual</i>. Furthermore, depending on your implementation,
	 * you might have to override [insertChildToDocument_] and/or
	 * [removeChildFromDocument_] if they share the same DOM element.
	 */
	Element get node()
	=> _node !== null ? _node: _inDoc ? (_node=document.query('#' + uuid)): null;
	/** Returns the child element of the given sub-ID.
	 * This method assumes the ID of the child element the concatenation of
	 * uuid, dash ('-'), and subId.
	 */
	Element getNode(String subId) =>
		_inDoc ? document.query(subId != null && subId.length > 0 ?
					 '#' + uuid + '-' + subId: '#' + uuid): null;
	/** Returns if this view has been attached to the document.
	 */
	bool get inDocument() => _inDoc;

	/** Returns the element representing the inner element.
	 * If there is no inner element, this method is the same as [node].
	 * <p>Default: [node].
	 * <p>The inner element is used to place the child views and provide a coordinate
	 * system originating at [innerLeft] and [innerTop] rather than (0, 0).
	 * <p>To support the inner element, the deriving class has to override this method.
	 * And, optionally, override [innerSpacing_] if there is some spacing at the right
	 * or at the bottom. If not all child views are in the inner element, it has to
	 * override [shallLayout_] too.
	 * Please refer to the viewport example for a sample implementation.
	 */
	Element get innerNode() => node;

	/** Adds this view to the document (i.e., the screen that the user interacts with).
	 * all of its descendant views are added too.
	 * <p>You rarely need to invoke this method directly. In most cases,
	 * you shall invoke [appendChild] or [insertBefore] instead.
	 * <p>On the other hand, this method is usually used if you'd like to add
	 * a view to the content of [WebView].
	 * Notice that this method can be called only if this view has no parent.
	 * If a view has a parent, whether it is attached to the document
	 * shall be controlled by its parent.
	 */
	void addToDocument(Element node,
	[bool outer=false, bool inner=false, Element before]) {
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

		if (nxt !== null)
			nxt.insertAdjacentHTML("beforeBegin", html);
		else if (p !== null)
			p.insertAdjacentHTML("beforeEnd", html);

		_enterDocument();
	}
	/** Removes this view from the document.
	 * All of its descendant views are removed too.
	 * <p>You rarely need to invoke this method directly. In most cases,
	 * you shall invoke [removeChild] instead.
	 * <p>On the other hand, this method is usually used if you'd like to undo
	 * the attachment made by [addToDocument].
	 * Notice that this method can be called only if this view has no parent.
	 * If a view has a parent, whether it is attached to the document
	 * shall be controlled by its parent.
	 */
	void removeFromDocument() {
		final Element n = node; //store first since _node will be cleared up later
		_exitDocument();
		n.remove();
	}
	/** Binds the view.
	 */
	void _enterDocument() {
		_afters = [];

		enterDocument_();
		doLayout();

		for (final AfterEnterDocument call in _afters)
			call(this);
		_afters = null;
	}
	/** Adds a task to be executed after all [enterDocument_] are called.
	 * <p>Notice that this method can be called only in [enterDocument_].
	 * Furthermore, all tasks scheduled with this method will be queued
	 * and executed righter [enterDocument_] of all views are called.
	 * @exception NullPointerException if this method is not called in [enterDocument_]
	 */
	static void afterEnterDocument_(AfterEnterDocument after) {
		_afters.add(after);
	}
	static List<AfterEnterDocument> _afters;
	
	/** Unbinds the view.
	 */
	void _exitDocument() {
		exitDocument_();
	}
	/** Callback when this view is attached to the document.
	 * <p>Default: invoke [enterDocument_] for each child.
	 * <p>Subclass shall call back this method if it overrides this method. 
	 * <p>If the deriving class would like some tasks to be executed
	 * after [enterDocument_] of all new-attached views are called, it can
	 * invoke [afterEnterDocument_] to queue the task.
	 * <p>See also [inDocument] and [invalidate].
	 */
	void enterDocument_() {
		_inDoc = true;

		final Element n = node, inner = innerNode;
		if (inner !== n) {
			//sync innerNode's positon and size
			inner.style.left = "${innerLeft}px";
			inner.style.top = "${innerTop}px";
			int v = n.$dom_clientWidth - innerSpacing_.width;
			inner.style.width = "${v > 0 ? v: 0}px";
			v = n.$dom_clientHeight - innerSpacing_.height;
			inner.style.height = "${v > 0 ? v: 0}px";
		}

		//Listen the DOM element if necessary
		if (_evlInfo !== null && _evlInfo.listeners !== null) {
			final Map<String, List<EventListener>> listeners = _evlInfo.listeners;
			for (final String type in listeners.getKeys()) {
				final DomEventDispatcher disp = getDomEventDispatcher_(type);
				if (disp != null && !listeners[type].isEmpty())
					domListen_(n, type, disp);
			}
		}

		for (View child = firstChild; child != null; child = child.nextSibling)
				child.enterDocument_();
	}
	/** Callback when this view is detached from the document.
	 * <p>Default: invoke [exitDocument_] for each child.
	 * <p>Subclass shall call back this method if it overrides this method. 
	 */
	void exitDocument_() {
		//Unlisten the DOM element if necessary
		final Element n = node;
		if (_evlInfo !== null && _evlInfo.listeners !== null) {
			final Map<String, List<EventListener>> listeners = _evlInfo.listeners;
			for (final String type in listeners.getKeys()) {
				if (getDomEventDispatcher_(type) != null && !listeners[type].isEmpty())
					domUnlisten_(n, type);
			}
		}

		for (View child = firstChild; child != null; child = child.nextSibling)
				child.exitDocument_();

		_inDoc = false;
		_node = null; //as the last step since node might be called in exitDocument_
	}

	/** Called when something has changed and caused that the display of this
	 * view has to draw.
	 * It has no effect if it is not attached (i.e., [inDocument] is true).
	 * <p>Notice that, for better performance, the view won't be redrawn immediately.
	 * Rather, it is queued and all queued invalidation will be drawn together later.
	 * If you'd like to draw all queued invalidation immediately, you can
	 * invoke [doInvalidate].
	 */
	void invalidate() {
		_invalidator.queue(this);
	}
	/** Redraws the invalidated views queued by [invalidate].
	 * <p>Notice that it is static, i.e., all queued invalidation will be redrawn.
	 */
	static void flushInvalidated() {
		_invalidator.flush();
	}

	/** Called when something has changed and caused that the layout of this
	 * view is changed.
	 */
	void requestLayout() {
		layoutManager.queue(this);
	}
	/** Handles the layouts of views queued by [requestLayout].
	 * <p>Notice that it is static, i.e., all queued requests will be handled.
	 */
	static void flushRequestedLayouts() {
		layoutManager.flush();
	}
	/** Hanldes the layout of this view.
	 * <p>Default: have [Layout] to handle it.
	 */
	void doLayout([MeasureContext mctx=null]) {
		layoutManager.layout(mctx, this);
	}
	/** Measures the width of this view.
	 * It is called by [doLayout].
	 */
	int measureWidth(MeasureContext mctx)
	=> layoutManager.measureWidth(mctx, this);
	/** Measures the height of this view.
	 * It is called by [doLayout].
	 */
	int measureHeight(MeasureContext mctx)
	=> layoutManager.measureHeight(mctx, this);
	/** Returns whether the given child shall be handled by the layout manager.
	 * <p>Default: always true.
	 * <p>The deriving class shall override this method if the position of
	 * some of its child view is <code>static</code>.
	 * In additions, if the deriving class supports an inner element and not all chid
	 * elements in the inner element, it shall override this method to skip the child
	 * views <i>not</i> in the inner element.
	 * Please refer to the viewport example for a sample implementation.
	 * <p>Note that, if this method returns false for a child, the layout
	 * manager won't adjust its position and dimension. However, the child's [doLayout]
	 * will be still called to arrange the layout of the child's child views.
	 */
	bool shallLayout_(View child) => true;

	/** Generates the HTML fragment for this view and its descendants
	 * to the given string buffer.
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
	 * <p>Default: <code>div</code>.
	 */
	String get domTag_() => "div";

	/**Shortcut of [draw].*/
	String _asHTML() {
		StringBuffer out = new StringBuffer();
		draw(out);
		return out.toString();
	}

	/** Returns if this view is hidden.
	 */
	bool get hidden() => _hidden;
	/** Sets if this view is hidden.
	 */
	void set hidden(bool hidden) {
		_hidden = hidden;

		final Element n = node;
		if (n !== null)
			n.hidden = hidden;
	}

	/** Returns the left position of this view relative to its parent.
	 * <p>Default: 0
	 */
	int get left() => _left;
	/** Sets the left position of this view relative to its parent.
	 */
	void set left(int left) {
		_left = left;

		final Element n = node;
		if (n !== null)
			n.style.left = "${left}px";
	}
	/** Returns the top position of this view relative to its parent.
	 * <p>Default: 0
	 */
	int get top() => _top;
	/** Sets the top position of this view relative to its parent.
	 */
	void set top(int top) {
		_top = top;

		final Element n = node;
		if (n !== null)
			n.style.top = "${top}px";
	}

	/** Returns the left position of this view relative to its parent.
	 * <p>Default: 0
	 */
	int get scrollLeft() => _scrlofs !== null ? _scrlofs.left: 0;
	/** Sets the left position of this view relative to its parent.
	 */
	void set scrollLeft(int left) {
		if (_scrlofs !== null) _scrlofs.left = left;
		else _scrlofs = new Offset(left, 0);

		final Element n = innerNode;
		if (n !== null)
			n.$dom_scrollLeft = left;
	}
	/** Returns the top position of this view relative to its parent.
	 * <p>Default: 0
	 */
	int get scrollTop() => _scrlofs !== null ? _scrlofs.top: 0;
	/** Sets the top position of this view relative to its parent.
	 */
	void set scrollTop(int top) {
		if (_scrlofs !== null) _scrlofs.top = top;
		else _scrlofs = new Offset(top, 0);

		final Element n = innerNode;
		if (n !== null)
			n.$dom_scrollTop = top;
	}

	/** Returns the width of this view.
	 * <p>Default: null (up to the system).
	 * <p>To get the real width on the document, use [outerWidth].
	 */
	int get width() => _width;
	/** Sets the width of this view.
	 */
	void set width(int width) {
		_width = width;

		final Element n = node;
		if (n !== null) {
			n.style.width = width !== null ? "${width}px": "";

			final Element inner = innerNode;
			if (inner !== n) {
				final int v = n.$dom_clientWidth - innerSpacing_.width;
				inner.style.width = "${v > 0 ? v: 0}px";
			}
		}
	}
	/** Returns the height of this view.
	 * <p>Default: null (up to the system)
	 * <p>To get the real height on the document, use [outerWidth].
	 */
	int get height() => _height;
	/** Sets the height of this view.
	 */
	void set height(int height) {
		_height = height;

		final Element n = node;
		if (n !== null) {
			n.style.height = height !== null ? "${height}px": "";

			final Element inner = innerNode;
			if (inner !== n) {
				final int v = n.$dom_clientHeight - innerSpacing_.height;
				inner.style.height = "${v > 0 ? v: 0}px";
			}
		}
	}

	/** Returns the left offset of the origin of the child's coordinate system.
	 * <p>Default: 0.
	 */
	int get innerLeft() => _innerofs !== null ? _innerofs.left: 0;
	/** Returns the top offset of the origin of the child's coordinate system.
	 * <p>Default: 0.
	 */
	int get innerTop() => _innerofs !== null ? _innerofs.top: 0;
	/** Returns the left offset of the origin of the child's coordinate system.
	 * <p>Default: 0.
	 * <p>Whether a view allows the developer to change the origin is up to the view's
	 * spec. By default, it is not supported.
	 * To support it, the view usually introduces an additional DIV to provide
	 * the origin for the child views, and overrides [innerNode] to return it.
	 * Please refer to the viewport example for a sample implementation.
	 */
	void set innerLeft(int left)  {
		if (_innerofs !== null) _innerofs.left = left;
		else _innerofs = new Offset(left, 0);

		final Element n = innerNode;
		if (n != null) {
			if (n === node) throw const UiException("No inner element");
			n.style.left = "${left}px";
		}
	}
	/** Returns the top offset of the origin of the child's coordinate system.
	 * <p>Default: throws [UiException].
	 * <p>Whether a view allows the developer to change the origin is up to the view's
	 * spec. By default, it is not supported.
	 * To support it, the view usually introduces an additional DIV to provide
	 * the origin for the child views, and overrides [innerNode] to return it.
	 * Please refer to the viewport example for a sample implementation.
	 */
	void set innerTop(int top) {
		if (_innerofs !== null) _innerofs.top = top;
		else _innerofs = new Offset(0, top);

		final Element n = innerNode;
		if (n != null) {
			if (n === node) throw const UiException("No inner element");
			n.style.top = "${top}px";
		}
	}
	/** Returns the spacing between the inner element and the border.
	 * <p>Default: <code>new Size(innerLeft, innerTop)</code>
	 * <p>Notice: instead of overriding [width] and [height], you
	 * shall override this method if the spacing is more than
	 * [innerLeft] and [innerTop].
	 */
	Size get innerSpacing_() => new Size(innerLeft, innerTop);

	/** Returns the real width of this view shown on the document (never null).
	 * <p>Notice that the performance of this method is not good, if
	 * [width] is null.
	 */
	int get outerWidth()
	=> _width !== null ? _width: inDocument ? node.$dom_offsetWidth: 0;
		//for better performance, we don't need to get $dom_offsetWidth if _width is
		//assigned (because we use box-sizing: border-box)
	/** Returns the real height of this view shown on the document (never null).
	 * <p>Notice that the performance of this method is not good, if
	 * [height] is null.
	 */
	int get outerHeight()
	=> _height !== null ? _height: inDocument ? node.$dom_offsetHeight: 0;
		//for better performance, we don't need to get $dom_offsetHeight if _height is
		//assigned (because we use box-sizing: border-box)
	/** Returns the viewable width of this view, excluding the borders, margins
	 * and scrollbars.
	 * <p>Note: this method returns [width] if [inDocument] is false and [width] is not null.
	 * In other words, it doesn't exclude the border's width if not attached to the document
	 * (for performance reason). However, we might change it in the future, so it is better
	 * not to call this method if the view is not attached.
	 */
	int get innerWidth() {
		final int v = inDocument ? innerNode.$dom_clientWidth:
			(_width !== null ? _width - innerSpacing_.width: 0);
		return v > 0 ? v: 0;
	}
	/** Returns the viewable height of this view, excluding the borders, margins
	 * and scrollbars.
	 * <p>Note: this method returns [height] if [inDocument] is false and [height] is not null.
	 * In other words, it doesn't exclude the border's height if not attached to the document
	 * (for performance reason). However, we might change it in the future, so it is better
	 * not to call this method if the view is not attached.
	 */
	int get innerHeight() {
		final int v = inDocument ? innerNode.$dom_clientHeight:
			(_height !== null ? _height - innerSpacing_.height: 0);
		return v > 0 ? v: 0;
	}

	/** Returns the offset of this view relative to the left-top corner
	 * of the document.
	 */
	Offset get documentOffset() {
		final Offset ofs = new Offset(0, 0);
		for (View view = this;;) {
			ofs.left += view.left;
			ofs.top += view.top;
			if (view.style.position == "fixed")
				break; //done

			final View p = view.parent;
			if (p == null) {
				final Offset nofs = new DomAgent(view.node).documentOffset;
				ofs.left += nofs.left;
				ofs.top += nofs.top;
				break;
			} else {
				view = p;
			}
		}
		return ofs;
	}
	/** Returns the layout instruction of this view.
	 * <p>[layout] intructs how a view shall layout the child views.
	 * In additions, you can specify addition information in individual child
	 * view's [profile].
	 */
	LayoutDeclaration get layout() {
		if (_layout == null)
			_layout = new LayoutDeclarationImpl(this);
		return _layout;
	}
	/** Returns the profile, i.e., the layouot requirement, of this view.
	 * It provides additional information for the parent view to
	 * layout this view.
	 * <p>See also [layout].
	 */
	ProfileDeclaration get profile() {
		if (_profile == null)
			_profile = new ProfileDeclarationImpl(this);
		return _profile;
	}

	/** Retuns the CSS style.
	 */
	CSSStyleDeclaration get style() {
		if (_style === null)
			_style =  new CSSStyleDeclarationImpl(this);
		return _style;
	}

	/** Retuns the view class.
	 */
	String get vclass() => _vclass;
	/** Sets the view class.
	 * <p>Default: empty, but an implementation usually provides a default
	 * class, such as <code>v-TextView</code>. It is used to provide
	 * the default look for this view. If vclass is changed, all the default
	 * styles are gone.
	 */
	void set vclass(String newwc) {
		final String oldwc = _vclass;
		if (oldwc == newwc)
			return; //nothing to do

		_vclass = newwc;

		Element n = node;
		if (n != null) {
			if (!oldwc.isEmpty())
				n.classes.remove(oldwc);
			if (!newwc.isEmpty())
				n.classes.add(newwc);
		}
	}
	/** Returns a readonly list of the additional style classes.
	 */
	Set<String> get classes() {
		if (_classes === null)
			_classes = new Set();
		return _classes;
	}
	/** Adds the give style class.
	 */
	void addClass(String className) {
		classes.add(className);
		Element n = node;
		if (n != null)
			n.classes.add(className);
	}
	/** Removes the give style class.
	 */
	void removeClass(String className) {
		if (_classes != null) {
			_classes.remove(className);
			Element n = node;
			if (n != null)
				n.classes.remove(className);
		}
	}

	/** Ouptuts all HTML attributes used for the DOM element of this view
	 * to the given output.
	 * It is called by [draw], and the deriving class can override it
	 * to provide more attributes. Of course, if you override [draw]
	 * directly, you can decide whether to call this method.
	 */
	void domAttrs_(StringBuffer out,
	[bool noId=false, bool noStyle=false, bool noClass=false]) {
		String s;
		if (!noId && !(s = uuid).isEmpty())
			out.add(' id="').add(s).add('"');
		if (!noStyle) {
			final StringBuffer stylesb = new StringBuffer();
			domStyle_(stylesb);
			if (!stylesb.isEmpty())
					out.add(' style="').add(stylesb).add('"');
		}
		if (!noClass) {
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
	 * <p>Default: invoke each child view's [draw] sequentially.
	 */
	void domInner_(StringBuffer out) {
		for (View child = firstChild; child !== null; child = child.nextSibling)
			child.draw(out);
	}
	/** Outputs a list of the CSS classes for the DOM element of this view
	 * to the given output. If there are multiple CSS classes, seperate them
	 * with a space.
	 */
	void domClass_(StringBuffer out, [bool noVclass=false, bool noClass=false]) {
		out.add("v-");
		if (!noVclass)
			out.add(' ').add(vclass);
		if (!noClass && _classes != null)
			for (final String cls in _classes)
				out.add(' ').add(cls);
	}
	/** Output the CSS style for the DOM element of this view to the given outout.
	 */
	void domStyle_(StringBuffer out, [bool noLeft=false, bool noTop=false,
	bool noWidth=false, bool noHeight=false, bool noHidden=false,
	bool noStyle=false]) {
		if (!noLeft && left != 0)
			out.add("left:").add(left).add("px;");
		if (!noTop && top != 0)
			out.add("top:").add(top).add("px;");
		if (!noWidth && _width !== null) //don't use width since it has special handling
			out.add("width:").add(_width).add("px;");
		if (!noHeight && _height !== null) //don't use height since it has special handling
			out.add("height:").add(_height).add("px;");
		if (!noHidden && hidden)
			out.add("display:none;");
		String s;
		if (!noStyle && _style !== null && !(s = _style.cssText).isEmpty())
			out.add(s);
	}

	/** Returns [ViewEvents] for adding or removing event listeners.
	 */
	ViewEvents get on() {
		final _EventListenerInfo ei = _initEventListenerInfo();
		if (ei.on === null)
			ei.on = new ViewEvents(this);
		return ei.on;

	}
	/** Adds an event listener.
	 * <code>addEventListener("click", listener)</code> is the same as
	 * <code>on.click.add(listener)</code>.
	 */
	View addEventListener(String type, EventListener listener, [bool useCapture = false]) {
		if (listener == null)
			throw const UiException("listener required");

		final _EventListenerInfo ei = _initEventListenerInfo();
		if (ei.listeners == null)
			ei.listeners = {};

		bool first;
		ei.listeners.putIfAbsent(type, () {
			first = true;
			return [listener];
		});

		Element n;
		DomEventDispatcher disp;
		if (first && (n = node) != null
		&& (disp = getDomEventDispatcher_(type)) != null)
			domListen_(n, type, disp);
		return this;
	}

	/** Removes an event listener.
	 * <code>addEventListener("click", listener)</code> is the same as
	 * <code>on.click.remove(listener)</code>.
	 */
	View removeEventListener(String type, EventListener listener, [bool useCapture = false]) {
		List<EventListener> ls;
		if (_evlInfo !== null && _evlInfo.listeners !== null
		&& (ls = _evlInfo.listeners[type]) != null) {
			int j = ls.indexOf(listener);
			Element n;
			if (j >= 0)
				ls.removeRange(j, 1);
			if (ls.isEmpty() && (n = node) != null
			&& getDomEventDispatcher_(type) != null)
				domUnlisten_(n, type);
		}
		return this;
	}
	/** Dispatches an event to this view.
	 * <p>Example: <code>view.dispatchEvent(new ViewEvent(target, "click"))</code>.
	 * If the type parameter is not specified, it is assumed to be [ViewEvent.type].
	 */
	bool dispatchEvent(ViewEvent event, [String type]) {
		if (type == null)
			type = event.type;

		List<EventListener> ls;
		bool dispatched = false;
		if (_evlInfo !== null && _evlInfo.listeners != null
		&& (ls = _evlInfo.listeners[type]) != null) {
			event.currentTarget = this;
			for (final EventListener listener in ls) {
				dispatched = true;
				listener(event);
				if (event.propagationStopped)
					return true; //done
			}
		}
		return dispatched;
	}
	/** Returns if there is any event listener registered to the given type.
	 */
	bool isEventListened(String type) {
		List<EventListener> ls;
		return _evlInfo !== null && _evlInfo.listeners != null
			&& (ls = _evlInfo.listeners[type]) != null && !ls.isEmpty();
	}
	/** Returns if the given event type is a DOM event.
	 * If true, [domListen_] will be invoked to register the DOM event.
	 */
	DomEventDispatcher getDomEventDispatcher_(String type) {
		if (_domEvtDisps == null) {
			_domEvtDisps = {};
			
			//TODO: handle event better, and handle more DOM events
			//example: click shall carry mouse position, change shall carry value
			DomEventDispatcher disp = (View target) {
				return (Event event) {
					target.dispatchEvent(new ViewEvent<Object>.dom(target, event, type: type));
				};
			};
			for (final String nm in
			const ["click", "blur", "focus", "change", "mouseDown", "mouseUp", "mouseOver", "mouseOut"])
				_domEvtDisps[nm] = disp;
		}
		return _domEvtDisps[type];
	}
	static Map<String, DomEventDispatcher> _domEvtDisps;

	/** Listen the given event type.
	 */
	void domListen_(Element n, String type, DomEventDispatcher disp) {
		final EventListener ln = disp(this); //must be non-null
		final _EventListenerInfo ei = _initEventListenerInfo();
		if (ei.domListeners === null)
			ei.domListeners = {};
		ei.domListeners[type] = ln;
		n.on[type].add(ln);
	}
	/** Unlisten the given event type.
	 */
	void domUnlisten_(Element n, String	type) {
		if (_evlInfo !== null) {
			final EventListener ln = _evlInfo.domListeners.remove(type);
			if (ln !== null)
				n.on[type].remove(ln);
		}
	}

	/** Returns the value of the given attribute, or null if not assigned.
	 */
	Object getAttribute(String name) {
		return _attrs !== null ? _attrs[name]: null;
	}
	/** Returns if the given attribute has been assigned with a value
	 * (including null).
	 */
	bool hasAttribute(String name) {
		return _attrs !== null && _attrs.containsKey(name);
	}
	/** Sets the value to the given attribute.
	 */
	void setAttribute(String name, Object value) {
		if (_attrs == null)
			_attrs = new Map();
		_attrs[name] = value;
	}
	/** Remove the given attribute.
	 */
	void removeAttribute(String name) {
		if (_attrs !== null) _attrs.remove(name);
	}

	/** Schedules a run-once task.
	 * It is used to schedule a long-execution task that has the same effect
	 * no matter how many times it is executed. For example, [rerender].
	 * <p>If tasks are run with the same against the same view, they are
	 * considered as the same task, and [runOnce] will execute only one of
	 * them (the one with the longest timeout).
	 */
	void runOnce(String key, RunOnceTask task, [timeout=0]) {
		if (_runOnceQue === null)
			_runOnceQue = new RunOnceQueue();
		_runOnceQue.add(uuid + key, task, timeout: timeout);
	}
	static RunOnceQueue _runOnceQue;

	int hashCode() {
		return uuid.hashCode(); //uuid is immutiable once assigned
	}

  /** useless; always does nothing. */
	void $dom_addEventListener(String type, void listener(Event event), [bool useCapture]) {
	}
  /** useless; always does nothing and returns false. */
	bool $dom_dispatchEvent(Event event) {
	  return false;
	}
  /** useless; always does nothing. */
	void $dom_removeEventListener(String type, void listener(Event event), [bool useCapture]) {
	}
}
