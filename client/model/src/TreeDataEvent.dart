//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 11, 2012  2:14:37 PM
// Author: tomyeh

/**
 * An event used to notify the listeners of a tree model ([TreeModel])
 * that the model has been changed.
 */
interface TreeDataEvent<E> extends DataEvent default _TreeDataEvent<E> {
  /** Constructor.
   *
   * + [type]: `change`, `add` or `remove`.
   */
  TreeDataEvent(TreeModel<E> model, String type, E node);

  /** Returns the first affected node.
   */
  E get node();
}

class _TreeDataEvent<E> extends _DataEvent implements TreeDataEvent<E> {
  final E _node;

  _TreeDataEvent(TreeModel<E> model, String type, this._node):
  super(model, type);

  E get node() => _node;

  String toString() => "$type($node)";
}
