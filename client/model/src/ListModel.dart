//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu Feb 16 14:52:22 TST 2012
// Author: tomyeh

/**
 * A data model representing a list of data.
 *
 * Instead of implementing this interface from scratch, it is suggested
 * to extend from [AbstractListModel] or [AbstractDataModel].
 *
 * Notice the default implementation is [DefaultListModel] that implements
 * [ListModel], [Selection] and [Disables].
 */
interface ListModel<E> extends DataModel default DefaultListModel<E> {
  /** Constructor.
   *
   * Notice that once [data] is assigned to a list model, you shall not
   * modify the data directly since UI won't update the changes correctly.
   *
   * + [selection]: if not null, it will be used to hold the selection.
   * Unlike [set selection], it won't make a copy.
   * + [disables]: if not null, it will be used to hold the list of disabled items.
   * Unlike [set disables], it won't make a copy.
   */
  ListModel(List<E> data, [Set<E> selection, Set<E> disables, bool multiple]);

  /** Returns the value at the specified index.
   */
  E operator [](int index);
  /** Returns the length of the list.
   */
  int get length();
}

/** A data model representing a list of data and it allows the user
 * to select any data of it.
 *
 * It is optional since you can implement [ListModel] and [Selection]
 * directly. However, it is convenient that you can instantiate an instance
 * from it and access the methods in both interfaces.
 */
interface ListSelectionModel<E> extends ListModel<E>, Selection<E>, Disables<E>
default DefaultListModel<E> {
  /** Constructor.
   *
   * Notice that once [data] is assigned to a list model, you shall not
   * modify the data directly since UI won't update the changes correctly.
   *
   * + [selection]: if not null, it will be used to hold the selection.
   * Unlike [set selection], it won't make a copy.
   * + [disables]: if not null, it will be used to hold the list of disabled items.
   * Unlike [set disables], it won't make a copy.
   */
  ListSelectionModel(List<E> data, [Set<E> selection, Set<E> disables, bool multiple]);
}

/**
 * A skeletal implementation of [ListModel].
 * It handles the data events ([ListDataEvent]) and the selection ([Selection]).
 */
//abstract
class AbstractListModel<E> extends AbstractSelectionModel<E>
implements ListSelectionModel<E> {
  /** Constructor.
   *
   * + [selection]: if not null, it will be used to hold the selection.
   * Unlike [set selection], it won't make a copy.
   * + [disables]: if not null, it will be used to hold the list of disabled items.
   * Unlike [set disables], it won't make a copy.
   */
  AbstractListModel([Set<E> selection, Set<E> disables, bool multiple=false]):
  super(selection, disables, multiple);
}
