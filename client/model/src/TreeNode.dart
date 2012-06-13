//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 11, 2012 12:38:52 PM
// Author: tomyeh

/**
 * Represents a tree node that can be used with [DefaultTreeModel].
 * [DefaultTreeModel] assumes each node is an instance of [TreeNode].
 */
interface TreeNode<E> default DefaultTreeNode<E> {
  /** Constructor.
   *
   * + [leaf] specifies whether this node is a leaf node.
   * If null, whether this node is a leaf node is decided automatically
   * based on whether it has no child at all.
   */
  TreeNode([bool leaf]);

  /** Returns the tree model this node belongs to.
   */
  DefaultTreeModel<E> get model();
  /** Sets the tree model it belongs to.
   * This method is invoked automatically by [DefaultTreeModel],
   * so you don't have to invoke it.
   *
   * It can be called only if this node is a root. If a node has a parent,
   * its model shall be the same as its parent.
   */
  void set model(DefaultTreeModel<E> model);

  /** Returns the application-specific data held in this node.
   */
  E get data();
  /** Sets the application-specific data held in this node.
   */
  void set data(E data);

  /** Returns true if this node is a leaf.
   */
  bool isLeaf();

  /**
   * Returns the child ([TreeNode]) at the given index.
   */
  TreeNode<E> getChildAt(int childIndex);
  /**
   * Returns the number of children [TreeNode]s this node contains.
   */
  int get childCount();
  /**
   * Returns the parent [TreeNode] of this node.
   */
  TreeNode<E> get parent();
  /**
   * Returns the index of this node.
   * If this node does not have any parent, 0 will be returned.
   */
  int get index();

  /** Adds child to this node.
   *
   * + [index] the index that [child] will be added at.
   * If null, [child] will be added to the end.
   */
  void add(TreeNode<E> child, [int index]);
  /** Removes the child at index from this node.
   *
   * This method returns the tree node being removed.
   */
  TreeNode<E> remove(int index);
  /** Removes all children nodes.
   */
  void clear();
}
