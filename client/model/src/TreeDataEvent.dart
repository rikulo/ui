//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 11, 2012  2:14:37 PM
// Author: tomyeh

/**
 * An event used to notify the listeners of a tree model ([TreeModel])
 * that the model has been changed.
 */
interface TreeDataEvent<E> extends DataEvent default _TreeDataEvent<E> {
  /** Constructor for [DataEventType.CONTENT_CHANGED], [DataEventType.DATA_ADDED],
   * and [DataEventType.DATA_REMOVED].
   */
  TreeDataEvent(DataEventType type, E node);
  TreeDataEvent.multipleChanged();
  TreeDataEvent.structureChanged();
  TreeDataEvent.selectionChanged();
  TreeDataEvent.opensChanged();

  /** Returns the first affected node.
   *
   * It is available only if [type] is [DataEventType.CONTENT_CHANGED],
   * [DataEventType.DATA_ADDED], or [DataEventType.DATA_REMOVED].
   */
  E get node();
}

class _TreeDataEvent<E> implements TreeDataEvent<E> {
  final DataEventType _type;
  final E _node;

  _TreeDataEvent(this._type, this._node);
  _TreeDataEvent.structureChanged():
    this(DataEventType.STRUCTURE_CHANGED, null);
  _TreeDataEvent.multipleChanged():
    this(DataEventType.MULTIPLE_CHANGED, null);
  _TreeDataEvent.selectionChanged():
    this(DataEventType.SELECTION_CHANGED, null);
  _TreeDataEvent.opensChanged():
    this(DataEventType.OPENS_CHANGED, null);

  DataEventType get type() => _type;
  E get node() => _node;

  String toString() => "$type($node)";
}
