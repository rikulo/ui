//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu Feb 16 15:22:36 TST 2012
// Author: tomyeh

/**
 * Indicates a model that allows selection.
 * It is a supplymental interface used with other models, such as [ListModel].
 */
interface Selectable<E> {
	/**
	 * Returns the current selection.
	 * It is readonly. Don't modify it directly
	 */
	Set<E> getSelection();
	/**
	 * Replace the current selection with the given set.
	 */
	void setSelection(Collection<E> selection);
	/** Returns whether an object is selected.
	 */
	bool isSelected(Object obj);
	
	/**
	 * Returns true if the selection is currently empty.
	 */
	bool isSelectionEmpty();
	/**
	 * Add the specified object into selection.
	 * @return whether it has been added successfully.
	 * Returns false if it is already selected.
	 */
	bool addToSelection(E obj);
	/**
	 * Remove the specified object from selection.
	 * @return whether it is removed successfully.
	 * Returns false if is not selected.
	 */
	bool removeFromSelection(Object obj);
	/**
	 * Change the selection to the empty set.
	 */
	void clearSelection();

	/**
	 * Sets the selection mode to be multiple.
	 */
	void setMultiple(bool multiple);
	/**
	 * Returns whether the current selection mode is multiple.
	 */
	bool isMultiple();
}
