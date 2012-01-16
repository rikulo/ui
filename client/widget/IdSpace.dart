//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012
#library("dargate:widget:IdSpace");

#import("Widget.dart");

/**
 * An ID space.
 */
interface IdSpace {
  /** Searches and returns the first widget that matches the given selector,
   * or null if not found.
   */
  Widget query(String selector);
  /** Searches and returns all widgets that matches the selector (never null).
   */
  List<Widget> queryAll(String selector);
  /** Returns the widget of the given ID, or null if not found.
   */
  Widget getFellow(String id);
}
