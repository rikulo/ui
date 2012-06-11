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
  Set<List<int>> _selection, _openPaths;
  bool _multiple = false;

  AbstractTreeModel(E root,
  [Set<List<int>> selection, Set<List<int>> openPaths, bool multiple=false]):
  _root = root, _listeners = new List() {
    _selection = selection != null ? selection: new Set();
    _openPaths = openPaths != null ? openPaths: new Set();
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
  void _sendOpenPathsChanged() {
    sendEvent_(new TreeDataEvent.openPathsChanged());
  }

  //ListModel//
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
  Set<List<int>> get openPaths() => _openPaths;
  void set openPaths(Collection<List<int>> openPaths) {
    if (_openPaths != openPaths) {
      _openPaths.clear();
      _openPaths.addAll(openPaths);
      _sendOpenPathsChanged();
    }
  }

  bool isPathOpened(List<int> path) => _openPaths.contains(path);
  bool isOpenPathsEmpty() => _openPaths.isEmpty();

  bool addToOpenPaths(List<int> path) {
    if (_openPaths.contains(path))
      return false;

    _openPaths.add(path);
     _sendOpenPathsChanged();
    return true;
  }
  bool removeFromOpenPaths(List<int> path) {
    if (_openPaths.remove(path)) {
      _sendOpenPathsChanged();
      return true;
    }
    return false;
  }
  void clearOpenPaths() {
    if (!_openPaths.isEmpty()) {
      _openPaths.clear();
      _sendOpenPathsChanged();
    }
  }

  //Selection//
  //@Override
  Set<List<int>> get selection() => _selection;
  //@Override
  void set selection(Collection<List<int>> selection) {
    if (_isSelectionChanged(selection)) {
      if (!_multiple && selection.length > 1)
        throw new IllegalArgumentException("Only one selection is allowed, $selection");
      _selection.clear();
      _selection.addAll(selection);
      _sendSelectionChanged();
    }
  }
  bool _isSelectionChanged(Collection<List<int>> selection) {
    if (_selection.length != selection.length)
      return true;

    for (final List<int> e in selection)
      if (!_selection.contains(e))
        return true;
    return false;
  }

  //@Override
  bool isSelected(Object obj) => _selection.contains(obj);
  //@Override
  bool isSelectionEmpty() => _selection.isEmpty();

  //@Override
  bool addToSelection(List<int> obj) {
    if (_selection.contains(obj))
      return false;

    _selection.add(obj);
    if (!_multiple) {
      _selection.clear();
      _selection.add(obj);
    }
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
        final List<int> v = _selection.iterator().next();
        _selection.clear();
        _selection.add(v);
        _sendSelectionChanged();
      }
    }
  }

  //Additional API//
  /**Removes the selection of the given collection.
   */
  void removeAllSelection(Collection<Dynamic> c) {
    _selection.removeAll(c);
  }

  bool equals(var other) {
    return (other is AbstractListModel) && multiple == other.multiple
      && _selection == other._selection && _openPaths == other._openPaths;
  }
}
