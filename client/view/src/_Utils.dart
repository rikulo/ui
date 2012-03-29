//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Mar 13, 2012  2:14:29 PM
// Author: tomyeh


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
	Events on;
	//the registered event listeners; created on demand
	Map<String, List<EventListener>> listeners;
	//generic DOM event listener
	Map<String, EventListener> domListeners;
}

/** The invalidator that handles the invalidated views
 * used in [View].
 */
class _Invalidator extends RunOnceViewManager {

	_Invalidator(): super(true) {
	}

	void handle_(View view) {
		final Element n = view.node;
		if (n != null) {
			view._exitDocument();
			view.addToDocument(n, outer: true);
		}
	}
}

_Invalidator get _invalidator() {
	if (_cachedInvalidator == null)
		_cachedInvalidator = new _Invalidator();
	return _cachedInvalidator;
}
_Invalidator _cachedInvalidator;
