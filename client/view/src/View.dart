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
 * [getFellow] and [bindFellow_]. Please refer to [Segment] for sample code.
 */
class View implements EventTarget {
	String _id = "";
	String _uuid;

	View _parent;
	View _nextSibling, _prevSibling;
	//Virtual ID space. Used only if this is root but not IdSpace
	IdSpace _virtIS;

	_ChildInfo _childInfo;
	_CSSInfo _cssInfo;
	String _wclass;
	_EventListenerInfo _evlInfo;

	String _prefixOfHTML = "";
	bool _hidden, _inDoc;

	View() {
		_wclass = "v-view";
	}

	/** Instantiates the wrapper to handle [CSSStyleDeclaration].
	 * <p>Default: create an instance of [CSSStyleWrapper].
	 * If a deriving class has to override the default behavior, it could
	 * extend [CSSStyleWrapper] to override the corresponding method, and
	 * then return an instance of the subclass.
	 */
	CSSStyleWrapper newCSSStyleWrapper_() => new CSSStyleWrapper(this);

	_CSSInfo _initCSSInfo() {
		if (_cssInfo === null)
			_cssInfo = new _CSSInfo();
		return _cssInfo;
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
	List<View> queryAll(String selector) {
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
/* TODO
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
			ci.children = new SubviewList(this);
		return ci.children;
	}
	/** Returns the number of child views.
	 */
	int get childCount() => _childInfo != null ? _childInfo.nChild: 0;

	/** Callback when a child has been added.
	 * <p>Default: does nothing.
	 */
	void didAddChild_(View child) {}
	/** Callback when a child has been removed.
	 * <p>Default: does nothing.
	 */
	void willRemoveChild_(View child) {}
	/** Callback when this view's parent has been changed.
	 */
	void didChangeParent_(View oldParent) {}
	/** Callback before this view's parent is going to change.
	 */
	void willChangeParent_(View newParent) {}

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
			child.willChangeParent_(this);
		if (oldParent !== null)
			oldParent._removeChild(child, false); //not to notify child

		_link(this, child, beforeChild);
		child._parent = this;
		++_childInfo.nChild;

		_addToIdSpaceDown(child, null);
		if (isInDocument())
			insertChildHTML_(child, beforeChild);

		didAddChild_(child);
		if (parentChanged)
			child.didChangeParent_(oldParent);
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

		willRemoveChild_(child);
		if (notifyChild)
			child.willChangeParent_(null);

		removeChildHTML_(child);

		_unlink(this, child);
		child._parent = null;
		--_childInfo.nChild;
		if (notifyChild)
			child.didChangeParent_(this);
		return true;
	}

	/** Inserts the HTML content generated by the specified child view before the reference view (beforeChild).
	 * It is called by {@link #insertBefore} and {@link #appendChild} to handle the document.
	 * <p>Deriving classes might override this method to modify the HTML content, such as enclosing with TD.
	 */
	void insertChildHTML_(View child, View beforeChild) {
		String html = child._redrawHTML(null);
		Element before, cave;
		if (beforeChild != null)
			before = beforeChild._firstNode();

		if (before === null)
			for (View w = this;;) {
				cave = w.caveNode;
				if (cave != null) break;

				var w2 = w.nextSibling;
				if (w2 != null && (before = w2._firstNode()) != null)
					break;

				if ((w = w.parent) === null) {
					cave = document.body;
					break;
				}
			}

		if (before != null) {
			Element sib = before.previousElementSibling;
			if (_isPrefixOfHTML(sib)) before = sib;
			before.insertAdjacentHTML("beforeBegin", html);
		} else {
			cave.insertAdjacentHTML("beforeEnd", html);
		}

		child._enterDocument(null);
	}
	static bool _isPrefixOfHTML(Element el) {
		String txt;
		var node = el;
		return node != null && node is Text //textnode
			&& (txt=node.wholeText) != null && txt.trim().isEmpty();
	}
	/** Returns the first DOM element of this view.
	 * If this view has no corresponding DOM element, this method will look
	 * for its siblings.
	 */
	Element _firstNode() {
		for (View view = this; view != null; view = view.nextSibling) {
			Element n = view.node;
			if (n != null)
				return n;

			for (View w = view.firstChild; w != null; w = w.nextSibling) {
				n = w._firstNode();
				if (n != null)
					return n;
			}
		}
	}
	/** Removes the corresponding DOM content of the specified child.
	 * It is called by [removeChild] to remove the DOM content.
	 */
	void removeChildHTML_(View child) {
		List<Element> ns;
		Element n = child.node;
		if (n != null) {
			var sib = n.previousElementSibling;
			if (!child.prefixOfHTML.isEmpty() && _isPrefixOfHTML(sib))
				sib.remove();
			ns = [n];
		} else
			_prepareRemove(child, ns = []);

		child._exitDocument(null);

		for (n in ns)
			n.remove();
	}

	static void _prepareRemove(View view, List<Element> nodes) {
		for (view = view.firstChild; view != null; view = view.nextSibling) {
			var n = view.node;
			if (n) nodes.add(n);
			else _prepareRemove(view, nodes);
		}
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

	/** Returns the prefix of the HTML fragment generated by [redraw].
	 */
	String get prefixOfHTML() => _prefixOfHTML;
	/** Sets the prefix of the HTML fragment generated by [redraw].
	 * <p>Default: empty (i.e., none).
	 * <p>It is usually used to put extra space among views.
	 */
	void set prefixOfHTML(String prefixText) {
		_prefixOfHTML = prefixText != null ? prefixText: ""; 
	}
	/** Returns the DOM element associated with this view.
	 * This method returns null if this view is not bound the DOM,
	 * or it doesn't have the associate element.
	 * <p>To retrieve a child element, use the [getNode] method instead.
	 */
	Element get node() => _inDoc ? document.query('#' + uuid): null;
	/** Returns the element that is used to place the child elements.
	 * <p>Default: <code>getNode("cave") || node</code>.
	 */
	Element get caveNode() {
		Element n = getNode("cave");
		return n != null ? n: node;
	}
			//no need to cache since IE6 not supported
	/** Returns the child element of the given sub-ID.
	 * This method assumes the ID of the child element the concatenation of
	 * uuid, dash ('-'), and subId.
	 */
	Element getNode(String subId) =>
		_inDoc ? document.query(subId != null && subId.length > 0 ?
					 '#' + uuid + '-' + subId: '#' + uuid): null;
	/** Returns if this view has been added to the document.
	 */
	bool isInDocument() => _inDoc;

	/** Replaces the given DOM element with
	 * the HTML fragment generated by this view (with [redraw]).
	 * <p>This method can be called only if this view has no parent.
	 * If a view has a parent, it is attached to the document when its parent is
	 * attached. And, it is detached when its parent is detached from the document.
	 */
	void addToDocument(Element node,
	[bool outer=false, bool inner=false, Element before]) {
		String html = _redrawHTML(null);
		Element p, nxt;
		if (inner) {
			node.innerHTML = html;
			//done (and no need to assign p and nxt)
		} else {
			p = node.parent;
			if (outer) {
				nxt = node.nextElementSibling;
				node.remove();
			} else {
				nxt = before;
			}
		}

		if (nxt != null)
			nxt.insertAdjacentHTML("beforeBegin", html);
		else if (p != null)
			p.insertAdjacentHTML("beforeEnd", html);

		_enterDocument(null);
	}
	/** Removes the view from the document.
	 * All of descendant views are removed too.
	 * <p>This method can be called only if this view has no parent.
	 * Otherwise, just remove it from its parent by use of [removeChild].
	 */
	void removeFromDocument() {
		_exitDocument(null);
		node.remove();
	}
	/** Binds the view.
	 */
	void _enterDocument(Skipper skipper) {
		List<AfterEnterDocument> afters = [];

		enterDocument_(skipper, afters);

		for (final AfterEnterDocument call in afters)
			call(this);
	}
	/** Unbinds the view.
	 */
	void _exitDocument(Skipper skipper) {
		exitDocument_(skipper);
	}
	/** Callback when this view is attached to the document.
	 * <p>Default: invoke [enterDocument_] for each child.
	 * <p>Subclass shall call back this method if it overrides this method. 
	 * <p>See also [isInDocument] and [rerender].
	 */
	void enterDocument_(Skipper skipper, List<AfterEnterDocument> afters) {
		_inDoc = true;

		//Listen the DOM element if necessary
		Element n;
		if (_evlInfo !== null && _evlInfo.listeners !== null) {
			final Map<String, List<EventListener>> listeners = _evlInfo.listeners;
			for (final String type in listeners.getKeys()) {
				final DomEventDispatcher disp = getDomEventDispatcher_(type);
				if (disp != null && !listeners[type].isEmpty()) {
					if (n === null) {
						n = node;
						if (n === null)
							break; //nothing to do
					}
					domListen_(n, type, disp);
				}
			}
		}

		for (View child = firstChild; child != null; child = child.nextSibling)
			if (skipper === null || !skipper.isSkipped(this, child))
				child.enterDocument_(null, afters);
	}
	/** Callback when this view is detached from the document.
	 * <p>Default: invoke [exitDocument_] for each child.
	 * <p>Subclass shall call back this method if it overrides this method. 
	 */
	void exitDocument_(Skipper skipper) {
		_inDoc = false;

		//Unlisten the DOM element if necessary
		Element n;
		if (_evlInfo !== null && _evlInfo.listeners !== null) {
			final Map<String, List<EventListener>> listeners = _evlInfo.listeners;
			for (final String type in listeners.getKeys()) {
				if (getDomEventDispatcher_(type) != null && !listeners[type].isEmpty()) {
					if (n === null) {
						n = node;
						if (n === null)
							break; //nothing to do
					}
				}
				domUnlisten_(n, type);
			}
		}

		for (View child = firstChild; child != null; child = child.nextSibling)
			if (skipper === null || !skipper.isSkipped(this, child))
				child.exitDocument_(null);
	}

	/** Rerenders the DOM elements for this view and its descendants,
	 * and refreshes the document accordingly.
	 * It has no effect if it is not attached (i.e., [isInDocument] is true).
	 * <p>Notice that, for better performance, DOM elements won't be rendered
	 * immediately. If you'd like to render immediately, you have to specify
	 * <code>timeout: -1</code>.
	 */
	void rerender([int timeout=0, Skipper skipper]) {
		if (timeout >= 0) {
			View self = this;
			runOnce("rerender", () {
				self.rerender(timeout: -1, skipper: skipper);
			});
			return;
		}

		Element n = node;
		if (n != null) {
			if (skipper != null) {
				//TODO
			}

			_exitDocument(skipper);
			addToDocument(n, outer: true);
		}
	}
	/** Generates the HTML fragment for this view and its descendants.
	 * <p>The default implementation: invoke [redraw_].
	 * <p>Override this method if the view supports [Skipper].
	 * Otherwise, override [redraw_] instead.
	 */
	void redraw(StringBuffer out, [Skipper skipper=null]) {
		redraw_(out, skipper);
	}
	/**Shortcut of [redraw].*/
	String _redrawHTML(Skipper skipper) {
		StringBuffer out = new StringBuffer();
		redraw(out, skipper);
		return out.toString();
	}
	/** Generates the HTML fragment for this view and its descendants without
	 * the support of [Skipper].
	 * <p>Override this method rather than [redraw] if the view doesn't support
	 * the concept of [Skipper].
	 */
	void redraw_(StringBuffer out, Skipper skipper) {
		out.add('<div').add(domAttrs_()).add('>');
		for (View child = firstChild; child !== null; child = child.nextSibling)
			child.redraw(out); //don't pass skipper to child
		out.add('</div>');
	}

	/** Returns if this view is hidden.
	 */
	bool get hidden() => _hidden;
	/** Sets if this view is hidden.
	 */
	void set hidden(bool hidden) {
		_hidden = hidden;
		if ((_cssInfo !== null && _cssInfo.style !== null) || hidden)
			style.display = hidden ? "none": "";
		Element n = node;
		if (n !== null)
			n.hidden = hidden;
	}
	/** Retuns the CSS style.
	 */
	CSSStyleDeclaration get style() {
		final _CSSInfo ci = _initCSSInfo();
		if (ci.style === null)
			ci.style =  LevelDom.wrapCSSStyleDeclaration(newCSSStyleWrapper_());
		return ci.style;
	}

	/** Retuns the view class.
	 */
	String get wclass() => _wclass;
	/** Sets the view class.
	 * <p>Default: empty, but an implementation usually provides a default
	 * class, such as <code>v-label</code>. It is used to provide
	 * the default look for this view. If wclass is changed, all the default
	 * styles are gone.
	 */
	void set wclass(String newwc) {
		final String oldwc = _wclass;
		if (oldwc == newwc)
			return; //nothing to do

		_wclass = newwc;

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
		final _CSSInfo ci = _initCSSInfo();
		if (ci.classes === null)
			ci.classes = new Set();
		return ci.classes;
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
		if (_cssInfo != null) {
			_cssInfo.classes.remove(className);
			Element n = node;
			if (n != null)
				n.classes.remove(className);
		}
	}

	/** Ouptuts all attributes used for the DOM element of this view.
	 */
	String domAttrs_([bool noId=false, bool noStyle=false, bool noClass=false]) {
		final StringBuffer sb = new StringBuffer();
		String s;
		if (!noId && !(s = uuid).isEmpty())
			sb.add(' id="').add(s).add('"');
		if (!noStyle && _cssInfo !== null && _cssInfo.style !== null
		&& !(s = _cssInfo.style.cssText).isEmpty())
			sb.add(' style="').add(s).add('"');
		if (!noClass && !(s = domClass_()).isEmpty())
			sb.add(' class="').add(s).add('"');
		return sb.toString();
	}

	/** Outputs the class used for the DOM element of this view.
	 */
	String domClass_([bool noWclass=false, bool noClass=false]) {
		if (_cssInfo === null)
			return "";

		final StringBuffer sb = new StringBuffer();
		if (!noWclass)
			sb.add(wclass);
		if (!noClass && _cssInfo.classes != null)
			for (final String cls in _cssInfo.classes) {
				if (!sb.isEmpty()) sb.add(' ');
				sb.add(cls);
			}
		return sb.toString();
	}

	/** Returns [Events] for adding or removing event listeners.
	 */
	Events get on() {
		final _EventListenerInfo ei = _initEventListenerInfo();
		if (ei.on === null)
			ei.on = new _EventsImpl(this);
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
	/** Dispatches an event.
	 */
	bool dispatchEvent(String type, ViewEvent event) {
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
					target.dispatchEvent(type,
						new ViewEvent<Object>(target, domEvent: event, type: type));
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

	/** Schedules a run-once task.
	 * It is used to schedule a long-execution task that has the same effect
	 * no matter how many times it is executed. For example, [rerender].
	 * <p>If tasks are run with the same against the same view, they are
	 * considered as the same task, and [runOnce] will execute only one of
	 * them (the one with the longest timeout).
	 */
	void runOnce(String key, RunOnceTask task, [timeout=0]) {
		if (_runOnceQue == null)
			_runOnceQue = new RunOnceQueue();
		_runOnceQue.add(uuid + key, task, timeout: timeout);
	}
	static RunOnceQueue _runOnceQue;

	int hashCode() {
		return uuid.hashCode(); //uuid is immutiable once assigned
	}
}

class _ChildInfo {
	View firstChild, lastChild;
	int nChild = 0;
	List children;
}
class _CSSInfo {
	//the classes; created on demand
	Set<String> classes;
	//the CSS style; created on demand
	CSSStyleDeclaration style;
}
class _EventListenerInfo {
	Events on;
	//the registered event listeners; created on demand
	Map<String, List<EventListener>> listeners;
	//generic DOM event listener
	Map<String, EventListener> domListeners;
}