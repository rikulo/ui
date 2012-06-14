//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 11, 2012  2:23:09 PM
// Author: tomyeh

/**
 * A skeletal implementation of [TreeModel].
 * To extend from this class, you have to implement [getChild], [getChildCount]
 * and [isLeaf]. This class provides a default implementation for all other methods.
 */
abstract class AbstractTreeModel<E> extends AbstractSelectionModel<E>
implements TreeSelectionModel<E> {
  E _root;
  Set<E> _opens;

  /** Constructor.
   *
   * + [selection]: if not null, it will be used to hold the selection.
   * Unlike [set selection], it won't make a copy.
   * + [disables]: if not null, it will be used to hold the list of disabled items.
   * Unlike [set disables], it won't make a copy.
   * + [opens]: if not null, it will be used to hold the list of opened items.
   * Unlike [set opens], it won't make a copy.
   */
  AbstractTreeModel(E root, [Set<E> selection, Set<E> disables,
  Set<E> opens, bool multiple=false]):
  super(selection, disables, multiple) {
    _opens = opens !== null ? opens: new Set();
  }

  void _sendOpen() {
    sendEvent(new DataEvent(this, 'open'));
  }

  //TreeModel//
  E get root() => _root;
  /** Sets the root of the tree model.
   */
  void set root(E root) {
    if (_root !== root) {
      _root = root;
      _selection.clear();
      _opens.clear();
      sendEvent(new DataEvent(this, 'structure'));
    }
  }

  int getIndexOfChild(E parent, E child) {
    final int cnt = _childCount(parent);
    for (int j = 0; j < cnt; ++j)
      if (child == getChild(parent, j))
        return j;
    return -1;
  }
  E getChildAt(List<int> path) {
    if (path === null || path.length == 0)
      return root;

    E parent = root;
    E node = null;
    int childCount = _childCount(parent);
    for (int i = 0; i < path.length; i++) {
      if (path[i] < 0 || path[i] > childCount //out of bound
      || (node = getChild(parent, path[i])) === null //model is wrong
      || ((childCount = _childCount(node)) <= 0 && i != path.length - 1)) //no more child
        return null;

      parent = node;
    }
    return node;
  }
	/**
	 * Returns the path from the given child, where the path indicates the child is
	 * placed in the whole tree.
	 *
	 * The performance of the default implementation is not good because of deep-first-search.
	 * It is suggested to override it if you have a better algorithm
	 */
  List<int> getPath(E child) {
		final List<int> path = new List();
		_dfSearch(path, root, child);
		return path;
	}
	bool _dfSearch(List<int> path, E node, E target){
		if (node == target)
			return true;

		for (int i = 0, size = _childCount(node); i< size; i++)
			if (_dfSearch(path, getChild(node, i), target)){
				path.insertRange(0, 1, i);
				return true;
			}
		return false;
	}
  int _childCount(E parent) => isLeaf(parent) ? 0: getChildCount(parent);

  //Open//
  Set<E> get opens() => _opens;
  void set opens(Collection<E> opens) {
    if (_opens != opens) {
      _opens.clear();
      _opens.addAll(opens);
      _sendOpen();
    }
  }

  bool isOpened(E node) => _opens.contains(node);
  bool isOpensEmpty() => _opens.isEmpty();

  bool addToOpens(E node) {
    if (_opens.contains(node))
      return false;

    _opens.add(node);
     _sendOpen();
    return true;
  }
  bool removeFromOpens(E node) {
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
