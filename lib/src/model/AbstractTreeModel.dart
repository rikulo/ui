//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 11, 2012  2:23:09 PM
// Author: tomyeh

/**
 * A skeletal implementation of [TreeModel].
 * To extend from this class, you have to implement [getChild], [getChildCount]
 * and [isLeaf]. This class provides a default implementation for all other methods.
 */
//abstract
class AbstractTreeModel<T> extends AbstractSelectionModel<T>
implements TreeSelectionModel<T> {
  T _root;
  Set<T> _opens;

  /** Constructor.
   *
   * + [selection]: if not null, it will be used to hold the selection.
   * Unlike [set selection], it won't make a copy.
   * + [disables]: if not null, it will be used to hold the list of disabled items.
   * Unlike [set disables], it won't make a copy.
   * + [opens]: if not null, it will be used to hold the list of opened items.
   * Unlike [set opens], it won't make a copy.
   */
  AbstractTreeModel(T root, [Set<T> selection, Set<T> disables,
  Set<T> opens, bool multiple=false]):
  super(selection, disables, multiple) {
    _root = root;
    _opens = opens != null ? opens: new Set();
  }

  void _sendOpen() {
    sendEvent(new DataEvent(this, 'open'));
  }

  //TreeModel//
  T get root => _root;
  /** Sets the root of the tree model.
   */
  void set root(T root) {
    if (_root !== root) {
      _root = root;
      _selection.clear();
      _opens.clear();
      sendEvent(new DataEvent(this, 'structure'));
    }
  }

  T getChildAt(List<int> path) {
    if (path == null || path.length == 0)
      return root;

    T parent = root;
    T node = null;
    int childCount = _childCount(parent);
    for (int i = 0; i < path.length; i++) {
      if (path[i] < 0 || path[i] > childCount //out of bound
      || (node = getChild(parent, path[i])) == null //model is wrong
      || ((childCount = _childCount(node)) <= 0 && i != path.length - 1)) //no more child
        return null;

      parent = node;
    }
    return node;
  }
  int _childCount(T parent) => isLeaf(parent) ? 0: getChildCount(parent);

  //Open//
  Set<T> get opens => _opens;
  void set opens(Collection<T> opens) {
    if (_opens != opens) {
      _opens.clear();
      _opens.addAll(opens);
      _sendOpen();
    }
  }

  bool isOpened(T node) => _opens.contains(node);
  bool isOpensEmpty() => _opens.isEmpty();

  bool addToOpens(T node) {
    if (_opens.contains(node))
      return false;

    _opens.add(node);
     _sendOpen();
    return true;
  }
  bool removeFromOpens(T node) {
    if (_opens.remove(node)) {
      _sendOpen();
      return true;
    }
    return false;
  }
  void clearOpens() {
    if (!_opens.isEmpty()) {
      _opens.clear();
      _sendOpen();
    }
  }

  //Additional API//
  /**Removes the given collection from the list of opened nodes.
   */
  void removeAllOpens(Collection<Dynamic> c) {
    final int oldlen = _opens.length;
    _opens.removeAll(c);
    if (oldlen != _opens.length)
      _sendOpen();
  }

  bool equals(var other) {
    return (other is AbstractTreeModel) && super.equals(other)
      && _opens == other._opens;
  }
}
