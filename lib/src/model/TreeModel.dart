//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 11, 2012 12:37:37 PM
// Author: tomyeh
part of rikulo_model;

/**
 * An event used to notify the listeners of a tree model ([TreeModel])
 * that the model has been changed.
 */
class TreeDataEvent<T> extends DataEvent {
  /** Constructor.
   *
   * + [type]: `change`, `add` or `remove`.
   */
  TreeDataEvent(TreeModel<T> model, String type, T this.node): super(model, type);

  /** Returns the first affected node.
   */
  final T node;

  String toString() => "$type($node)";
}

/**
 * A data model representing a tree of data.
 * Each node of the tree can be anything and represented with the generic type, `T`.
 *
 * Instead of implementing this interface from scratch, it is suggested:
 *
 * 1. Use [DefaultTreeModel] if you'd like to represent the tree with a tree of [TreeNode].
 * In other words, each node of the tree is represented with an instance of [TreeNode], and
 * the data can be retrieved by [TreeNode.data].
 * 2. Extends from [AbstractTreeModel]. [AbstractTreeModel] provides the implementation
 * of handling of data listeners, maintaining the open states and the selection.
 *
 * ##How Data Retrieved
 *
 * To retrieve the data in the data model,
 *
 * 1. [root] is called first to retrieve the root data
 * 2. [isLeaf] is called to examine if the data (aka., the node) is a leaf node
 * 3. If it is not a leaf, [getChildCount] is called to retrieve the number of children
 * 4. Then, [getChild] is called to retrieve each child
 * 5. Repeat  2-4
 *
 * ##Path
 *
 * A node of the tree model can be presented by an integer array called `path`.
 * For example, [0, 2, 1] represents a node at the third level (excluding root) since
 * there are three elements. Furthermore, it is the root's the first child's
 * the third child's second child. YOu can retrieve it as follows
 *
 *     model.getChildAt([0, 2, 1]);
 *
 * [TreeModel] doesn't not provide API to retrieve the path of a given node
 * (since sometimes it is hard to get). Thus, the view that supports [TreeModel]
 * shall store the path, if necessary, when rendering.
 *
 * On the other hand, [DefaultTreeModel] and [TreeNode] do
 * provide `getPath()` to retrieve the path of any given node.
 *
 * ##Selection
 *
 * If you'd like to use [TreeModel] with a UI object that allows the user to select the data,
 * such as [DropDownList] and [TreeView]. You have to implement `Selection<T>`.
 * Both [DefaultTreeModel] and [AbstractTreeModel] implements it, so you need to implement
 * it only if you implement [TreeModel] from scratch.
 *
 * ##Opens
 *
 * A tree model maintains a list of opened nodes ([Opens]). If a tree node matches
 * one of the open nodes, the tree node will be opened, i.e., the child views
 * will be visible to the user.
 */
abstract class TreeModel<T> extends DataModel {
	/**
	 * Returns the root of the tree model.
	 */
	T get root;
	/**
	 * Returns the child of the given parent at the given index where the index indicates
	 * in the parent's child array.
	 *
	 * + [parent] is a node in the tree, obtained from [root] or [getChild].
	 */
	T getChild(T parent, int index);
	/**
	 * Returns the number of children of the given parent.
	 *
	 * + [parent] is a node in the tree, obtained from [root] or [getChild].
	 */
	int getChildCount(T parent);
	/**
	 * Returns true if node is a leaf.
	 * In file-system terminology, a leaf node is a file, while a non-leaf node is a folder.
	 *
	 * + [node] is the data returned by [root] or [getChild].
	 */
	bool isLeaf(T node);

	/**
	 * Returns the child at the given path where the path indicates the child is
	 * placed in the whole tree.
	 *
	 * + [path] is a list of the index at each level of the tree. For example, [0, 1, 2]
	 * represents the first child's the second child's third child.
	 */
	T getChildAt(List<int> path);
}

/**
 * A skeletal implementation of [TreeModel].
 * To extend from this class, you have to implement [getChild], [getChildCount]
 * and [isLeaf]. This class provides a default implementation for all other methods.
 */
abstract class AbstractTreeModel<T> extends AbstractSelectionModel<T>
implements TreeModel<T>, Opens<T> {
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
  AbstractTreeModel(T root, {Set<T> selection, Set<T> disables,
  Set<T> opens, bool multiple: false}):
  super(selection: selection, disables: disables, multiple: multiple) {
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
    if (!identical(_root, root)) {
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
  bool get isOpensEmpty => _opens.isEmpty;

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
    if (!_opens.isEmpty) {
      _opens.clear();
      _sendOpen();
    }
  }

  //Additional API//
  /**Removes the given collection from the list of opened nodes.
   */
  void removeAllOpens(Collection<dynamic> c) {
    final int oldlen = _opens.length;
    _opens.removeAll(c);
    if (oldlen != _opens.length)
      _sendOpen();
  }
  //@override
  bool operator==(other) {
    return (other is AbstractTreeModel) && super == other
      && _opens == other._opens;
  }
}
