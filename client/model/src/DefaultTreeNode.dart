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
 * ##Load Children Lazily##
 *
 * If you'd like to load children lazily (i.e., load the children nodes when it is used),
 * you can override [loadLazily_] and load the children nodes in the method.
 */
class DefaultTreeNode<E> implements TreeNode<E> {
  DefaultTreeModel<E> _model;
  TreeNode<E> _parent;
  List<TreeNode<E>> _children;
  E _data;
  bool _leaf, _loaded = false;

  DefaultTreeNode([bool leaf]) {
    _leaf = leaf;
  }
  DefaultTreeModel<E> get model() => _parent !== null ? _parent.model: _model;
  void set model(DefaultTreeModel<E> model) {
    _model = model;
  }

  E get data() => _data;
  void set data(E data) {
    if (_data !== data) {
      _data = data;

      final DefaultTreeModel<E> m = model;
      if (m !== null)
        m.sendEvent_(new TreeDataEvent(DataEventType.CONTENT_CHANGED, this));
    }
  }

  bool isLeaf() => _leaf !== null ? _leaf: _children === null || _children.isEmpty();

  TreeNode<E> getChildAt(int childIndex) {
    _init();
    if (_children === null)
      throw const IndexOutOfRangeException(childIndex);
    return _children[childIndex];
  }
  int get childCount() {
     _init();
    return _children !== null ? _children.length: 0;
  }
  TreeNode<E> get parent() => _parent;

  int get index() {
    if (_parent === null)
      return 0;
    if (_parent is! DefaultTreeNode)
      throw const ModelException("DefaultTreeNode expected");

    final DefaultTreeNode p = _parent;
    return p._children.indexOf(this);
  }

  void add(TreeNode<E> child, [int index]) {
    _init();
    if (_leaf !== null && _leaf)
      throw const UnsupportedOperationException("Leaf node doesn't allow child");

    if (child.parent !== null)
      child.parent.remove(child.index);

    if (_children === null)
      _children = new List();
    _children.insertRange(index !== null ? index: _children.length, 1, child);

    if (child is DefaultTreeNode) {
      final DefaultTreeNode c = child;
      c._parent = this;
    }

    final DefaultTreeModel<E> m = model;
    if (m !== null)
      m.sendEvent_(new TreeDataEvent(DataEventType.INTERVAL_ADDED, child));
  }
  TreeNode<E> remove(int index) {
    _init();
    final DefaultTreeModel<E> m = model;
    TreeNode<E> child = getChildAt(index);

    if (m !== null) {
      //no need to fire event (since it is convered by INTERVAL_REMOVED)
      m._selection.remove(child);
      m._opens.remove(child);
    }

    _children.removeRange(index, 1);

    if (child is DefaultTreeNode) {
      final DefaultTreeNode c = child;
      c._parent = null;
    }

    if (m !== null)
      m.sendEvent_(new TreeDataEvent(DataEventType.INTERVAL_REMOVED, child));
    return child;
  }

  void _init() {
    if (!_loaded) {
      _loaded = true;
      _children = loadLazily_();
      if (_children !== null) {
        for (final TreeNode<E> child in _children) {
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
  Collection<TreeNode<E>> loadLazily_() => null;
  String toString() => "DefaultTreeNode($data)";
}
