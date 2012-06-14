//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 04, 2012  7:17:06 PM
// Author: tomyeh

/**
 * A skeletal implementation of [ListModel].
 * It handles the data events ([ListDataEvent]) and the selection ([Selection]).
 */
abstract class AbstractListModel<E> extends AbstractSelectionModel<E>
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
