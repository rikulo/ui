//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 11, 2012  2:14:37 PM
// Author: tomyeh

/**
 * An event used to notify the listeners of a tree model ([TreeModel])
 * that the model has been changed.
 */
interface TreeDataEvent default _TreeDataEvent {
  /** Constructor for [DataEventType.CONTENT_CHANGED], [DataEventType.INTERVAL_ADDED],
   * and [DataEventType.INTERVAL_REMOVED].
   */
  TreeDataEvent(DataEventType type, List<int> path, int length);
  TreeDataEvent.multipleChanged();
  TreeDataEvent.structureChanged();
  TreeDataEvent.selectionChanged();
  TreeDataEvent.openPathsChanged();

  /** Returns the type of the event.
   */
  DataEventType get type();

  /** Returns the path of the first affected node, or null if it indicates the root.
   *
   * It is available only if [type] is [DataEventType.CONTENT_CHANGED],
   * [DataEventType.INTERVAL_ADDED], or [DataEventType.INTERVAL_REMOVED].
   */
  List<int> get path();

  /** Returns the total number of items of the change range.
   * If -1, it means all following sibling items start from [path].
   *
   * For example, if [path] is [0, 2] and [length] 2, then it means
   * both [0, 2] and [0, 3] are changed.
   *
   * Notice that an instance of [TreeDataEvent] can represent only the items
   * with the same parent.
   *
   * It is available only if [type] is [DataEventType.CONTENT_CHANGED],
   * [DataEventType.INTERVAL_ADDED], or [DataEventType.INTERVAL_REMOVED]
   */
  int get length();
}

class _TreeDataEvent implements TreeDataEvent {
  final DataEventType _type;
  final List<int> _path;
  final int _length;

  _TreeDataEvent(this._type, this._path, this._length);
  _TreeDataEvent.structureChanged():
    this(DataEventType.STRUCTURE_CHANGED, null, -1);
  _TreeDataEvent.multipleChanged():
    this(DataEventType.MULTIPLE_CHANGED, null, -1);
  _TreeDataEvent.selectionChanged():
    this(DataEventType.SELECTION_CHANGED, null, -1);
  _TreeDataEvent.openPathsChanged():
    this(DataEventType.OPEN_PATHS_CHANGED, null, -1);

  DataEventType get type() => _type;
  List<int> get path() => _path;
  int get length() => _length;

  String toString() => "$type($path, $length)";
}
