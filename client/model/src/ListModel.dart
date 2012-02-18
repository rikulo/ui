//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu Feb 16 14:52:22 TST 2012
// Author: tomyeh

typedef void ListDataListener(ListDataEvent event);

/**
 * A data model representing a list of data.
 */
interface ListModel<E> {
	/** Returns the value at the specified index.
	 */
	E getElementAt(int index);
	/** Returns the length of the list.
	 */
	int get length();

	/** Adds a listener to the list that's notified each time a change
	 * to the data model occurs. 
	 */
	void addListDataListener(ListDataListener listener);
	/** Removes a listener from the list that's notified each time
	 * a change to the data model occurs. 
	 */
	void removeListDataListener(ListDataListener listener) ;
}
