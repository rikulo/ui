//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 11, 2012  2:23:09 PM
// Author: tomyeh

/**
 * A skeletal implementation of [TreeModel].
 * To extend from this class, you have to implement [getChild], [getChildCount]
 * and [isLeaf]. This class provides a default implementation for all other methods.
 */
abstract class AbstractTreeModel<E> implements TreeSelectionModel<E> {
  E _root;
  final List<TreeDataListener> _listeners;
  Set<E> _selection, _opens;
  bool _multiple = false;

  AbstractTreeModel(E root, [Set<E> selection, Set<E> opens, bool multiple=false]):
  _root = root, _listeners = new List() {
    _selection = selection != null ? selection: new Set();
    _opens = opens != null ? opens: new Set();
    _multiple = multiple;
  }

  /** Fires [TreeDataEvent] for all registered listener.
   */
  void sendEvent_(TreeDataEvent event) {
    for (final TreeDataListener listener in _listeners)
      listener(event);
  }
  void _sendSelectionChanged() {
    sendEvent_(new TreeDataEvent.selectionChanged());
  }
  void _sendOpensChanged() {
    sendEvent_(new TreeDataEvent.opensChanged());
  }

  //TreeModel//
	void addTreeDataListener(TreeDataListener l) {
		_listeners.add(l);
	}
	void removeTreeDataListener(TreeDataListener l) {
		ListUtil.remove(_listeners, l);
	}

  E get root() => _root;
  /** Sets the root of the tree model.
   */
  void set root(E root) {
    if (_root !== root) {
      _root = root;
      _selection.clear();
      _opens.clear();
      sendEvent_(new TreeDataEvent.structureChanged());
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
      _sendOpensChanged();
    }
  }

  bool isOpened(E node) => _opens.contains(node);
  bool isOpensEmpty() => _opens.isEmpty();

  bool addToOpens(E node) {
    if (_opens.contains(node))
      return false;

    _opens.add(node);
     _sendOpensChanged();
    return true;
  }
  bool removeFromOpens(E node) {
    if (_opens.remove(node)) {
      _sendOpensChanged();
      return true;
    }
    return false;
  }
  void clearOpens() {
    if (!_opens.isEmpty()) {
      _opens.clear();
      _sendOpensChanged();
    }
  }

  //Selection//
  E get firstSelection() => _selection.isEmpty() ? null: _selection.iterator().next();
  Set<E> get selection() => _selection;

  void set selection(Collection<E> selection) {
    if (_isSelectionChanged(selection)) {
      if (!_multiple && selection.length > 1)
        throw new IllegalArgumentException("Only one selection is allowed, $selection");
      _selection.clear();
      _selection.addAll(selection);
      _sendSelectionChanged();
    }
  }
  bool _isSelectionChanged(Collection<E> selection) {
    if (_selection.length != selection.length)
      return true;

    for (final E e in selection)
      if (!_selection.contains(e))
        return true;
    return false;
  }

  //@Override
  bool isSelected(Object obj) => _selection.contains(obj);
  //@Override
  bool isSelectionEmpty() => _selection.isEmpty();

  //@Override
  bool addToSelection(E node) {
    if (_selection.contains(node))
      return false;

    if (!_multiple)
      _selection.clear();
    _selection.add(node);
    _sendSelectionChanged();
    return true;
  }
  //@Override
  bool removeFromSelection(Object obj) {
    if (_selection.remove(obj)) {
      _sendSelectionChanged();
      return true;
    }
    return false;
  }
  //@Override
  void clearSelection() {
    if (!_selection.isEmpty()) {
      _selection.clear();
      _sendSelectionChanged();
    }
  }

  //@Override
  bool get multiple() => _multiple;
  //@Override
  void set multiple(bool multiple) {
    if (_multiple != multiple) {
      _multiple = multiple;
      sendEvent_(new TreeDataEvent.multipleChanged());

      if (!multiple && _selection.length > 1) {
        final E node = _selection.iterator().next();
        _selection.clear();
        _selection.add(node);
        _sendSelectionChanged();
      }
    }
  }

  //Additional API//
  /**Removes the selection of the given collection.
   */
  void removeAllSelection(Collection<Dynamic> c) {
    final int oldlen = _selection.length;
    _selection.removeAll(c);
    if (oldlen != _selection.length)
      _sendSelectionChanged();
  }

  bool equals(var other) {
    return (other is AbstractTreeModel) && multiple == other.multiple
      && _selection == other._selection && _opens == other._opens;
  }
}
