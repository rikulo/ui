//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  6:16:53 PM
// Author: tomyeh

/**
 * A collection of [View] utitiles.
 */
class ViewUtil {
	/** Redraws the invalidated views queued by [View.invalidate].
	 * <p>Notice that it is static, i.e., all queued invalidation will be redrawn.
	 */
	static void flushInvalidated() {
		_invalidator.flush();
	}
	/** Handles the layouts of views queued by [View.requestLayout].
	 * <p>Notice that it is static, i.e., all queued requests will be handled.
	 */
	static void flushRequestedLayouts() {
		layoutManager.flush();
	}

	/** Returns the view of the given UUID.
	 * <p>Notice that, if a view is not attached to the document, it won't
	 * be returned
	 * (i.e., it is considered as not found and <code>null</code> is returned).
	 */
//	static View getView(String uuid) => _views[uuid];
//	static Map<String, View> _views = new Map();
//Note supported because the memory overhead to maintain _views
}
