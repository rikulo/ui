//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 11, 2012 12:38:52 PM
// Author: tomyeh
part of rikulo_model;

/**
 * Represents a tree node that can be used with [DefaultTreeModel].
 * [DefaultTreeModel] assumes each node is an instance of [TreeNode].
 */
abstract class TreeNode<T> {
  /** Returns the tree model this node belongs to.
   */
  DefaultTreeModel<T> get model;
  /** Sets the tree model it belongs to.
   * This method is invoked automatically by [DefaultTreeModel],
   * so you don't have to invoke it.
   *
   * It can be called only if this node is a root. If a node has a parent,
   * its model shall be the same as its parent.
   */
  void set model(DefaultTreeModel<T> model);

  /** Returns the application-specific data held in this node.
   */
  T get data;
  /** Sets the application-specific data held in this node.
   */
  void set data(T data);

  /** Returns true if this node is a leaf.
   */
  bool get isLeaf;

  /**
   * Returns the child ([TreeNode]) at the given index.
   */
  TreeNode<T> operator[](int index);
  /**
   * Returns the number of children [TreeNode]s this node contains.
   */
  int get length;
  /**
   * Returns the parent [TreeNode] of this node.
   */
  TreeNode<T> get parent;
  /**
   * Returns the index of this node.
   * If this node does not have any parent, 0 will be returned.
   */
  int get index;

  /** Adds child to this node.
   *
   * + [index] the index that [child] will be added at.
   * If null, [child] will be added to the end.
   */
  void add(TreeNode<T> child, [int index]);
  /** Adds a collection of children nodes.
   *
   * Each element of the given [nodes] can be an instance of [TreeNode]
   * or the data. For example,
   *
   *     node.addAll(["apple", "orange"]);
   *     node.addAll([new DefaultTreeNode("group", ["item1", "item2"])]);
   *
   * + [nodes] is a collection of nodes to add. Any element of it can
   * be [TreeNode] or the data.
   * + [index] is the index that [child] will be added at.
   * If null, [child] will be added to the end.
   */
  void addAll(Collection nodes, [int index]);
  /** Removes the child at index from this node.
   *
   * This method returns the tree node being removed.
   */
  TreeNode<T> remove(int index);
  /** Removes all children nodes.
   */
  void clear();
}

/**
 * The default implementation of [TreeNode].
 *
 * Notice that [DefaultTreeModel] only assumes [TreeNode].
 * In other words, you can use any implementation of [TreeNode]
 * with [DefaultTreeModel].
 *
 * ##Load Children Lazily
 *
 * If you'd like to load children lazily (i.e., load the children nodes when it is used),
 * you can override [loadLazily_] and load the children nodes in the method.
 */
class DefaultTreeNode<T> extends TreeNode<T> {
  DefaultTreeModel<T> _model;
  TreeNode<T> _parent;
  List<TreeNode<T>> _children;
  T _data;
  bool _leaf, _loaded = false;

  DefaultTreeNode([T data, Collection nodes, bool leaf]) {
    _data = data;
    _leaf = leaf;
    if (nodes != null)
      addAll(nodes);
  }
  static int _$uuid = 0;
  DefaultTreeModel<T> get model => _parent != null ? _parent.model: _model;
  void set model(DefaultTreeModel<T> model) {
    _model = model;
  }

  T get data => _data;
  void set data(T data) {
    if (!identical(_data, data)) {
      _data = data;

      final DefaultTreeModel<T> m = model;
      if (m != null)
        m.sendEvent(new TreeDataEvent(model, 'change', this));
    }
  }

  bool get isLeaf => _leaf != null ? _leaf: _children == null || _children.isEmpty;

  TreeNode<T> operator[](int childIndex) {
    _init();
    if (_children == null)
      throw new RangeError(childIndex);
    return _children[childIndex];
  }
  int get length {
     _init();
    return _children != null ? _children.length: 0;
  }
  TreeNode<T> get parent => _parent;

  /**
   * Returns the index of this child ([TreeNode]).
   *
   * The implementation uses `List.indexOf` to retrieve the index, so the
   * performance might not be good if the list is big.
   * If the list is sorted, you can override this method to utilize it.
   */
  int get index {
    if (_parent == null)
      return 0;
    if (_parent is! DefaultTreeNode)
      throw new ModelError("DefaultTreeNode expected, not $_parent");

    final DefaultTreeNode p = _parent;
    return p._children.indexOf(this);
  }

  void add(TreeNode<T> child, [int index]) {
    _init();
    if (_leaf != null && _leaf)
      throw new UnsupportedError("Leaf node doesn't allow child");

    if (child.parent != null)
      child.parent.remove(child.index);

    if (_children == null)
      _children = new List();
    _children.insertRange(index != null ? index: _children.length, 1, child);

    if (child is DefaultTreeNode) {
      final DefaultTreeNode c = child;
      c._parent = this;
    }

    final DefaultTreeModel<T> m = model;
    if (m != null)
      m.sendEvent(new TreeDataEvent(model, 'add', child));
  }
  void addAll(Collection nodes, [int index]) {
    _init();
    if (index == null)
      index = _children != null ? _children.length: 0;

    for (final node in nodes)
      add(node is TreeNode ? node: new DefaultTreeNode(node), index++);
  }
  TreeNode<T> remove(int index) {
    _init();
    final DefaultTreeModel<T> m = model;
    TreeNode<T> child = this[index];

    if (m != null)
      _cleanSelOpen(m, child);

    _children.removeRange(index, 1);

    if (child is DefaultTreeNode) {
      final DefaultTreeNode c = child;
      c._parent = null;
    }

    if (m != null)
      m.sendEvent(new TreeDataEvent(model, 'remove', child));
    return child;
  }
  static void _cleanSelOpen(DefaultTreeModel m, TreeNode child) {
    //no need to fire event (since it is convered by DATA_REMOVED)
    m._selection.remove(child);
    m._opens.remove(child);

    if (!child.isLeaf) {
      for (int i = 0, len = child.length; i < len; ++i)
        _cleanSelOpen(m, child[i]);
    }
  }
  void clear() {
    _init();
    if (_children != null && !_children.isEmpty) {
      final DefaultTreeModel<T> m = model;
      if (m != null) {
        for (final TreeNode<T> child in _children)
          _cleanSelOpen(m, child);
      }

      _children = null;

      if (m != null) {
        m.sendEvent(new TreeDataEvent(model, 'change', this));
      }
    }
  }
 
  void _init() {
    if (!_loaded) {
      _loaded = true;
      _children = loadLazily_();
      if (_children != null) {
        for (final TreeNode<T> child in _children) {
          if (child is DefaultTreeNode) {
            final DefaultTreeNode c = child;
            c._parent = this;
          }
        }
      }
    }
  }
  /**
   * Returns the intial collection of child nodes, or null if there is no children at all.
   *
   * Default: return null.
   *
   * If you'd like to load tree nodes lazily, you can override this method, and
   * return a collection of child nodes.
   */
  Collection<TreeNode<T>> loadLazily_() => null;
  String toString() => "DefaultTreeNode($data)";
}
