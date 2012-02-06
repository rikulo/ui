/* Widget.dart

	History:
		Mon Jan	9 13:01:36 TST 2012, Created by tomyeh

Copyright (C) 2012 Potix Corporation. All Rights Reserved.
*/

/** Called after all [Widget.enterDocument_] methods are called, where
 * [topWidget] is the topmost widget that the binding starts with.
 */ 
typedef void AfterEnterDocument(Widget topWidget);
/** Returns a DOM-level event listener that converts a DOM event to a widget event
 * ([WidgetEvent]) and dispatch to the right target.
 */
typedef EventListener DomEventDispatcher(Widget target);

/**
 * A widget.
 */
class Widget implements EventTarget {
	String _id = "";
	String _uuid;

	String _wclass = "";
	//the classes; created on demand
	Set<String> _classes;
	//the CSS style; created on demand
	CSSStyleDeclaration _style;

	Events _on;
	//the registered event listeners; created on demand
	Map<String, List<EventListener>> _listeners;
	//generic DOM event listener
	Map<String, EventListener> _domListeners;

	Widget _parent;
	Widget _firstChild, _lastChild;
	Widget _nextSibling, _prevSibling;
	int _nChild = 0;
	//The fellows. Used only if this is IdSpace
	Map<String, Widget> _fellows;
	//Virtual ID space. Used only if this is root but not IdSpace
	IdSpace _virtIS;

	String _prefixOfHTML = "";
	bool _hidden, _inDoc;

	Widget() {
		if (this is IdSpace)
			_fellows = {};
	}
	/** Applies the properties to the filds of this widget.
	 */
	Widget apply(Map<String, Object> props) {
		//TODO (reflection required)
	}

	/** Instantiates the wrapper to handle [CSSStyleDeclaration].
	 * <p>Default: create an instance of [CSSStyleWrapper].
	 * If a deriving class has to override the default behavior, it could
	 * extend [CSSStyleWrapper] to override the corresponding method, and
	 * then return an instance of the subclass.
	 */
	CSSStyleWrapper newCSSStyleWrapper_() => new CSSStyleWrapper(this);

	/** Returns the UUID of this component, never null.
	 */
	String get uuid() {
		if (_uuid == null)
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

	/** Returns the ID of this widget, or an empty string if not assigned.
	 */
	String get id() {
		return _id;
	}
	/** Sets the ID of this widget.
	 */
	void set id(String id) {
		if (id == null) id = "";
		if (_id != id) {
			if (id.length > 0)
				_checkIdSpaces(this, id);
			_removeFromIdSpaces(this);
			_id = id;
			_addToIdSpace(this);
		}
	}
	/** Searches and returns the first widget that matches the given selector.
	 */
	Widget query(String selector) {
		//TODO
	}
	/** Searches and returns all widgets that matches the selector.
	 */
	List<Widget> queryAll(String selector) {
		//TODO
	}
	/** Returns the widget of the given ID, or null if not found.
	 */
	Widget getFellow(String id) {
		var owner = spaceOwner;
		return owner._fellows[id];
	}
	/** Returns the owner of the ID space that this widget belongs to.
	 * <p>A virtual [IdSpace] is used if this widget is a root but is not IdSpace.
	 */
	IdSpace get spaceOwner() => _spaceOwner(this, false); //not to ignore virtual

	static IdSpace _spaceOwner(Widget wgt, bool ignoreVirtualIS) {
		Widget top;
		var p = wgt;
		do {
			if (p is IdSpace)
				return p;
			top = p;
		} while ((p = p.parent) != null);

		if (!ignoreVirtualIS) {
			if (top._virtIS == null)
				top._virtIS = new _VirtualIdSpace(top);
			return top._virtIS;
		}
	}
	/** Checks the uniqueness in ID space when changing ID. */
	static void _checkIdSpaces(Widget wgt, String newId) {
		var space = wgt.spaceOwner;
		if (space._fellows.containsKey(newId))
			throw new UiException("Not unique in the ID space of $space: $newId");

		//we have to check one level up if wgt is IdSpace (i.e., unique in two ID spaces)
		Widget parent;
		if (wgt is IdSpace && (parent = wgt.parent) != null) {
			space = parent.spaceOwner;
			if (space._fellows.containsKey(newId))
				throw new UiException("Not unique in the ID space of $space: $newId");
		}
	}
	//Add the given widget to the ID space
	static void _addToIdSpace(Widget wgt){
		String id = wgt.id;
		if (id.length == 0)
			return;

		var space = wgt.spaceOwner;
		space._fellows[id] = wgt;

		//we have to put it one level up if wgt is IdSpace (i.e., unique in two ID spaces)
		Widget parent;
		if (wgt is IdSpace && (parent = wgt.parent) != null) {
			space = parent.spaceOwner;
			space._fellows[id] = wgt;
		}
	}
	//Add the given widget and all its children to the ID space
	static void _addToIdSpaceDown(Widget wgt, var space) {
		if (wgt is IdSpace) {
			if (space == null) //the top invocation made by insertBefore called
				_addToIdSpace(wgt);
			return; //done
		}

		if (space == null)
			space = wgt.spaceOwner;

		var id = wgt.id;
		if (id.length > 0)
			space._fellows[id] = wgt;

		for	(wgt = wgt.firstChild; wgt != null; wgt = wgt.nextSibling)
			_addToIdSpaceDown(wgt, space);
	}
	static void _removeFromIdSpaces(Widget wgt) {
		String id = wgt.id;
		if (id.length == 0)
			return;

		var space = wgt.spaceOwner;
		space._fellows.remove(id);

		//we have to put it one level up if wgt is IdSpace (i.e., unique in two ID spaces)
		Widget parent;
		if (wgt is IdSpace && (parent = wgt.parent) != null) {
			space = parent.spaceOwner;
			space._fellows.remove(id);
		}
	}

	/** Returns the parent, or null if this widget does not have any parent.
	 */
	Widget get parent() => _parent;
	/** Returns the first child, or null if this widget has no child at all.
	 */
	Widget get firstChild() => _firstChild;
	/** Returns the last child, or null if this widget has no child at all.
	 */
	Widget get lastChild() => _lastChild;
	/** Returns the next sibling, or null if this widget is the last sibling.
	 */
	Widget get nextSibling() => _nextSibling;
	/** Returns the previous sibling, or null if this widget is the previous sibling.
	 */
	Widget get previousSibling() => _prevSibling;

	/** Callback when a child has been added.
	 * <p>Default: does nothing.
	 */
	void onChildAdd_(Widget child) {}
	/** Callback when a child has been removed.
	 * <p>Default: does nothing.
	 */
	void onChildRemove_(Widget child) {}

	/** Appends a child to the end of all children.
	 * It calls [insertBefore] with beforeChild to be null, so the 
	 * subclass needs to override [insertBefore] if necessary.
	 */
	Widget appendChild(Widget child) => insertBefore(child, null);
	/** Inserts a child before the reference child.
	 * If the given widget is always a child, its position among children
	 * will be changed depending on [beforeChild].
	 * <p>Notice that [appendChild] will call back this methid, so the subclass
	 * need only to override this method, if necessary.
	 */
	Widget insertBefore(Widget child, Widget beforeChild) {
		for (Widget p = this; p != null; p = p.parent)
			if (p === child)
				throw new UiException("$child is an ancestor of $this");
		if (beforeChild != null && beforeChild.parent !== this)
			beforeChild = null;

		if (child.parent === this) {
			if (child.nextSibling !== beforeChild) { //move?
				_unlink(this, child);
				_link(this, child, beforeChild);
			}
			return this; //done
		}

		_link(this, child, beforeChild);
		child._parent = this;
		++_nChild;

		_addToIdSpaceDown(child, null);
		if (isInDocument())
			insertChildHTML_(child, beforeChild);

		onChildAdd_(child);
		return this;
	}
	/** Removes a child.
	 * It returns true if the child is removed succefully, or false if it is
	 * a child.
	 */
	bool removeChild(Widget child) {
		if (child.parent !== this)
			return false;

		removeChildHTML_(child);

		_unlink(this, child);
		child._parent = null;
		--_nChild;

		onChildRemove_(child);
		return true;
	}

	/** Inserts the HTML content generated by the specified child widget before the reference widget (beforeChild).
	 * It is called by {@link #insertBefore} and {@link #appendChild} to handle the document.
	 * <p>Deriving classes might override this method to modify the HTML content, such as enclosing with TD.
	 */
	void insertChildHTML_(Widget child, Widget beforeChild) {
		String html = child._redrawHTML(null);
		Element before, cave;
		if (beforeChild != null)
			before = beforeChild._firstNode();

		if (before == null)
			for (Widget w = this;;) {
				cave = w.caveNode;
				if (cave != null) break;

				var w2 = w.nextSibling;
				if (w2 != null && (before = w2._firstNode()) != null)
					break;

				if ((w = w.parent) == null) {
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
		return el != null && el.nodeType == 3 //textnode
			&& (txt=el.nodeValue) != null && txt.trim().isEmpty();
	}
	/** Returns the first DOM element of this widget.
	 * If this widget has no corresponding DOM element, this method will look
	 * for its siblings.
	 */
	Element _firstNode() {
		for (Widget wgt = this; wgt != null; wgt = wgt.nextSibling) {
			Element n = wgt.node;
			if (n != null)
				return n;

			for (Widget w = wgt.firstChild; w != null; w = w.nextSibling) {
				n = w._firstNode();
				if (n != null)
					return n;
			}
		}
	}
	/** Removes the corresponding DOM content of the specified child.
	 * It is called by [removeChild] to remove the DOM content.
	 */
	void removeChildHTML_(Widget child) {
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

	static void _prepareRemove(Widget wgt, List<Element> nodes) {
		for (wgt = wgt.firstChild; wgt != null; wgt = wgt.nextSibling) {
			var n = wgt.node;
			if (n) nodes.add(n);
			else _prepareRemove(wgt, nodes);
		}
	}

	static void _link(Widget wgt, Widget child, Widget beforeChild) {
		if (beforeChild == null) {
			Widget p = wgt._lastChild;
			if (p != null) {
				p._nextSibling = child;
				child._prevSibling = p;
				wgt._lastChild = child;
			} else {
				wgt._firstChild = wgt._lastChild = child;
			}
		} else {
			Widget p = beforeChild._prevSibling;
			if (p != null) {
				child._prevSibling = p;
				p._nextSibling = child;
			} else {
				wgt._firstChild = child;
			}

			beforeChild._prevSibling = child;
			child._nextSibling = beforeChild;
		}
	}
	static void _unlink(Widget wgt, Widget child) {
		var p = child._prevSibling, n = child._nextSibling;
		if (p != null) p._nextSibling = n;
		else wgt._firstChild = n;
		if (n != null) n._prevSibling = p;
		else wgt._lastChild = p;
		child._nextSibling = child._prevSibling = child._parent = null;
	}

	/** Returns the prefix of the HTML fragment generated by [redraw].
	 */
	String get prefixOfHTML() => _prefixOfHTML;
	/** Sets the prefix of the HTML fragment generated by [redraw].
	 * <p>Default: empty (i.e., none).
	 * <p>It is usually used to put extra space among widgets.
	 */
	void set prefixOfHTML(String prefixText) {
	  _prefixOfHTML = prefixText != null ? prefixText: ""; 
	}
	/** Returns the DOM element associated with this widget.
	 * This method returns null if this widget is not bound the DOM,
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
	/** Returns if this widget has been added to the document.
	 */
	bool isInDocument() => _inDoc;

	/** Replaces the given DOM element with
	 * the HTML fragment generated by this widget (with [redraw]).
	 * <p>This method can be called only if this widget has no parent.
	 * If a widget has a parent, it is attached to the document when its parent is
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
	/** Removes the widget from the document.
	 * All of descendant widgets are removed too.
	 * <p>This method can be called only if this widget has no parent.
	 * Otherwise, just remove it from its parent by use of [removeChild].
	 */
	void removeFromDocument() {
		_exitDocument(null);
		node.remove();
	}
	/** Binds the widget.
	 */
	void _enterDocument(Skipper skipper) {
		List<AfterEnterDocument> afters = [];

		enterDocument_(skipper, afters);

		for (final AfterEnterDocument call in afters)
			call(this);
	}
	/** Unbinds the widget.
	 */
	void _exitDocument(Skipper skipper) {
		exitDocument_(skipper);
	}
	/** Callback when this widget is attached to the document.
	 * <p>Default: invoke [enterDocument_] for each child.
	 * <p>Subclass shall call back this method if it overrides this method. 
	 * <p>See also [isInDocument] and [rerender].
	 */
	void enterDocument_(Skipper skipper, List<AfterEnterDocument> afters) {
		_inDoc = true;

		//Listen the DOM element if necessary
		Element n;
		if (_listeners != null)
			for (final String type in _listeners.getKeys()) {
				final DomEventDispatcher disp = getDomEventDispatcher_(type);
				if (disp != null && !_listeners[type].isEmpty()) {
					if (n == null) {
						n = node;
						if (n == null)
							break; //nothing to do
					}
					domListen_(n, type, disp);
				}
			}

		for (Widget child = firstChild; child != null; child = child.nextSibling)
			if (skipper == null || !skipper.isSkipped(this, child))
				child.enterDocument_(null, afters);
	}
	/** Callback when this widget is detached from the document.
	 * <p>Default: invoke [exitDocument_] for each child.
	 * <p>Subclass shall call back this method if it overrides this method. 
	 */
	void exitDocument_(Skipper skipper) {
		_inDoc = false;

		//Unlisten the DOM element if necessary
		Element n;
		if (_listeners != null)
			for (final String type in _listeners.getKeys()) {
				if (getDomEventDispatcher_(type) != null && !_listeners[type].isEmpty()) {
					if (n == null) {
						n = node;
						if (n == null)
							break; //nothing to do
					}
				}
				domUnlisten_(n, type);
			}

		for (Widget child = firstChild; child != null; child = child.nextSibling)
			if (skipper == null || !skipper.isSkipped(this, child))
				child.exitDocument_(null);
	}

	/** Rerenders the DOM elements for this widget and its descendants,
	 * and refreshes the document accordingly.
	 * It has no effect if it is not attached (i.e., [isInDocument] is true).
	 * <p>Notice that, for better performance, DOM elements won't be rendered
	 * immediately. If you'd like to render immediately, you have to specify
	 * <code>timeout: -1</code>.
	 */
	void rerender([int timeout=0, Skipper skipper]) {
		if (timeout >= 0) {
			Widget self = this;
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
	/** Generates the HTML fragment for this widget and its descendants.
	 * <p>The default implementation: invoke [redraw_].
	 * <p>Override this method if the widget supports [Skipper].
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
	/** Generates the HTML fragment for this widget and its descendants without
	 * the support of [Skipper].
	 * <p>Override this method rather than [redraw] if the widget doesn't support
	 * the concept of [Skipper].
	 */
	void redraw_(StringBuffer out, Skipper skipper) {
		for (Widget child = firstChild; child != null; child = child.nextSibling)
			child.redraw(out); //don't pass skipper to child
	}

	/** Returns if this widget is hidden.
	 */
	bool get hidden() => _hidden;
	/** Sets if this widget is hidden.
	 */
	void set hidden(bool hidden) {
		_hidden = hidden;
		if (_style != null || hidden)
			style.display = hidden ? "none": "";
	}
	/** Retuns the CSS style.
	 */
	CSSStyleDeclaration get style() {
		if (_style == null)
			_style = LevelDom.wrapCSSStyleDeclaration(newCSSStyleWrapper_());
		return _style;
	}

	/** Retuns the widget class.
	 */
	String get wclass() => _wclass;
	/** Sets the widget class.
	 * <p>Default: empty, but an implementation usually provides a default
	 * class, such as <code>w-label</code>. It is used to provide
	 * the default look for this widget. If wclass is changed, all the default
	 * styles are gone.
	 */
	void set wclass(String wclass) {
		_wclass = wclass != null ? wclass: "";
		Element n = node;
		if (n != null) {
			Set<String> clses = new Set();
			if (!_wclass.isEmpty())
				clses.add(_wclass);
			if (_classes != null)
				clses.addAll(_classes);
			n.classes = clses; 
		}
	}
	/** Returns a readonly list of the additional style classes.
	 */
	Set<String> get classes() {
		if (_classes == null)
			_classes = new Set();
		return _classes;
	}
	/** Adds the give style class.
	 */
	void addClass(String className) {
		classes.add(className);
		Element n = node;
		if (n != null) n.classes.add(className);
	}
	/** Removes the give style class.
	 */
	void removeClass(String className) {
		classes.remove(className);
		Element n = node;
		if (n != null) n.classes.remove(className);
	}

	/** Ouptuts all attributes used for the DOM element of this widget.
	 */
	String domAttrs_([bool noId=false, bool noStyle=false, bool noClass=false]) {
		final StringBuffer sb = new StringBuffer();
		String s;
		if (!noId && !(s = uuid).isEmpty())
			sb.add(' id="').add(s).add('"');
		if (!noStyle && _style != null && !(s = _style.cssText).isEmpty())
			sb.add(' style="').add(s).add('"');
		if (!noClass && !(s = domClass_()).isEmpty())
			sb.add(' class="').add(s).add('"');
		return sb.toString();
	}

	/** Outputs the class used for the DOM element of this widget.
	 */
	String domClass_([bool noWclass=false, bool noClass=false]) {
		final StringBuffer sb = new StringBuffer();
		if (!noWclass)
			sb.add(_wclass);
		if (!noClass && _classes != null)
			for (final String cls in _classes) {
				if (!sb.isEmpty()) sb.add(' ');
				sb.add(cls);
			}
		return sb.toString();
	}

	/** Returns [Events] for adding or removing event listeners.
	 */
	Events get on() {
		if (_on === null)
			_on = new _EventsImpl(this);
		return _on;

	}
	/** Adds an event listener.
	 * <code>addEventListener("click", listener)</code> is the same as
	 * <code>on.click.add(listener)</code>.
	 */
	Widget addEventListener(String type, EventListener listener, [bool useCapture = false]) {
		if (listener == null)
			throw new UiException("listener required");

		if (_listeners == null)
			_listeners = {};

		bool first;
		_listeners.putIfAbsent(type, () {
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
	Widget removeEventListener(String type, EventListener listener, [bool useCapture = false]) {
		List<EventListener> ls;
		if (_listeners != null && (ls = _listeners[type]) != null) {
			int j = ls.indexOf(listener);
			Element n;
			if (j >= 0)				ls.removeRange(j, 1);
			if (ls.isEmpty() && (n = node) != null
			&& getDomEventDispatcher_(type) != null)
				domUnlisten_(n, type);
		}
		return this;
	}
	/** Dispatches an event.
	 */
	bool dispatchEvent(String type, WidgetEvent event) {
		List<EventListener> ls;
		bool dispatched = false;
		if (_listeners != null && (ls = _listeners[type]) != null) {
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
		return _listeners != null && (ls = _listeners[type]) != null && !ls.isEmpty();
	}
	/** Returns if the given event type is a DOM event.
	 * If true, [domListen_] will be invoked to register the DOM event.
	 */
	DomEventDispatcher getDomEventDispatcher_(String type) {
		if (_domEvtDisps == null) {
			_domEvtDisps = {};
			
			//TODO: handle event better, and handle more DOM events
			//example: click shall carry mouse position, change shall carry value
			DomEventDispatcher disp = (Widget target) {
				return (Event event) {
					target.dispatchEvent(type,
						new WidgetEvent<Object>(target, domEvent: event, type: type));
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
		final EventListener ln = disp(this);
		if (_domListeners == null)
			_domListeners = {};
		_domListeners[type] = ln;
		n.on[type].add(ln);
	}
	/** Unlisten the given event type.
	 */
	void domUnlisten_(Element n, String	type) {
		final EventListener ln = _domListeners.remove(type);
		if (ln != null)
			n.on[type].remove(ln);
	}

	/** Schedules a run-once task.
	 * It is used to schedule a long-execution task that has the same effect
	 * no matter how many times it is executed. For example, [rerender].
	 * <p>If tasks are run with the same against the same widget, they are
	 * considered as the same task, and [runOnce] will execute only one of
	 * them (the one with the longest timeout).
	 */
	void runOnce(String key, RunOnceTask task, [timeout=0]) {
		if (_runOnceQue == null)
			_runOnceQue = new RunOnceQueue();
		_runOnceQue.add(uuid + key, task, timeout: timeout);
	}
	static RunOnceQueue _runOnceQue;
}
