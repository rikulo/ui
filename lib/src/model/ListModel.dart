//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu Feb 16 14:52:22 TST 2012
// Author: tomyeh
part of rikulo_model;

/**
 * An event used to notify the listeners of a list model ([ListModel])
 * that the model has been changed.
 */
class ListDataEvent<T> extends DataEvent {
  /** Constructor.
   *
   * + [type]: `change`, `add` or `remove`.
   */
  ListDataEvent(ListModel<T> model, String type, int this.index, int this.length)
  : super(model, type);

  /** The starting index of the change range (nonnegative).
   */
  final int index;
  /** The total number of items of the change range.
   * If -1, it means all items starting at [index].
   */
  final int length;
}

/**
 * A data model representing a list of data.
 *
 * Instead of implementing this interface, you can use [DefaultListModel]. It
 * is a concrete class that implements [ListModel], [Selection] and [Disables].
 *
 * Instead of implementing this interface from scratch, it is suggested
 * to extend from [AbstractListModel] or [AbstractDataModel].
 */
abstract class ListModel<T> extends DataModel {
  /** Returns the value at the specified index.
   */
  T operator [](int index);
  /** Returns the length of the list.
   */
  int get length;
}

class Foo extends ListModel {
  String operator [](int index) => "";
  /** Returns the length of the list.
   */
  int get length=>0;
}
/**
 * A skeletal implementation of [ListModel].
 * It handles the data events ([ListDataEvent]) and the selection ([Selection]).
 */
abstract class AbstractListModel<T> extends AbstractSelectionModel<T>
implements ListModel<T> {
  /** Constructor.
   *
   * + [selection]: if not null, it will be used to hold the selection.
   * Unlike [set selection], it won't make a copy.
   * + [disables]: if not null, it will be used to hold the list of disabled items.
   * Unlike [set disables], it won't make a copy.
   */
  AbstractListModel({Set<T> selection, Set<T> disables, bool multiple:false}):
  super(selection: selection, disables: disables, multiple: multiple);
}
