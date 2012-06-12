//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu Feb 16 14:59:24 TST 2012
// Author: tomyeh

/**
 * An event used to notify the listeners of a list model ([ListModel])
 * that the model has been changed.
 */
interface ListDataEvent default _ListDataEvent {
  /** Constructor for [DataEventType.CONTENT_CHANGED], [DataEventType.DATA_ADDED],
   * and [DataEventType.DATA_REMOVED].
   */
  ListDataEvent(DataEventType type, int index, int length);
  ListDataEvent.multipleChanged();
  ListDataEvent.structureChanged();
  ListDataEvent.selectionChanged();

  /** Returns the type of the event.
   */
  DataEventType get type();
  /** Returns the starting index of the change range (nonnegative).
   * It is available only if [type] is [DataEventType.CONTENT_CHANGED],
   * [DataEventType.DATA_ADDED], or [DataEventType.DATA_REMOVED].
   */
  int get index();
  /** Returns the total number of items of the change range.
   * If -1, it means all items starting at [index].
   * It is available only if [type] is [DataEventType.CONTENT_CHANGED],
   * [DataEventType.DATA_ADDED], or [DataEventType.DATA_REMOVED].
   */
  int get length();
}

class _ListDataEvent implements ListDataEvent {
  final DataEventType _type;
  final int _index, _length;

  _ListDataEvent(this._type, this._index, this._length);
  _ListDataEvent.structureChanged():
    this(DataEventType.STRUCTURE_CHANGED, 0, -1);
  _ListDataEvent.multipleChanged():
    this(DataEventType.MULTIPLE_CHANGED, 0, -1);
  _ListDataEvent.selectionChanged():
    this(DataEventType.SELECTION_CHANGED, 0, -1);

  DataEventType get type() => _type;
  int get index() => _index;
  int get length() => _length;

  String toString() => "$type($index, $length)";
}
