//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 11, 2012 12:39:08 PM
// Author: tomyeh

/**
 * The default implementation of [TreeModel].
 * It assumes each node of the tree is an instance of [TreeNode].
 *
 * Example,
 *
 *    DefaultTreeModel<String> model = new DefaultTreeModel(nodes: [
 *      "Wonderland",
 *      new TreeNode("Australia",
 *        ["Sydney", "Melbourne", "Port Hedland"]),
 *      new TreeNode("New Zealand",
 *        ["Cromwell", "Queenstown"])]);
 *    model.addToSelection(model.root[1][2]);
 *    model.on.select.add((event) {
 *      //do something when it is selected
 *    });
 *
 * ##Big Tree
 *
 * To implement a big tree, it is better to load the children only when they
 * are required. It is called Lazy Loading.
 * Lazy loading is a characteristic of an application when the actual loading and
 * instantiation of a class is delayed until the point just before the instance is actually used.
 *
 * To implement Lazy Loading, you can implement a tree node by extending [DefaultTreeNode]
 * and then override [DefaultTreeNode.loadLazily_] to return the initial child nodes.
 */
class DefaultTreeModel<E> extends AbstractTreeModel<TreeNode<E>> {
  /** Constructor.
   *
   * Notice that a tree node ([TreeNode]) can't be shared in two tree model.
   *
   * + [root]: the root. If not specified, a default tree node will be instantiated.
   * + [nodes] is a collection of nodes to add. Any element of it can
   * be [TreeNode] or the data.
   * + [selection]: if not null, it will be used to hold the selection.
   * Unlike [set selection], it won't make a copy.
   * + [disables]: if not null, it will be used to hold the list of disabled items.
   * Unlike [set disables], it won't make a copy.
   * + [opens]: if not null, it will be used to hold the list of opened items.
   * Unlike [set opens], it won't make a copy.
   */
  DefaultTreeModel([TreeNode<E> root, Collection nodes, Set<TreeNode<E>> selection,
  Set<TreeNode<E>> disables, Set<TreeNode<E>> opens, bool multiple=false]):
  super(root !== null ? root: (root = new TreeNode()), selection, disables, opens, multiple) {
    final TreeNode<E> p = root.parent;
    if (p !== null)
      throw new ModelException("Only root node is allowed, not ${root}");
    root.model = this;
    if (nodes !== null)
      root.addAll(nodes);
  }

  TreeNode<E> getChild(TreeNode<E> parent, int index) => parent[index];
  int getChildCount(TreeNode<E> parent) => parent.length;
  bool isLeaf(TreeNode<E> node) => node.isLeaf();

  //Additional API//
	/**
	 * Returns the index of the given child in the given parent.
	 * If either parent or child is null, returns -1.
	 * If either parent or child don't belong to this tree model, returns -1. 
	 *
	 * This method is designed for use in application. The impelmentation of a view
	 * shall access API available in [TreeModel]
	 *
	 * + [parent] is a node in the tree, obtained from [root] or [getChild].
	 * + [child] the node we are interested in 
	 */
  int getIndexOfChild(TreeNode<E> parent, TreeNode<E> child)
  => parent === child.parent ? child.index: -1;

	/**
	 * Returns the path from the given child, where the path indicates the child is
	 * placed in the whole tree.
	 *
	 * This method is designed for use in application. The impelmentation of a view
	 * shall access API available in [TreeModel]
	 */
  List<int> getPath(TreeNode<E> child) { //optional but provided for better performance
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
