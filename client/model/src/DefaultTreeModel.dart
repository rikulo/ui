//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 11, 2012 12:39:08 PM
// Author: tomyeh

/**
 * The default implementation of [TreeModel].
 * It assumes each node of the tree is an instance of [TreeNode].
 *
 * ##Big Tree##
 *
 * To implement a big tree, it is better to load the children only when they
 * are required. It is called Lazy Loading.
 * Lazy loading is a characteristic of an application when the actual loading and
 * instantiation of a class is delayed until the point just before the instance is actually used.
 *
 * To implement Lazy Loading, you shall override both [getChild] and [getChildCount],
 * and initialize the child tree nodes when one of these two methods is called for a given
 * node.
 */
class DefaultTreeModel<E> extends AbstractTreeModel<TreeNode<E>> {
  DefaultTreeModel(TreeNode<E> root, [Set<List<int>> selection, Set<List<int>> open, bool multiple=false]):
  super(root, selection, open, multiple) {
    final TreeNode<E> p = root.parent;
    if (p !== null)
      throw new ModelException("Only root node is allowed, not ${root}");
    root.model = this;
  }

  TreeNode<E> getChild(TreeNode<E> parent, int index)
  => parent.getChildAt(index);
  int getChildCount(TreeNode<E> parent)
  => parent.childCount;
  bool isLeaf(TreeNode<E> node)
  => node.isLeaf();

  //optional but provided for better performance
  int getIndexOfChild(TreeNode<E> parent, TreeNode<E> child)
  => parent === child.parent ? child.index: -1;

  //optional but provided for better performance
  List<int> getPath(TreeNode<E> child) {
    List<int> path = new List();
    for (;;) {
      final TreeNode<E> parent = child.parent;
      if (parent === null)
        break; //child is not in the same model

      path.insertRange(0, 1, child.index);
      child = parent;
    }
    return path;
  }
}
