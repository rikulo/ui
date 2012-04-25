//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Apr 25, 2012  2:46:46 PM
// Author: tomyeh

/**
 * Represents a selection.
 */
interface Selection<T> {
	/** Returns the selected items (never null).
	 */
	Set<T> get selectedItems();
	/** Returns the first selected item, or null if none is selected.
	 */
	T get selectedItem();

	//TODO: more features
}
