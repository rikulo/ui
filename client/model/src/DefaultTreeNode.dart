//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 11, 2012  4:53:41 PM
// Author: tomyeh

/**
 * The default implementation of [TreeNode].
 *
 * Notice that [DefaultTreeModel] only assumes [TreeNode].
 * In other words, you can use any implementation of [TreeNode]
 * in [DefaultTreeModel].
 */
class DefaultTreeNode<E> implements TreeNode<E> {
  DefaultTreeModel<E> _model;
  TreeNode<E> _parent;
  List<TreeNode<E>> _children;
  E _data;
  bool _leaf;

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
        m.sendEvent_(new TreeDataEvent(
          DataEventType.CONTENT_CHANGED, m.getPath(this), 1));
    }
  }

  bool isLeaf() => _leaf !== null ? _leaf: _children === null || _children.isEmpty();

  TreeNode<E> getChildAt(int childIndex) {
    if (_children === null)
      throw const IndexOutOfRangeException(childIndex);
    return _children[childIndex];
  }
  int get childCount() => _children !== null ? _children.length: 0;
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
      m.sendEvent_(new TreeDataEvent(
        DataEventType.INTERVAL_ADDED, m.getPath(child), 1));
  }
  TreeNode<E> remove(int index) {
    final DefaultTreeModel<E> m = model;
    TreeNode<E> child = getChildAt(index);
    List<int> path;

    if (m !== null) {
      path = m.getPath(child);
      m.removeFromSelection(path);
      m.removeFromOpenPaths(path);
    }

    _children.removeRange(index, 1);

    if (child is DefaultTreeNode) {
      final DefaultTreeNode c = child;
      c._parent = null;
    }

    if (m !== null)
      m.sendEvent_(new TreeDataEvent(DataEventType.INTERVAL_REMOVED, path, 1));
    return child;
  }

  String toString() => "DefaultTreeNode($data)";
}
