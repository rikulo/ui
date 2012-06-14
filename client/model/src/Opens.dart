//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jun 14, 2012  9:43:29 AM
// Author: tomyeh

/**
 * Indicates a model that allows to open some of the objects.
 * It is a supplymental interface used with other models, such as [TreeModel].
 */
interface Opens<E> {
  /**
   * Returns the current list of nodes that are opened.
   * It is readonly. Don't modify it directly. Otherwise, UI won't be
   * updated correctly.
   */
  Set<E> get opens();
  /**
   * Replace the current list of node that are opened with the given set.
   *
   * Notice this method copies the content of [opens], so it is OK
   * to use it after the invocation.
   */
  void set opens(Collection<E> opens);

  /** Returns true if the node shall be opened.
   * That is, it tests if the given node is in the list of opened nodes.
   */
  bool isOpened(E node);
  /** Returns true if the list of opened nodes is empty.
   */
  bool isOpensEmpty();

  /** Adds the given node to the list of opened nodes.
   */
  bool addToOpens(E node);
  /** Removes the given node from the list of opened nodes.
   */
  bool removeFromOpens(E node);
  /** Empties the list of opened nodes.
   */
  void clearOpens();
}
