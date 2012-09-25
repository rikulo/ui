//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu Feb 16 15:22:36 TST 2012
// Author: tomyeh

/**
 * Indicates a model that allows selection.
 * It is a supplymental interface used with other models, such as [ListModel].
 */
interface Selection<T> {
  /**
   * Returns the first selected value, or null if none is selected.
   */
  T get selectedValue;
  /**
   * Returns the current selection.
   * It is readonly. Don't modify it directly. Otherwise, UI won't be
   * updated correctly.
   */
  Set<T> get selection;
  /**
   * Replace the current selection with the given set.
   *
   * Notice this method copies the content of [selection], so it is OK
   * to use it after the invocation.
   */
  void set selection(Collection<T> selection);
  /** Returns whether an object is selected.
   */
  bool isSelected(Object obj);
  
  /**
   * Returns true if the selection is currently empty.
   */
  bool isSelectionEmpty();
  /**
   * Add the specified object into selection.
   * It returns whether it has been added successfully.
   * Returns false if it is already selected.
   */
  bool addToSelection(T obj);
  /**
   * Remove the specified object from selection.
   * It returns whether it is removed successfully.
   * Returns false if it is not selected.
   */
  bool removeFromSelection(Object obj);
  /**
   * Change the selection to the empty set.
   */
  void clearSelection();

  /**
   * Sets the selection mode to be multiple.
   */
  void set multiple(bool multiple);
  /**
   * Returns whether the current selection mode is multiple.
   */
  bool get multiple;
}
