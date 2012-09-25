//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu Feb 16 14:59:24 TST 2012
// Author: tomyeh

/**
 * An event used to notify the listeners of a list model ([ListModel])
 * that the model has been changed.
 */
interface ListDataEvent<T> extends DataEvent default _ListDataEvent {
  /** Constructor.
   *
   * + [type]: `change`, `add` or `remove`.
   */
  ListDataEvent(ListModel<T> model, String type, int index, int length);

  /** Returns the starting index of the change range (nonnegative).
   */
  int get index;
  /** Returns the total number of items of the change range.
   * If -1, it means all items starting at [index].
   */
  int get length;
}

class _ListDataEvent<T> extends _DataEvent implements ListDataEvent<T> {
  final int _index, _length;

  _ListDataEvent(ListModel<T> model, String type, this._index, this._length):
  super(model, type);

  int get index => _index;
  int get length => _length;

  String toString() => "$type($index, $length)";
}
