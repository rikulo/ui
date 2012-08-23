//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 11, 2012  4:53:41 PM
// Author: tomyeh

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
class DefaultTreeNode<T> implements TreeNode<T>, Hashable {
  DefaultTreeModel<T> _model;
  TreeNode<T> _parent;
  List<TreeNode<T>> _children;
  T _data;
  bool _leaf, _loaded = false;
  int _uuid;

  DefaultTreeNode([T data, Collection nodes, bool leaf]) {
    _data = data;
    _leaf = leaf;
    _uuid = _$uuid++;
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
    if (_data !== data) {
      _data = data;

      final DefaultTreeModel<T> m = model;
      if (m != null)
        m.sendEvent(new TreeDataEvent(model, 'change', this));
    }
  }

  bool isLeaf() => _leaf != null ? _leaf: _children == null || _children.isEmpty();

  TreeNode<T> operator[](int childIndex) {
    _init();
    if (_children == null)
      throw new IndexOutOfRangeException(childIndex);
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
      throw const ModelException("DefaultTreeNode expected");

    final DefaultTreeNode p = _parent;
    return p._children.indexOf(this);
  }

  void add(TreeNode<T> child, [int index]) {
    _init();
    if (_leaf != null && _leaf)
      throw const UnsupportedOperationException("Leaf node doesn't allow child");

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
      add(node is TreeNode ? node: new TreeNode(node), index++);
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

    if (!child.isLeaf()) {
      for (int i = 0, len = child.length; i < len; ++i)
        _cleanSelOpen(m, child[i]);
    }
  }
  void clear() {
    _init();
    if (_children != null && !_children.isEmpty()) {
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

  int hashCode() => _uuid;
}
