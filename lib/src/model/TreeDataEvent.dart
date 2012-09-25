//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 11, 2012  2:14:37 PM
// Author: tomyeh

/**
 * An event used to notify the listeners of a tree model ([TreeModel])
 * that the model has been changed.
 */
interface TreeDataEvent<T> extends DataEvent default _TreeDataEvent<T> {
  /** Constructor.
   *
   * + [type]: `change`, `add` or `remove`.
   */
  TreeDataEvent(TreeModel<T> model, String type, T node);

  /** Returns the first affected node.
   */
  T get node;
}

class _TreeDataEvent<T> extends _DataEvent implements TreeDataEvent<T> {
  final T _node;

  _TreeDataEvent(TreeModel<T> model, String type, this._node):
  super(model, type);

  T get node => _node;

  String toString() => "$type($node)";
}
