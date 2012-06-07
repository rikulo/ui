//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu Feb 16 14:59:24 TST 2012
// Author: tomyeh

/**
 * An event used to notify the listeners of a modle ([ListModel])
 * that the model is changed.
 */
interface ListDataEvent<E> default _ListDataEventImpl<E> {
  /** Constructor for [DataEventType.CONTENT_CHANGED], [DataEventType.INTERVAL_ADDED],
   * and [DataEventType.INTERVAL_REMOVED].
   */
  ListDataEvent(DataEventType type, int index, int length);
  ListDataEvent.multipleChanged();
  ListDataEvent.structureChanged();
  ListDataEvent.selectionChanged(Set<E> selectionChanged);

  /** Returns the type of the event.
   */
  DataEventType get type();
  /** Returns the starting index of the change range (nonnegative).
   * It is available only if [type] is [DataEventType.CONTENT_CHANGED],
   * [DataEventType.INTERVAL_ADDED], or [DataEventType.INTERVAL_REMOVED].
   */
  int get index();
  /** Returns the total number of items of the change range.
   * If -1, it means all items starting at [index].
   * It is available only if [type] is [DataEventType.CONTENT_CHANGED],
   * [DataEventType.INTERVAL_ADDED], or [DataEventType.INTERVAL_REMOVED].
   */
  int get length();

  /** Returns a collection of objects whose selection have been changed.
   * It is available only if [type] is [DataEventType.SELECTIOIN_CHANGED].
   */
  Set<E> get selectionChanged();

  String toString();
}

class _ListDataEventImpl<E> implements ListDataEvent<E> {
  final DataEventType _type;
  final int _index, _length;
  final Set<E> _selChg;

  _ListDataEventImpl(this._type, this._index, this._length):
    this._selChg = null;

  _ListDataEventImpl.structureChanged():
    this(DataEventType.STRUCTURE_CHANGED, 0, -1);
  _ListDataEventImpl.multipleChanged():
    this(DataEventType.MULTIPLE_CHANGED, 0, -1);
  _ListDataEventImpl.selectionChanged(this._selChg):
    _type = DataEventType.SELECTION_CHANGED, _index = 0, _length = -1;

  /** Returns the type of the event.
   */
  DataEventType get type() => this._type;
  /** Returns the lower index of the change range (nonnegative).
   * It is available only if [type] is [DataEventType.CONTENT_CHANGED],
   * [DataEventType.INTERVAL_ADDED], or [DataEventType.INTERVAL_REMOVED].
   */
  int get index() => this._index;
  /** Returns the total number of items of the change range.
   * If -1, it means all items starting at [index].
   * It is available only if [type] is [DataEventType.CONTENT_CHANGED],
   * [DataEventType.INTERVAL_ADDED], or [DataEventType.INTERVAL_REMOVED].
   */
  int get length() => this._length;

  /** Returns a collection of objects whose selection have been changed.
   * It is available only if [type] is [DataEventType.SELECTION_CHANGED].
   */
  Set<E> get selectionChanged() => _selChg;

  String toString() => "$type($index, $length)";
}
