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
  ListDataEvent(DataEventType type, int index0, int index1);
  ListDataEvent.multipleChanged();
  ListDataEvent.structureChanged();
  ListDataEvent.selectionChanged(Set<E> selectionChanged);

  /** Returns the type of the event.
   */
  DataEventType get type();
  /** Returns the lower index of the change range.
   * It is available only if [type] is [DataEventType.CONTENT_CHANGED],
   * [DataEventType.INTERVAL_ADDED], or [DataEventType.INTERVAL_REMOVED].
   */
  int get index0();
  /** Returns the higher index of the change range.
   * It is available only if [type] is [DataEventType.CONTENT_CHANGED],
   * [DataEventType.INTERVAL_ADDED], or [DataEventType.INTERVAL_REMOVED].
   */
  int get index1();

  /** Returns a collection of objects whose selection have been changed.
   * It is available only if [type] is [DataEventType.SELECTIOIN_CHANGED].
   */
  Set<E> get selectionChanged();

  String toString();
}

class _ListDataEventImpl<E> implements ListDataEvent<E> {
  final DataEventType _type;
  final int _index0, _index1;
  final Set<E> _selChg;

  _ListDataEventImpl(this._type, this._index0, this._index1):
    this._selChg = null;

  _ListDataEventImpl.structureChanged():
    this(DataEventType.STRUCTURE_CHANGED, -1, -1);
  _ListDataEventImpl.multipleChanged():
    this(DataEventType.MULTIPLE_CHANGED, -1, -1);
  _ListDataEventImpl.selectionChanged(this._selChg):
    _type = DataEventType.SELECTION_CHANGED, _index0 = -1, _index1 = -1;

  /** Returns the type of the event.
   */
  DataEventType get type() => this._type;
  /** Returns the lower index of the change range.
   * It is available only if [type] is [DataEventType.CONTENT_CHANGED],
   * [DataEventType.INTERVAL_ADDED], or [DataEventType.INTERVAL_REMOVED].
   */
  int get index0() => this._index0;
  /** Returns the higher index of the change range.
   * It is available only if [type] is [DataEventType.CONTENT_CHANGED],
   * [DataEventType.INTERVAL_ADDED], or [DataEventType.INTERVAL_REMOVED].
   */
  int get index1() => this._index1;

  /** Returns a collection of objects whose selection have been changed.
   * It is available only if [type] is [DataEventType.SELECTION_CHANGED].
   */
  Set<E> get selectionChanged() => _selChg;

  String toString() => "$type($index0, $index1)";
}
