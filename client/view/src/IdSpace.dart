//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012

/**
 * An ID space.
 */
interface IdSpace {
  /** Searches and returns the first view that matches the given selector,
   * or null if not found.
   */
  View query(String selector);
  /** Searches and returns all views that matches the selector (never null).
   */
  List<View> queryAll(String selector);
  /** Returns the view of the given ID, or null if not found.
   */
  View getFellow(String id);
  /** Returns a readoly collection of all fellows in this ID space.
   *
   * Note: don't modify the returned list. Otherwise, the result is
   * unpreditable.
   */
  Collection<View> get fellows();
}
