//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 13, 2012  7:15:05 PM
// Author: tomyeh

/**
 * Indicates a model that allows to disable some of the objects.
 * It is a supplymental interface used with other models, such as [ListModel].
 */
interface Disables<T> {
  /**
   * Returns the current list of disabled objects.
   * It is readonly. Don't modify it directly. Otherwise, UI won't be
   * updated correctly.
   */
  Set<T> get disables;
  /**
   * Replace the current list of disabled objects with the given set.
   *
   * Notice this method copies the content of [disables], so it is OK
   * to use it after the invocation.
   */
  void set disables(Collection<T> disables);

  /** Returns whether an object is disabled.
   */
  bool isDisabled(Object obj);
  /**
   * Returns true if the list of the disabled objects is currently empty.
   */
  bool isDisablesEmpty();

  /**
   * Add the specified object into the current list of disabled objects.
   * It returns whether it has been added successfully.
   * Returns false if it is already disabled.
   */
  bool addToDisables(T obj);
  /**
   * Remove the specified object from the current list of disabled objects.
   * It returns whether it is removed successfully.
   * Returns false if it is not disabled.
   */
  bool removeFromDisables(Object obj);
  /**
   * Change the current list of disabled objects to the empty set.
   */
  void clearDisables();
}
