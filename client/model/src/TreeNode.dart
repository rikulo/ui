//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 11, 2012 12:38:52 PM
// Author: tomyeh

/**
 * Represents a tree node that can be used with [DefaultTreeModel].
 * [DefaultTreeModel] assumes each node is an instance of [TreeNode].
 *
 * Notice the tree node has to implement [Hashable] if the selection will be
 * used.
 */
interface TreeNode<T> default DefaultTreeNode<T> {
  /** Constructor.
   *
   * + [nodes] is a collection of nodes to add. Any element of it can
   * be [TreeNode] or the data. Refer to [addAll] for more information.
   * + [leaf] specifies whether this node is a leaf node.
   * If null, whether this node is a leaf node is decided automatically
   * based on whether it has no child at all.
   */
  TreeNode([T data, Collection nodes, bool leaf]);

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
  bool isLeaf();

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
   *     node.addAll([new TreeNode("group", ["item1", "item2"])]);
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
