//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 25, 2012  3:37:13 PM
// Author: tomyeh

/** Called after all [View.enterDocument_] methods are called, where
 * [topView] is the topmost view that the binding starts with.
 */ 
typedef void AfterEnterDocument(View topView);
/** Returns a DOM-level event listener that converts a DOM event to a view event
 * ([ViewEvent]) and dispatch to the right target.
 */
typedef EventListener DOMEventDispatcher(View target);
