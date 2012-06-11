//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu Feb 16 14:52:22 TST 2012
// Author: tomyeh

/** The listener for [ListDataEvent]
 */
typedef void ListDataListener(ListDataEvent event);

/**
 * A data model representing a list of data.
 */
interface ListModel<E> default DefaultListModel<E> {
  /** Constructor.
   *
   * Notice that once [data] is assigned to a list model, you shall not
   * modify the data directly since UI won't update the changes correctly.
   */
  ListModel(List<E> data);

  /** Returns the value at the specified index.
   */
  E operator [](int index);
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

/** A data model representing a list of data and it allows the user
 * to select any data of it.
 *
 * It is optional since you can implement [ListModel] and [Selection]
 * directly. However, it is convenient that you can instantiate an instance
 * from it and access the methods in both interfaces.
 */
interface ListSelectionModel<E> extends ListModel<E>, Selection<E>
default DefaultListModel<E> {
  /** Constructor.
   *
   * Notice that once [data] is assigned to a list model, you shall not
   * modify the data directly since UI won't update the changes correctly.
   */
  ListSelectionModel(List<E> data);
}
